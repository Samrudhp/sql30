show databases;
use sql30;
show tables;

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    dept_id INT,
    salary INT
);

INSERT INTO Employees (emp_id, first_name, last_name, dept_id, salary) VALUES
(1, 'John', 'Doe', 10, 5000),
(2, 'Jane', 'Smith', 20, 6000),
(3, 'Alice', 'Johnson', 10, 5500),
(4, 'Bob', 'Brown', 30, 4500),
(5, 'Carol', 'Davis', 20, 7000);

-- 1 : Select first_name and last_name as fname and lname from the Employees table.
select first_name as fname , last_name as lname from Employees;

-- 2 : Select emp_id and salary from Employees, and rename salary as emp_salary.
select first_name as fname , salary as emp_salary from Employees;

-- 3 : Select a full name by concatenating first_name and last_name as full_name.
select concat(first_name , ' ' , last_name ) as full_name from Employees;

-- 4 : Compute a 10% bonus on salary for each employee and display it as bonus.
select salary , salary* 0.1 as bonus from Employees;

-- 5 : Select only distinct dept_id from the Employees table.
select distinct dept_id from Employees;

-- 6 : Select first_name, salary, and create a new column showing salary after a 5% increase as salary_new.
select first_name , salary , salary + salary * 0.05 as new_salary from Employees;

-- 7 : Select all employees and order them by salary descending.
select * from Employees order by salary desc;

-- 8 : Select first_name and dept_id using a table alias e for Employees.
select e.first_name , e.dept_id from Employees as e;

-- 9 : Select first_name, last_name, and a new column status which says “High Earner” if salary > 6000, else “Average”.
select first_name , last_name , 
    case
		when salary > 6000 then 'High Earner'
        else 'Average'
   end as status
   from Employees;
   
-- 10 : Select full_name (concatenate first_name and last_name) and dept_id, concatenate them with a hyphen as name_dept, and sort by this column.

select concat(first_name , ' ' , last_name, '-' , dept_id) as name_dept from Employees order by name_dept; 
