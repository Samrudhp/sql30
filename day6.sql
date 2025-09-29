-- MULTIPLE TABLE QUERY USING JOINS

show databases;
use sql30;

desc Employees;

create table Departments(
	dept_id int primary key,
    dept_name varchar(50)
);

INSERT INTO Departments (dept_id, dept_name) VALUES
(10, 'HR'),
(20, 'Engineering'),
(30, 'Marketing');

-- INNER JOIN → keeps only matches.
-- LEFT JOIN → keeps all left table rows (even if no match).
-- RIGHT JOIN → keeps all right table rows.
-- FULL JOIN → keeps everything from both.

desc Departments;

-- 1 : Get each department’s name + number of employees

select d.dept_name , count(e.emp_id) as emp_count
from Employees e
join Departments d on e.dept_id = d.dept_id
group by d.dept_name;

-- 2 : Find the average salary per department, showing the department name.
select d.dept_name , avg(e.salary) as avg_salary_per_dept 
from Employees e
join Departments d on e.dept_id = d.dept_id
group by dept_name;

-- 3 : Find departments where the average salary is greater than 5000.
select d.dept_name , avg(e.salary) as avg_salary 
from Employees e
inner join Departments d on e.dept_id = d.dept_id
group by d.dept_name 
having avg(e.salary) > 5000;
-- WHERE filters before grouping.
-- HAVING filters after grouping (on aggregate results).
-- That’s why we need HAVING here, not WHERE.
-- SQL first groups, then computes averages, then filters out groups that don’t qualify.


-- 4 : Find each department’s highest-paid employee name along with their salary.
select d.dept_name , e.first_name , e.last_name , e.salary
from Employees e
join Departments d on e.dept_id = d.dept_id
where e.salary = (
	select max(e2.salary)
    from Employees e2
    where e2.dept_id = e.dept_id
);
-- For each department bucket, go inside and pick out the single row with the top salary.

-- 5 : List departments that have more than 1 employee, showing department name and employee count.
select d.dept_name , count(e.emp_id) as employee_count 
from Employees e
join Departments d on e.dept_id = d.dept_id
group by d.dept_name 
having count(e.emp_id) > 1;

-- 6 : Find all departments and the total salary of employees in each, including departments with no employees.

select d.dept_name , sum(e.salary) as total_salary 
from Departments d
left join Employees e  on e.dept_id = d.dept_id
group by d.dept_name;

-- 7 : Find all employees and their department names, but also include any departments that might exist without employees.
select d.dept_name , e.first_name as first_name 
from Employees e
right join Departments d on e.dept_id = d.dept_id;


-- 8 : Find all departments and the number of employees in each, including:
-- Departments with no employees
-- Employees whose dept_id doesn’t match any department

SELECT d.dept_name, COUNT(e.emp_id) AS employee_count
FROM Departments d
LEFT JOIN Employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name

UNION

SELECT d.dept_name, COUNT(e.emp_id) AS employee_count
FROM Departments d
RIGHT JOIN Employees e ON d.dept_id = e.dept_id
WHERE d.dept_id IS NULL;

CREATE TABLE Projects (
    project_id INT,
    project_name VARCHAR(50),
    dept_id INT
);

INSERT INTO Projects VALUES
(101, 'Website Revamp', 20),
(102, 'Recruitment Drive', 10),
(103, 'Marketing Campaign', 30),
(104, 'Secret Project', 40);

select * from Projects;
-- 9 : Find departments with total employee salary > 10000 and list their projects.
select d.dept_name , p.project_name , sum(e.salary) as total_salary
from Departments d
left join Employees e on d.dept_id = e.dept_id
left join Projects p on d.dept_id = p.dept_id
group by d.dept_name, p.project_name 
having sum(e.salary) > 10000;

-- 10 : Find the top 2 highest-paid employees in each department, showing: employee name, salary, and department name
SELECT dept_name, first_name, last_name, salary
FROM (
    SELECT d.dept_name, e.first_name, e.last_name, e.salary,
           @rn := IF(@current_dept = d.dept_id, @rn + 1, 1) AS rn,
           @current_dept := d.dept_id
    FROM Employees e
    JOIN Departments d ON e.dept_id = d.dept_id
    CROSS JOIN (SELECT @rn := 0, @current_dept := 0) vars
    ORDER BY d.dept_id, e.salary DESC
) t
WHERE rn <= 2;







