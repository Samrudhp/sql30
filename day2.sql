use sql30;

desc Employees;

-- 1 : Select all employees with salary > 5500.
select * from Employees where salary > 5500;

-- 2 : Select all employees in department 10 or 20 using IN.
select * from Employees where dept_id in (10,20);

-- 3 : Select employees with salary > 5000 AND in dept_id = 20.
select * from Employees where salary > 5000 and dept_id = 20;

-- 4 : Select employees with dept_id = 10 OR salary > 6000 ('and' has more precendence than 'or', so while to execute 'or' first use ())
select * from Employees where dept_id = 10 or salary > 6000;

-- 5 : Select employees with salary BETWEEN 5000 AND 6000.
select * from Employees where salary between 5000 and 6000;

-- 6 : Select employees whose first_name starts with “J” using LIKE.
select * from Employees where first_name like 'J%';

-- 7 : Select employees whose last_name ends with “n” using LIKE.
select * from Employees where last_name like '%n';

-- 8 : Select employees whose first_name starts with “J” AND salary > 5000
select * from Employees where first_name like 'J%' and salary > 5000;

-- 9 : Select employees whose dept_id is 10 or 20, but exclude salaries below 5500.
select * from Employees where dept_id in (10,20) and salary >= 5500;

-- 10 : Select employees whose first_name starts with “A” OR last_name ends with “s”, and salary between 5000 and 7000. 
--  (Always use parentheses with mixed AND and OR to avoid logical errors.)
select * from Employees where (first_name like 'A%' or last_name like '%s') and salary between 5000 and 7000;