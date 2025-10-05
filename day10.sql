use sql30;

-- A window function lets you calculate aggregates or rankings without losing row-level detail.
-- Unlike GROUP BY, it doesn’t collapse rows — it just adds extra computed columns.
-- Think of it as:
-- “I want to see every row, but also know that row’s context within its group.”

-- | `GROUP BY`                          | `Window Function`              |
-- | ----------------------------------- | ------------------------------ |
-- | Reduces rows                        | Keeps all rows                 |
-- | Returns one row per group           | Returns one row per record     |
-- | Can’t mix detail + aggregate easily | Designed to show both together |


-- A : AGGREGATE WINDOWS AS WINDOWS

-- 1 : SUM() as a Window Function
select dept_id, first_name, salary, 
sum(salary) over(partition  by dept_id) as total_dept_salary
from Employees;

-- 2 : AVG() as a Window Function
select dept_id, first_name , salary,
avg(salary) over(partition by dept_id ) as avg_dept_salary
from Employees;

-- 3 : MAX() and MIN()
select dept_id , first_name , salary,
min(salary) over(partition by dept_id ) as min_dept_salary,
max(salary) over(partition by dept_id ) as max_dept_salary
from Employees;

-- 4 : COUNT() as a Window Function
select dept_id , first_name , salary, 
count(*) over(partition by dept_id) as num_employees
from Employees;

-- B : Ranking WINDOW functions
-- | Function           | Meaning                           | Handles Ties?        | Behavior Example |
-- | ------------------ | --------------------------------- | -------------------  | ---------------- |
-- | **`ROW_NUMBER()`** | Sequential number of each row     | ❌ No (ties ignored) | 1, 2, 3, 4 …     |
-- | **`RANK()`**       | Rank with gaps when ties exist    | ✅ Yes               | 1, 2, 2, 4 …     |
-- | **`DENSE_RANK()`** | Rank without gaps when ties exist | ✅ Yes               | 1, 2, 2, 3 …     |


-- 1 : ROW_NUMBER() :: Use when you need a unique ordering (pagination, sampling).
select first_name , dept_id , salary,
row_number() over(partition by dept_id order by salary) as row_num_per_dept
from Employees;

-- 2 : RANK() :: 
select first_name , dept_id , salary,
rank() over (partition by dept_id order by salary) as rank_in_dept
from Employees;

-- 3 : DENSE_RANK() ::
select first_name , dept_id , salary,
dense_rank() over (partition by dept_id order by salary) as dense_rank_in_dept
from Employees;

-- 4 : NTILE(n):
select first_name , dept_id , salary,
ntile(4) over (partition by dept_id order by salary) as percentile_salary_in_dept
from Employees;

-- C : Value Window Functions

-- | Function             | What it does                         | Typical Use                 |
-- | -------------------- | ------------------------------------ | --------------------------- |
-- | `LAG(expr, offset)`  | Looks **backward** N rows            | Compare current vs previous |
-- | `LEAD(expr, offset)` | Looks **forward** N rows             | Forecast or preview next    |
-- | `FIRST_VALUE(expr)`  | Returns **first value** in partition | Anchor to earliest row      |
-- | `LAST_VALUE(expr)`   | Returns **last value** in partition  | Anchor to latest row        |

-- 1 : LAG() : Compare growth → salary - LAG(salary).
select first_name , dept_id , salary,
lag(salary, 1) over (partition by dept_id order by salary) as prev_salary
from Employees;
-- Within each department, rows are ordered by salary.
-- For each row, SQL retrieves the previous row’s salary.
-- If no previous row exists → returns NULL.

-- 2 : LEAD()
select first_name , dept_id , salary,
lead(salary,1) over (partition by dept_id order by salary) as next_salary
from Employees;

-- 3 : FIRST_VALUE() and LAST_VALUE()
select first_name , dept_id , salary,
first_value(salary) over (partition by dept_id order by salary desc) as highest_salary_in_dept,
last_value(salary) over (partition by dept_id order by salary desc 
						RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as lowest_salary_in_dept
from Employees;
-- FIRST_VALUE() returns top salary (highest) within each dept.
-- LAST_VALUE() returns lowest, but you must extend the window frame
-- (RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
-- so it can see all rows.

-- C : Statistical / Cumulative Window Functions

-- 1 : CUME_DIST()
-- Meaning:
-- Gives the cumulative distribution up to the current row — i.e.,
-- “What fraction of rows have a value less than or equal to this one?”

select first_name , dept_id ,
cume_dist() over (order by salary) as cum_dist
from Employees;

-- 2 : PERCENT_RANK()
-- Gives the relative rank of each row as a percentage between 0 and 1.
select first_name , dept_id , salary,
percent_rank() over (order by salary) as per_rank
from Employees;

-- | Function         | Measures            | Range | Includes Current Row?          | Use For              |
-- | ---------------- | ------------------- | ----- | ------------------------------ | -------------------- |
-- | `PERCENT_RANK()` | Relative position   | 0 → 1 | ❌ (excludes itself in formula)| Percentile-like rank |
-- | `CUME_DIST()`    | Cumulative fraction | 0 → 1 | ✅ (includes itself)           | Cumulative coverage  |

																
