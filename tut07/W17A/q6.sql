-- a

create function r_pk_check() returns trigger
as $$
begin
    -- not null
    if (new.a is null or new.b is null) then
        raise exception 'Primary key cannot have null';
    end if;

    -- if update function, and primary key not changed, then all good
    if (TG_OP = 'update' and old.a = new.a and old.b = new.b) then
        return new;
    end if;

    -- unique
    select * from R
    where a = new.a and b=new.b;

    if (found) then
        raise exception 'Duplicate primary found';
    end if;

    return new;
end;
$$ language plpgsql;

create trigger r_pk_check_trigger
before insert or update
on R
for each row
execute procedure r_pk_check();

-- b
-- on insert or update to T, check that k is a valid reference to S(x)

create function k_fk_check() returns trigger
as $$
begin
    select *
    from S
    where new.k = x;

    if (not found) then
        raise exception 'Invalid foreign key reference.'
    end if;

    return new;
end;
$$ language plpgsql;

create trigger k_fk_check_trigger
before insert or update
on T
for each row
execute procedure k_fk_check();

-- on delete or update to S, check that there are no references to it from T
create function s_reference_check() returns trigger
as $$
begin
    select *
    from T
    where k = old.x;

    if (found) then 
        raise exception 'Reference still exists in T';
    end if;

    return new;
end;
$$ language plpgsql;

create trigger s_reference_check_trigger
before delete or update
on S
for each row
execute procedure s_reference_check();