-- Q2

update Employees
set salary = 0.8 * salary
where age < 25;

-- update through view
create or replace view young_employees(ename, salary)
as
    select ename, salary
    from employees
    where age < 25
;

update young_employees
set salary = 0.8 * salary;

-- Q3

update Employees
set salary = salary * 1.1
where eid in
(
    select eid
    from worksin w
    join departments d on (w.did = d.did)
    where dname = 'Sales'
);


-- update through view

create or replace view sales_employees(eid)
as
    select eid
    from worksin w
    join departments d on (w.did = d.did)
    where dname = 'Sales'
;

update Employees
set salary = salary * 1.1
where eid in
(
    select eid from sales_employees
);