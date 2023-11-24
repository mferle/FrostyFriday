CREATE OR REPLACE table departments (department_name varchar, department_ID int, head_department_ID int);

INSERT INTO departments (department_name, department_ID, head_department_ID) VALUES
    ('Research & Development', 1, NULL),  -- The Research & Development department is the top level.
        ('Product Development', 11, 1),
            ('Software Design', 111, 11),
            ('Product Testing', 112, 11),
        ('Human Resources', 2, 1),
            ('Recruitment', 21, 2),
            ('Employee Relations', 22, 2);



with recursive all_depts as (
-- topmost level
  select 
    ' -> ' || department_name as connection_tree,
    department_ID, 
    head_department_ID,
    department_name,
    0 as level    
  from departments
  where head_department_ID is null
  --
  union all
  --
  -- child levels
  select 
    a.connection_tree || ' -> ' || d.department_name as connection_tree,
    d.department_ID, 
    d.head_department_ID,
    d.department_name,
    a.level + 1 as level
  from departments d
  inner join all_depts a on d.head_department_ID = a.department_ID
)
select
  connection_tree,
  department_ID,
  head_department_ID,
  department_name
from all_depts
order by level, head_department_ID, department_ID
;