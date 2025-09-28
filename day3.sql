use sql30;

desc Employees;

-- 1 : Find the total salary of all employees. 
-- (Aggregate functions without GROUP BY operate on the entire dataset.)
select sum(salary) as total_salary from Employees;

-- 2 : Count the number of employees in the table.
select count(*) as total_employees  from Employees;

-- 3 : Find the average salary per department.
select avg(salary) as avg_salary_of_department , dept_id  from Employees group by dept_id;

-- 4 : Find the total salary per department, but show only departments where total salary > 10000 using HAVING.
-- (Avoid confusing WHERE and HAVING – WHERE filters rows before aggregation, HAVING filters after aggregation.)
select dept_id , sum(salary) as total_salary 
from Employees 
group by dept_id 
having sum(salary) > 10000;

-- 5 : Count the number of employees per department with salary > 5000.
-- (Filtering before aggregation with WHERE is efficient.
-- Use HAVING only when you need conditions after aggregation, e.g., total salary > 10000.)
select dept_id , count(*) as emp_count  from Employees 
where salary > 5000 
group by dept_id; 

-- 6 : Find the average salary per department, but exclude departments with fewer than 2 employees using HAVING.
select dept_id, avg(salary) from Employees group by dept_id having count(*) >= 2 ;

-- 7 : Find employees who earn more than the average salary of their department.
select e.first_name , e.salary, e.dept_id 
from Employees e
where e.salary > (
                   select avg(salary)
                   from Employees
                   where dept_id = e.dept_id
				);


-- 8 : Find the department(s) with the highest total salary.

SELECT dept_id, SUM(salary) AS total_salary
FROM Employees
GROUP BY dept_id
HAVING SUM(salary) = (
    SELECT MAX(total_dept_salary)
    FROM (
        SELECT SUM(salary) AS total_dept_salary
        FROM Employees
        GROUP BY dept_id
    ) AS dept_totals
);

-- 9 : Find employees who earn more than at least one employee in department 20.

select * from Employees where salary > any (select salary from Employees where dept_id = 20);

-- 10 : Find employees who earn more than all employees in department 10.

select * from Employees where salary > all (select salary from Employees where dept_id = 10);

