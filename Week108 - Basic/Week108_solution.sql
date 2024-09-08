-- setup code
-- create a table and populate it with some data
CREATE TABLE week_108 AS
SELECT * FROM VALUES
    (1, 'Alice', 'Laptop', 1, 1200.50),
    (2, 'Bob', 'Smartphone', 2, 800.00),
    (3, 'Charlie', 'Tablet', 1, 300.00),
    (4, 'David', 'Smartwatch', 3, 150.00),
    (5, 'Eva', 'Headphones', 2, 100.00),
    (6, 'Frank', 'Laptop', 1, 1300.00),
    (7, 'Grace', 'Smartphone', 1, 900.00),
    (8, 'Hank', 'Tablet', 4, 320.00),
    (9, 'Ivy', 'Smartwatch', 2, 180.00),
    (10, 'Jack', 'Headphones', 3, 110.00),
    (11, 'Karen', 'Laptop', 1, 1250.75),
    (12, 'Leo', 'Smartphone', 2, 850.00),
    (13, 'Mona', 'Tablet', 1, 350.00),
    (14, 'Nina', 'Smartwatch', 3, 160.00),
    (15, 'Oscar', 'Headphones', 2, 105.00),
    (16, 'Paul', 'Laptop', 1, 1350.00),
    (17, 'Quincy', 'Smartphone', 1, 950.00),
    (18, 'Rita', 'Tablet', 4, 330.00),
    (19, 'Sam', 'Smartwatch', 2, 200.00),
    (20, 'Tina', 'Headphones', 3, 115.00)
    AS sales(sale_id, customer_name, product_name, quantity, sale_amount);

-- write a simple query that summarizes the quantity and sale_amount for a given product
select product_name, sum(quantity) as tot_quantity, sum(sale_amount) as tot_sale_amount from week_108 where product_name = 'Laptop' group by all;

-- set a session variable to store the value of the filter
set which_product = 'Laptop';

-- write a dynamic query that uses the session variable as a parameter in the query
SELECT *
FROM TABLE(
    TO_QUERY(
        SQL => 'select product_name, 
                  sum(quantity) as tot_quantity, 
                  sum(sale_amount) as tot_sale_amount 
                  from week_108 
                  where product_name = :which_product 
                  group by all',
        which_product => $which_product
    )
);

