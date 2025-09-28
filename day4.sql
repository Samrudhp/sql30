-- GROUP BY – The Concept
-- Purpose: Summarize data by categories (groups).

-- syntax 
/*SELECT column_to_group_by, AGG_FUNCTION(column) AS alias
FROM table
GROUP BY column_to_group_by;
*/

-- HAVING – Filtering Groups
-- HAVING filters results after aggregation, unlike WHERE which filters rows before grouping.

-- | Function                      | Use Case                          |
-- | ----------------------------- | --------------------------------- |
-- | `COUNT(*)`                    | Count all rows in a group         |
-- | `COUNT(column)`               | Count non-NULL values in a column |
-- | `SUM(column)`                 | Total of numeric column           |
-- | `AVG(column)`                 | Average of numeric column         |
-- | `MIN(column)` / `MAX(column)` | Find extremes per group           |

show databases;
use sql30;
show tables;
desc Employees;

-- 1 : Find the total salary per department.

select dept_id, sum(salary) as total_salary 
from Employees 
group by dept_id;

-- SUM(salary) → adds all salaries within each department.
-- GROUP BY dept_id → groups employees by department.
-- Alias total_salary → makes output readable.

-- 2 : Find the number of employees per department.

select dept_id, count(*) as total_employees 
from Employees 
group by dept_id;
-- or 
select dept_id, count(dept_id) as total_employees 
from Employees 
group by dept_id;

-- but using count(*) safer than count(dept_id) if null values present in coln

-- 3 : Find the average salary per department.

select dept_id, avg(salary) as avg_salary 
from Employees 
group by dept_id; 

-- 4 : Find departments where the total salary > 10000.

select dept_id , sum(salary) as total_salary from Employees group by dept_id having total_salary > 10000;
-- or 
select dept_id, sum(salary) as total_salary 
from Employees 
group by dept_id 
having sum(salary) > 10000;

-- Use WHERE to filter individual rows before aggregation.
-- Use HAVING to filter groups after aggregation.
-- Combining WHERE + GROUP BY + HAVING is powerful for reporting queries.

-- 5 : Find the average salary per department but only for departments with more than 1 employee.

select dept_id, avg(salary) as avg_salary 
from Employees 
group by dept_id 
having count(*) > 1;
-- Why HAVING, not WHERE: COUNT(*) is an aggregate, and aggregates cannot be filtered with WHERE.

-- 6 : Find the total salary and number of employees per department only for departments with average salary > 5000.

select dept_id , sum(salary) as total_salary, count(*) as number_of_employees 
from Employees 
group by dept_id
having avg(salary) > 5000;

-- GROUP BY dept_id → groups employees by department.
-- SUM(salary) → total salary per department.
-- COUNT(*) → number of employees per department.
-- AVG(salary) → average salary per department.
-- HAVING AVG(salary) > 5000 → filters only departments whose average salary exceeds 5000.


-- 7 : Find departments where the number of employees > 1 and average salary > 5000.

select dept_id , count(*) as no_of_employees , avg(salary) as avg_salary 
from Employees 
group by dept_id 
having (count(*) > 1 and avg(salary) > 5000);
-- Always verify your logic: are you filtering rows before aggregation (WHERE) or groups after aggregation (HAVING)?

-- 8 : Find the minimum and maximum salary per department.
select dept_id, max(salary) as max_salary , min(salary) as min_salary 
from Employees 
group by dept_id;

-- 9 : Find departments where average salary > overall company average salary (just assume overall avg is 5700)
select dept_id , avg(salary) as avg_salary 
from Employees 
group by dept_id 
having avg(salary) > 5700;
-- HAVING AVG(salary) > 5700 → filters groups with average salary greater than overall average.

-- 10 : Find total salary, employee count, min and max salary per department for departments with more than 1 employee and average salary > 5000.

select sum(salary) as total_salary , count(*) as employee_count, min(salary) as min_salary , max(salary) as max_salary 
from Employees
group by dept_id
having (count(*) > 1 and avg(salary) > 5000);





