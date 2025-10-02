-- 1. EXISTS
-- What it does: Checks if the subquery returns at least one row.
-- When to use: When you don’t care about the actual values from subquery, only whether something exists.

-- 2. NOT EXISTS
-- What it does: Opposite of EXISTS. True only if subquery returns zero rows.
-- When to use: To find missing or unmatched records.

-- 3. ANY
-- What it does: Compares a value to any value returned by subquery.
-- Often used with =, <, >.

-- 4. ALL
-- What it does: Compares a value to all values returned by subquery.
-- True only if condition holds against every returned value.

-- EXISTS → Does a row exist? (boolean test, fast)
-- NOT EXISTS → Are there no rows?
-- ANY → Compare to at least one result.
-- ALL → Compare to every result.

use sql30;

-- 1 : Find departments that have at least one employee.
select d.dept_id , d.dept_name
from  Departments d
where exists (
	select 1 
    from Employees e
    where e.dept_id = d.dept_id
);

-- 2 :  Find departments that have no employees.
select d.dept_id , d.dept_name
from  Departments d
where not exists (
	select 1 
    from Employees e
    where e.dept_id = d.dept_id
);

-- 3 : Find employees whose salary is greater than the salary of any employee in department 10
select e.emp_id , e.dept_id , e.first_name , e.salary
from Employees e
where e.salary > any (
	select salary 
    from Employees
    where dept_id = 10
);


-- 4 : Find employees whose salary is greater than the salary of all employees in department 10
select e.emp_id , e.dept_id , e.salary
from Employees e
where e.salary > all (
	select salary 
    from Employees 
    where dept_id = 10
);

-- 5 : Find employees who belong to departments that have at least one employee earning more than 6000.
select e.emp_id, e.salary, e.dept_id 
from Employees e
where exists (
	select 1 
    from Employees e2
    where e.dept_id = e2.dept_id 
    and  e2.salary > 6000
);

-- 6 : Find employees who belong to departments where no employee earns more than 6000.
select e.emp_id, e.salary, e.dept_id 
from Employees e
where not exists (
	select 1 
    from Employees e2
    where e.dept_id = e2.dept_id 
    and  e2.salary > 6000
);

-- 7 : Find employees whose salary is higher than all other employees in their department.
select e.emp_id , e.dept_id , e.salary, e.first_name
from Employees e
where e.salary > all(
	select salary 
    from Employees e2
    where e.dept_id = e2.dept_id and e.emp_id <> e2.emp_id
);

-- 8 : Find employees who earn more than any employee in department 20, but are not in department 20 themselves.
select e.emp_id , e.dept_id , e.salary 
from Employees e
where e.salary > any (
	select salary 
    from Employees e2
    where dept_id = 20
) and e.dept_id <> 20; -- <> means not equal and also can use not in (20)

-- 9 : Find employees who belong to departments that have at least one employee earning more than 6500, and display their department name.
select e.emp_id , e.dept_id , d.dept_name 
from Employees e
join Departments d on e.dept_id = d.dept_id
where exists (
	select 1
    from Employees e2 
    where e2.dept_id = e.dept_id and e2.salary > 6500
);

-- 10 : Find employees whose salary is higher than all employees in department 10, and also display their department name.
select e.dept_id , e.salary , d.dept_name
from Employees e
join Departments d on e.dept_id = d.dept_id
where e.salary > all (
	select salary
    from Employees
    where dept_id = 10
);