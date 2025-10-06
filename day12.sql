create database sqla;
use sqla;

CREATE TABLE students (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    dept_id INT
);

INSERT INTO students VALUES
(1, 'Alice', 101),
(2, 'Bob', 102),
(3, 'Charlie', 101),
(4, 'Diana', 103),
(5, 'Evan', NULL);

CREATE TABLE departments (
    id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

INSERT INTO departments VALUES
(101, 'Computer Science'),
(102, 'Mechanical Engineering'),
(103, 'Electrical Engineering'),
(104, 'Civil Engineering');


CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    dept_id INT
);

INSERT INTO courses VALUES
(1001, 'Data Structures', 101),
(1002, 'Operating Systems', 101),
(1003, 'Thermodynamics', 102),
(1004, 'Circuit Analysis', 103),
(1005, 'Structural Design', 104);


SELECT * FROM students;
SELECT * FROM departments;
SELECT * FROM courses;

-- 1 : Fetch each student’s name, course name, and department name using Students, Enrollments, Courses, and Departments.
select s.name , c.course_name , d.dept_name 
from students s
join departments d on s.dept_id = d.id
join courses c on d.id = c.dept_id;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    manager_id INT
);

INSERT INTO employees VALUES
(1, 'Alice', NULL),
(2, 'Bob', 1),
(3, 'Carol', 1),
(4, 'David', 2),
(5, 'Eve', 2);


-- 2 : Show each employee along with their manager’s name.
SELECT 
    e.emp_name AS employee,
    m.emp_name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id;

-- 3 : CROSS JOIN (Cartesian Product)
SELECT 
    s.name AS student_name,
    c.course_name
FROM students s
CROSS JOIN courses c;
