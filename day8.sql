use sql30;

-- CORRELATED SUBQUERIES

-- Non-correlated → inner query runs once, independent of outer rows.
-- Correlated → inner query depends on each row of the outer query.

-- 1 : Find employees who earn more than the average salary of their own department.
select e.dept_id , e.emp_id , e.first_name ,e.salary
from Employees e 
where salary > (
	select avg(e2.salary) 
    from Employees e2
    where e.dept_id = e2.dept_id
);

-- 2 : Find employees who have the highest salary in their department.
select e.dept_id , e.emp_id , e.first_name , e.salary
from Employees e
where e.salary = (
	select max(e2.salary)
    from Employees e2
    where e.dept_id = e2.dept_id
);

-- 3 : Find employees whose salary is greater than at least one other employee in their department.
select e.dept_id , e.first_name , e.emp_id , e.salary
from Employees e
where e.salary > any(
	select e2.salary 
    from Employees e2
    where e.dept_id = e2.dept_id
);

-- 4 : Find employees who earn the lowest salary in their department
select e.dept_id , e.first_name , e.emp_id , e.salary
from Employees e
where e.salary = (
	select min(e2.salary)
    from Employees e2
    where e.dept_id = e2.dept_id
);

-- 5 : Find departments that have more employees than the company-wide average number of employees per department.
select d.dept_id , d.dept_name
from Departments d
where (
	select count(*)           -- correlated
    from Employees e
    where d.dept_id = e.dept_id 
    ) > (
		select avg(dept_count)    -- non correlated
		from (
			select count(*) as dept_count
			from Employees
			group by dept_id
		) sub
);

-- 6 : Find employees whose salary is above the average salary of their department.
select e.emp_id, e.dept_id ,e.salary
from Employees e
where e.salary > (
	select avg(e2.salary)
    from Employees e2
    where e.dept_id = e2.dept_id
); 

-- 7 : Find employees who earn more than the average salary of the entire company, but also show their department name.
select e.emp_id , e.dept_id , d.dept_name , e.first_name
from Employees e
join Departments d on e.dept_id = d.dept_id 
where e.salary > (
	select avg(salary) 
    from Employees 
);


