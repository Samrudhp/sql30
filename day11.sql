use sql30;
-- Advanced window functions

-- 1 : Compare Salary to Department Average
select e.first_name , e.dept_id , e.salary,
avg(e.salary) over (partition by e.dept_id ) as avg_salary_of_dept,
e.salary - avg(e.salary) over (partition by e.dept_id) as salary_diff
from Employees e;
-- You’re computing a group aggregate but keeping all rows.
-- Unlike GROUP BY, which collapses rows, windows retain context.

-- 2 : Rank Employees by Salary Within Department
select first_name , dept_id , salary,
rank() over (partition by dept_id order by salary) as rank_in_dept
from Employees;

-- 3 : Get Top 2 Earners per Department
select * from (
	select first_name , dept_id,
		rank() over (partition by dept_id order by salary desc) as rnk
		from Employees
) ranked
where rnk <= 2;
-- Instead of collapsing with GROUP BY or writing nested subqueries, 
-- you calculate the rank once using the window, then simply filter on it—fast, readable, and efficient.

-- 4 : Calculate Running Total of Salaries by Department
select first_name , dept_id , salary,
sum(salary) over (partition by dept_id order by salary desc ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as total_salary
from Employees;

-- 5 : Percentile Rank of Salaries per Department
select first_name , dept_id, salary,
percent_rank() over (partition by dept_id order by salary desc) as per_rank
from Employees;
-- 💡 Intuition
-- This is helpful in performance benchmarking — for example, to know who’s in the top 10% of earners per department.

-- 6 : Salary Compared to Previous Employee in Department (LAG)
select first_name , dept_id , salary,
lag(salary, 1) over (partition by dept_id order by salary) as prev_salary
from Employees;

-- 7 : Salary Compared to Department Average + Rank (Combined)
select first_name , dept_id , salary,
avg(salary) over (partition by dept_id order by salary desc) as avg_salary_per_dept,
rank() over (partition by dept_id order by salary desc) as rank_per_dept,
salary - avg(salary) over (partition by dept_id order by salary desc) as diff_salary_dept
from Employees;

-- 8 : Top-N Employees with Running Total & Percentile
SELECT *
FROM (
    SELECT 
        emp_id,
        first_name,
        dept_id,
        salary,
        SUM(salary) OVER (PARTITION BY dept_id ORDER BY salary DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total,
        PERCENT_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS percentile_rank,
        RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS salary_rank
    FROM Employees
) combined
WHERE salary_rank <= 3;

-- 9 : Compare Each Employee’s Salary to Department Average
SELECT 
    emp_id,
    first_name,
    dept_id,
    salary,
    AVG(salary) OVER (PARTITION BY dept_id) AS dept_avg_salary,
    salary - AVG(salary) OVER (PARTITION BY dept_id) AS diff_from_avg
FROM Employees;

-- 10 : Find the Top 2 Highest Paid Employees per Department
SELECT
    emp_id,
    first_name,
    dept_id,
    salary,
    RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS salary_rank
FROM Employees
WHERE salary_rank <= 2;


