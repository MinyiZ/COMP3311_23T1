-- q1
create assertion manager_works_in_department
check (not exist (
    select *
    from Department d
    join Employee e on (d.manager = e.id)
    where e.works_in <> d.id
));

-- q2
create assertion employee_manager_salary
check (not exist (
    select *
    from Employee e
    join Departments d on (d.id = e.works_in)
    join Employee m on (d.manager = m.id)
    where e.salary > m.salary
));

