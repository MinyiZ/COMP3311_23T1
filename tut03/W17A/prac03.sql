-- Which employee works the longest hours each week?
select * from employees
where hourspweek = (select max(hourspweek) from employees);

-- What is the family name of the manager of the Sales department?
select familyname from departments d
join employees e on (e.tfn = d.manager)
where name = 'Sales';

-- How many hours per week does each employee spend in each department?
select d.name as department, concat(givenname, ' ',  familyname) as name, (hourspweek * percentage / 100) as hours from worksfor w
join employees e on (w.employee = e.tfn)
join departments d on (d.id = w.department);