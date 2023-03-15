-- Types of Returns
create or replace function A() returns setof text
as $$
begin
    return next 'hi';
    return;
    return next 'hihi';
end;
$$ language plpgsql;

-- Custom Tuple
create or replace function A() returns setof beers
as $$
begin
    return next (1, 'lala'::varchar(50), 2);
end;
$$ language plpgsql;

-- Write a PLpgSQL function that takes a string as a argument and finds all employees that contain that string in their name
create or replace function Q1(_partial_name text) returns setof text
as $$
begin
    return query
    select ename
    from employees
    where ename ~* _partial_name;
end;
$$ language plpgsql;

-- Write a PLpgSQL function that takes an partial department name, print info on the department.

-- Use the following format (note that employees are in alphabetical order):

-- Department: Sales
-- Budget: $5000000
-- Employees: Max + Maria + Susan

create or replace view emps_and_deps(did, dname, ename)
as
    select d.did, d.dname, e.ename
    from employees e
    join worksin wi on (wi.eid = e.eid)
    join departments d on (wi.did = d.did)
;

create or replace function Q2(_partial_department_name text) returns setof text
as $$
declare
    _d departments;
    _emps text;
begin
    for _d in 
        select *
        from departments
        where dname ~* _partial_department_name
    loop
        return next 'Department: ' || _d.dname;
        return next 'Budget: ' || _d.budget;

        select string_agg(ename, ' + ')
        into _emps
        from emps_and_deps
        where did = _d.did;

        return next 'Employees: ' || _emps;

        return next '';

    end loop;
end;
$$ language plpgsql;