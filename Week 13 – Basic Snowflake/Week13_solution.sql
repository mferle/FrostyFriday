-- create table
create or replace table testing_data(id int autoincrement start 1 increment 1, product string, stock_amount int,date_of_check date);
-- insert sample data
insert into testing_data (product,stock_amount,date_of_check) values ('Superhero capes',1,'2022-01-01');
insert into testing_data (product,stock_amount,date_of_check) values ('Superhero capes',2,'2022-01-02');
insert into testing_data (product,stock_amount,date_of_check) values ('Superhero capes',NULL,'2022-02-01');
insert into testing_data (product,stock_amount,date_of_check) values ('Superhero capes',NULL,'2022-03-01');
insert into testing_data (product,stock_amount,date_of_check) values ('Superhero masks',5,'2022-01-01');
insert into testing_data (product,stock_amount,date_of_check) values ('Superhero masks',NULL,'2022-02-13');
insert into testing_data (product,stock_amount,date_of_check) values ('Superhero pants',6,'2022-01-01');
insert into testing_data (product,stock_amount,date_of_check) values ('Superhero pants',NULL,'2022-01-01');
insert into testing_data (product,stock_amount,date_of_check) values ('Superhero pants',3,'2022-04-01');
insert into testing_data (product,stock_amount,date_of_check) values ('Superhero pants',2,'2022-07-01');
insert into testing_data (product,stock_amount,date_of_check) values ('Superhero pants',NULL,'2022-01-01');
insert into testing_data (product,stock_amount,date_of_check) values ('Superhero pants',3,'2022-05-01');
insert into testing_data (product,stock_amount,date_of_check) values ('Superhero pants',NULL,'2022-10-01');
insert into testing_data (product,stock_amount,date_of_check) values ('Superhero masks',10,'2022-11-01');
insert into testing_data (product,stock_amount,date_of_check) values ('Superhero masks',NULL,'2022-02-14');
insert into testing_data (product,stock_amount,date_of_check) values ('Superhero masks',NULL,'2022-02-15');
insert into testing_data (product,stock_amount,date_of_check) values ('Superhero masks',NULL,'2022-02-13');

-- check data in table
select * from testing_data;

-- fill missing values using last_value() function
-- window_frame rows between unbounded preceding and current row is required in Snowflake
-- https://docs.snowflake.com/en/sql-reference/functions/last_value.html

select id, product, stock_amount, 
last_value(stock_amount ignore nulls) over (partition by product order by date_of_check rows between unbounded preceding and current row) as stock_amount_filled_out,
date_of_check
from testing_data
order by product, date_of_check
;
