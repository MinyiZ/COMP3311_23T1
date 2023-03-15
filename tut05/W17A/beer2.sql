create or replace function hotelsIn(_addr text) returns text
as $$
declare
    _res text;
begin
    select string_agg(name::text, e'\n')
    into _res
    from bars
    where addr ~* _addr;

    return _res || e'\n';
end;
$$ language plpgsql;


create or replace function hotelsIn(_addr text) returns text
as $$
declare
    _name text;
    _res text = '';
begin
    for _name in
        select name
        from bars
        where addr ~* _addr
    loop
        _res := _res || _name || e'\n';
    end loop;

    return _res;
end;
$$ language plpgsql;

create or replace function hotelsIn(_addr text) returns text
as $$
declare
    _name text;
    _res text = '';
begin
    for _name in
        select name
        from bars
        where addr ~* _addr
    loop
        _res := _res || _name || '  ';
    end loop;

    if not found then
        return 'There are no hotels in ' || _addr;
    end if;

    return 'Hotels in: ' || _addr || '  ' || _res;
end;
$$ language plpgsql;

create or replace function happyHourPrice(_hotel text, _beer text, _discount numeric) returns text
as $$
declare
    _count integer;
    _price numeric;
    _new_price numeric;
begin
    -- check hotel exists
    select count(*)
    into _count
    from bars
    where name = _hotel;

    if _count = 0 then
        return 'There is no hotel called ' || _hotel;
    end if; 

    -- check beer exists
    perform *
    from beers
    where name = _beer;

    if not found then
        return 'There is no beer called ' || _beer;
    end if;  

    -- grab price of beer at hotel
    select price
    into _price
    from sells s
    join bars ba on (s.bar = ba.id)
    join beers be on (s.beer = be.id)
    where ba.name = _hotel
    and be.name = _beer;

    -- check that beer is sold at hotel
    if not found then 
        return 'The ' || _hotel || ' does not serve ' || _beer;
    end if;

    -- calculate the new price
    _new_price := _price - _discount;

    -- check if price is negative
    if _new_price < 0 then
        return 'Price reduction is too large; ' || _beer || ' only costs ' || to_char(_price,'$9.99');
    end if;
    
    return 'Happy hour price for ' || _beer || ' at ' || _hotel || ' is ' || to_char(_new_price,'$9.99');
end;
$$ language plpgsql;