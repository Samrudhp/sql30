-- SUBQUERIES

-- Types of Subqueries 
-- Single-row subquery → returns one value (e.g., one number, one name).
-- Multi-row subquery → returns multiple values (e.g., a list of IDs).
-- Correlated subquery → inner query depends on outer query row (harder, but powerful).

-- When to use subqueries (instead of JOINs)?
-- When the filtering condition depends on a calculated value (like avg, max, min).
-- When you want to express a query step by step for clarity.
-- They’re slower than JOINs sometimes, but great for readability and breaking complex logic.

-- A non-correlated subquery because the inner query doesn’t depend on the outer row.
-- A correlated subquery because the inner query does  depend on the outer row.

use sql30;
desc Employees;

-- 1 : Find employees whose salary is greater than the average salary of the entire company.
select emp_id , concat(first_name , ' ', last_name) as full_name , salary 
from Employees
where salary > (
	select avg(salary) 
    from Employees
);

-- 2 : Find the employee(s) who earn the maximum salary in the company.
select emp_id , first_name , salary
from Employees
where salary = (
	select max(salary) 
    from Employees
);
-- Inner query: SELECT MAX(salary) FROM Employees; → 7000.
-- Outer query: returns employee(s) with salary = 7000 → Carol Davis.

-- 3 : Find employees who work in the same department as the highest-paid employee.
select emp_id , dept_id , first_name , salary 
from Employees
where dept_id = (
	select dept_id 
    from Employees
    where salary = (
		select max(salary) 
        from Employees
    )
);
-- SELECT MAX(salary) → 7000.
-- Get dept_id of that employee → 20 (Engineering).
-- Outer query → all employees with dept_id = 20.
-- Jane Smith (6000), Carol Davis (7000).

-- 4 : Find employees who earn more than the lowest salary in department 20 (Engineering).
select emp_id , first_name , salary
from Employees
where salary > (
	select min(salary)
    from Employees
    where dept_id = 20
);

-- 5 : Find employees who work in departments where the average salary is greater than 5500.
select emp_id , first_name ,dept_id ,salary 
from Employees 
where dept_id in (
	select dept_id 
    from Employees
    group by dept_id 
    having avg(salary) > 5500
);
-- Inner query gives list → (20).
-- Outer query keeps rows where dept_id IN (20).
-- → Jane Smith (6000), Carol Davis (7000)

-- 6 : Find employees who earn more than any employee in department 30 (Marketing).
select emp_id , first_name , salary
from Employees 
where salary > (
	select max(salary)
    from Employees
    where dept_id = 30
);

-- 7 : Find employees who work in departments where the average salary is greater than 6000
select emp_id , dept_id , salary 
from Employees
where dept_id in (
	select dept_id
    from Employees
    group by dept_id 
    having avg(salary) > 6000
);

-- 8 : Find employees who earn more than the maximum salary in department 10.
select emp_id , first_name , salary
from Employees
where salary > (
	select max(salary)
    from Employees
    where dept_id = 10
);

-- 9 : Find employees whose salary is higher than the average salary of all employees in department 20.
select emp_id , first_name , salary
from Employees 
where salary > (
	select avg(salary)
    from Employees
    where dept_id = 20
);

-- Scalar subqueries – return a single value.
-- Example: salary > (SELECT AVG(salary) FROM Employees)
-- Multi-row subqueries – return a list of values.
-- Example: dept_id IN (SELECT dept_id FROM Employees GROUP BY dept_id HAVING AVG(salary) > 6000)
-- Inner query runs once, independent of outer query → non-correlated.
-- Can be used in WHERE, FROM (as a derived table), or SELECT (as a calculated column





