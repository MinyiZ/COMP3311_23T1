-- on insert into Enrolments, increment numStudes for course
create or replace function insert_student() returns trigger
as $$
begin
    update Course
    set numStudes=numStudes+1;
    where code = new.course;

    return null;
end;
$$ language plpgsql;


create trigger insert_student_trigger
after insert
on Enrolment
for each row
execute procedure insert_student();

-- on delete from Enrolments, decrement numStudes for course
create or replace function delete_student() returns trigger
as $$
begin
    update Course
    set numStudes=numStudes-1;
    where code = new.course;

    return null;
end;
$$ language plpgsql;


create trigger delete_student_trigger
after delete
on Enrolment
for each row
execute procedure delete_student();

-- on update in Enrolments; increment/decrement numStudes accordingly
create or replace function update_student() returns trigger
as $$
begin
    if (old.course = new.course) then
        return null;
    end if;

    update Course
    set numStudes=numStudes-1;
    where code = old.course;

    update Course
    set numStudes=numStudes+1;
    where code = new.course;

    return null;
end;
$$ language plpgsql;


create trigger update_student_trigger
after update
on Enrolment
for each row
execute procedure update_student();

-- if student is switching course, zero out their mark
create or replace function update_student_before() returns trigger
as $$
begin
    if (old.course = new.course) then
        return new;
    end if;

    new.mark = 0;

    return new;
end;
$$ language plpgsql;


create trigger update_student_before_trigger
before update
on Enrolment
for each row
execute procedure update_student_before();

-- on insert into Enrolments, check quota
create or replace function check_quota() returns trigger
as $$
declare
    -- _numStudes int;
    -- _quota int;
    _is_full boolean;
begin
    if (old.course = new.course) then
        return new;
    end if;

    -- select into _numStudes, _quota
    -- numStudes, quota
    select into _is_full
    (numStudes >= quota)
    from Course
    where code = new.course;

    -- if (_numStudes >= _quota) then
    if (_is_full) then
        raise exception 'Quota exceeded, cannot enrol';
    end if;

    return new;
end;
$$ language plpgsql;


create trigger check_quota_trigger
before insert or update
on Enrolment
for each row
execute procedure check_quota();