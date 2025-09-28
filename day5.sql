-- Deep Dive on Aggregates

-- Order of operations matters:
-- WHERE → filters rows
-- GROUP BY → creates groups
-- Aggregates → summarize groups
-- HAVING → filter groups

/* -- 1 COUNT() – Counting Rows / Non-NULLs
Purpose: Count number of rows in a table or per group.
COUNT(*) → counts all rows.
COUNT(column) → counts only non-NULL values.
*/

/*SUM() – Adding Values
Purpose: Total numeric values.
Use for sums per group or overall.*/

/*AVG() – Average Value
Purpose: Mean value of a numeric column.
Automatically ignores NULLs.*/

/* MIN() / MAX() – Finding Extremes
Purpose: Find smallest or largest value. */

-- COUNT vs SUM vs AVG: Think counting vs totaling vs averaging.

-- 1 : Find the total salary, average salary, and number of employees for the entire company (no GROUP BY).
select sum(salary) as total_salary, avg(salary) as avg_salary,  count(*) as no_of_employee 
from Employees ;

/*Aggregates can work with or without GROUP BY.
Without GROUP BY → treats the table as a single group (entire dataset).
With GROUP BY → calculates per group (e.g., per department).*/

-- 2 : Find the minimum and maximum salary of all employees in the company.
select min(salary) as min_salary , max(salary) as max_salary 
from Employees;

-- 3 : Find the total salary and average salary per department, but only for departments with more than 1 employee.
select sum(salary) as total_salary , avg(salary) as avg_salary 
from Employees 
group by dept_id 
having count(*) > 1;

-- 4 : Find departments where the average salary > overall company average salary (overall average = 5600).
select dept_id , avg(salary) as avg_salary 
from Employees 
group by dept_id 
having avg(salary) > 5600;

-- 5 : Find the department-wise salary range (MIN and MAX salary) only for departments where total salary > 10000.
select max(salary) as max_salary, min(salary) as min_salary , sum(salary) as total_salary 
from Employees 
group by dept_id 
having sum(salary) > 10000;

-- 6 : Find departments where average salary > 5000 and employee count > 1, showing:
-- total salary
-- average salary
-- min & max salary
-- employee count

select sum(salary) as total_salary, avg(salary) as avg_salary , min(salary) as min_salary, max(salary) as max_salary , count(*) as emp_count
from Employees
group by dept_id 
having avg(salary) > 5000 and count(*) > 1; 

-- 7 : Find departments with more than 1 employee, showing:
-- total salary
-- employee count
-- salary range (min & max)
-- and average salary > 6000

select sum(salary) as total_salary, avg(salary) as avg_salary , min(salary) as min_salary, max(salary) as max_salary , count(*) as emp_count
from Employees
group by dept_id 
having avg(salary) > 6000 and count(*) > 1;

-- 8 : Find departments where minimum salary < 5500, showing:
-- total salary
-- employee count
-- average salary

select sum(salary) as total_salary, avg(salary) as avg_salary ,  count(*) as emp_count
from Employees
group by dept_id 
having min(salary) < 5500;

-- 9 : Find departments where max salary > 6500 and employee count > 1, showing:
-- total salary
-- min salary
-- average salary

select sum(salary) as total_salary, avg(salary) as avg_salary , min(salary) as min_salary
from Employees
group by dept_id 
having max(salary) > 6500 and count(*) > 1;

-- 10 : Find all departments with:
-- employee count > 1
-- average salary > 5000
-- show total, avg, min, max salaries, and count
-- order the result by average salary descending

select sum(salary) as total_salary, avg(salary) as avg_salary , min(salary) as min_salary
from Employees
group by dept_id 
having avg(salary) > 5000 and count(*) > 1
order by avg(salary) desc;

