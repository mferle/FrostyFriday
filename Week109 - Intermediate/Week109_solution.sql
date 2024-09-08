-- startup code
-- Create a sample database and a table named employee_performance containing columns for employee ID, name, department, performance score, and review date. 
-- Populate this table with sample data for testing 

CREATE OR REPLACE TABLE employee_performance (
emp_id INT,
emp_name VARCHAR,
department VARCHAR,
performance_score NUMBER(5,2),
review_date DATE
);
INSERT INTO employee_performance VALUES
(101, 'Alice Smith', 'Sales', 85.50, '2024-08-30'),
(102, 'Bob Johnson', 'HR', 92.75, '2024-08-29'),
(103, 'Charlie Davis', 'Sales', 88.00, '2024-08-28'),
(104, 'Dana Lee', 'Engineering', 95.20, '2024-08-27'),
(105, 'Eli White', 'HR', 78.90, '2024-08-26');

-- Create a stored procedure named get_employee_performance_by_department that accepts a department name as input 
-- and returns a table with employee ID, name, performance score, and review date for all employees in that department.

create or replace procedure get_employee_performance_by_department(dept_name varchar)
returns table(emp_id int, emp_name varchar, preformance_score number(5,2), review_date date)
as
declare
  res resultset default (select emp_id, emp_name, performance_score, review_date from employee_performance where department = :dept_name);
begin
  return table(res);
end;

-- test the stored procedure by calling it
call get_employee_performance_by_department('Sales');

-- Run a SELECT query that uses the TABLE() function to call the stored procedure in the FROM clause 
-- and retrieve the employee performance data for the Sales department.

select * from table(get_employee_performance_by_department('Sales'));