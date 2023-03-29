-- a

create function r_pk_check() returns trigger
as $$
begin
    -- a and b not null
    if (new.a not null or new.b not null) then
        raise exception 'Primary key cannot be null';
    end if;

    -- if update operation and primary is unchanged
    if (TG_OP = 'update' and old.a = new.a and old.b = new.b) then
        return new;
    end if;

    -- (a,b) unique
    select * from R
    where a = new.a and b = new.b;

    if (found) then
        raise exception 'Duplicate primary key already in table';
    end if;

    return new;
end;
$$ language plpgsql;

create trigger r_pk_check_trigger
before insert or update
on R
for each row
execute procedure r_pk_check();

-- on insert/update to table T, check that T(k) is a valid foreign key to S(x)
create function t_fk_check() returns trigger
as $$
begin
    -- if update operation does not touch k
    if (TG_OP = 'update' and old.k = new.k) then
        return new;
    end if;

    -- check the references tuple exists in S
    select * from S
    where x = new.k;

    if (not found) then
        raise exception 'Invalid foreign key reference';
    end if;

    return new;
end;
$$ language plpgsql;

create trigger t_fk_check_trigger
before insert or update
on T
for each row
execute procedure t_fk_check();

-- on delete/update to table S, check that no references to S(x) exists in T(k)
create function s_reference_check() returns trigger
as $$
begin
    -- if update operation does not touch x
    if (TG_OP = 'update' and old.x = new.x) then
        return new;
    end if;

    -- check that there are no references to S(x) in T(k)
    select * from T
    where k = old.x;

    if (found) then
        raise exception 'There are still references to the tuple';
    end if;

    return new;
end;
$$ language plpgsql;

create trigger s_reference_check_trigger
before delete or update
on S
for each row
execute procedure s_reference_check();