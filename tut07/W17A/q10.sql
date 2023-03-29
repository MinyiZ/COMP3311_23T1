-- on insert to Enrolment, increment numStudes in Course (1)
create function insert_student() returns trigger
as $$
begin
    update Course
    set numStudes=numStudes+1
    where code = new.course;
end;
$$ language plpgsql;

create trigger insert_student_trigger
after insert
on Enrolment
execute procedure insert_student();

-- on delete to Enrolment, decrement numStudes in Course (2)
create function delete_student() returns trigger
as $$
begin
    update Course
    set numStudes=numStudes-1
    where code = old.course;
end;
$$ language plpgsql;

create trigger delete_student_trigger
after delete
on Enrolment
execute procedure delete_student();

-- on update to Enrolment, decrement numStudes in old course and increment in new course (3)
create function update_student() returns trigger
as $$
begin
    -- (comp1511, min, 0) <- old
    -- (comp1511, min, 50) <- new
    if (old.course = new.course) then
        return null;
    end if;

    update Course
    set numStudes=numStudes-1
    where code = old.course;

    update Course
    set numStudes=numStudes+1
    where code = new.course;
end;
$$ language plpgsql;

create trigger update_student_trigger
after update
on Enrolment
execute procedure update_student();

-- (comp1511, min, 50) <- old
-- (comp1521, min, 50) <- new
-- (comp1521, min, 0) <- new'
-- on update to Enrolment, zero out the mark (4)
create function update_student_clear_mark() returns trigger
as $$
begin
    -- (comp1511, min, 0) <- old
    -- (comp1511, min, 50) <- new
    if (old.course = new.course) then
        return null;
    end if;

    new.mark = 0;
    return new;
end;
$$ language plpgsql;

create trigger update_student_clear_mark_trigger
before update
on Enrolment
execute procedure update_student_clear_mark();

-- on insert to Enrolment, check quota is not reached (5)
create function check_quota() returns trigger
as $$
declare
    -- _numStudes int;
    -- _quota int;

    _is_full boolean;
begin
    if (old.course = new.course) then
        return null;
    end if;

    -- select numStudes, quota
    -- into _numStudes, _quota
    select (numStudes >= quota)
    into _is_full
    from Course
    where code = new.course;

    if (_is_full) then
    -- if (_numStudes >= _quota) then
        raise exception 'Course quota reached, cannot enrol sorry'
    end if;

    return new;
end;
$$ language plpgsql;

create trigger check_quota_trigger
before insert or update
on Enrolment
execute procedure check_quota();