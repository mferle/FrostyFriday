-- startup code
create or replace temporary table trade (
    type VARCHAR,
    id INT,
    ticker VARCHAR,
    datetime TIMESTAMP_TZ,
    price FLOAT,
    volume INT
);

create or replace temporary table quotes(
    type VARCHAR,
    id INT,
    ticker VARCHAR,
    datetime TIMESTAMP_TZ,
    ask FLOAT,
    bid FLOAT
);
insert into trade values
    ('trade', 2, 'AAPL', '2020-01-06 09:00:30.000+09:00', 305, 1),  
    ('trade', 2, 'AAPL', '2020-01-06 09:01:00.000+09:00', 310, 2),  
    ('trade', 2, 'AAPL', '2020-01-06 09:01:30.000+09:00', 308, 1),  
    ('trade', 3, 'GOOGL', '2020-01-06 09:02:00.000+09:00', 1500, 2),  
    ('trade', 3, 'GOOGL', '2020-01-06 09:03:00.000+09:00', 1520, 3),  
    ('trade', 3, 'GOOGL', '2020-01-06 09:03:30.000+09:00', 1515, 1); 

insert into quotes values
    ('quote', 2, 'AAPL', '2020-01-06 08:59:59.999+09:00', 305, 304),  
    ('quote', 2, 'AAPL', '2020-01-06 09:02:00.000+09:00', 311, 309),  
    ('quote', 3, 'GOOGL', '2020-01-06 09:01:00.000+09:00', 1490, 1485),  
    ('quote', 3, 'GOOGL', '2020-01-06 09:04:00.000+09:00', 1530, 1528);  

insert into quotes values
    ('quote', 2, 'AAPL', '2020-01-06 09:00:30.000+09:00', 307, 305),  
    ('quote', 2, 'AAPL', '2020-01-06 09:01:30.000+09:00', 308, 306),  
    ('quote', 3, 'GOOGL', '2020-01-06 09:02:00.000+09:00', 1502, 1498),  
    ('quote', 3, 'GOOGL', '2020-01-06 09:03:30.000+09:00', 1518, 1513);  

-- Given two tables, trade and quotes, containing transactional data in a financial market, 
-- where the trade table records trades and the quotes table records quotes for a specific financial instrument, 
-- construct an ASOF join SQL statement to pair each trade record with the most recent quote record available at or before the time of the trade.
select T.type, T.id, T.ticker, T.datetime, T.price, T.volume,
  Q.type, Q.datetime, Q.ask, Q.bid
from trade T
asof join quotes Q
match_condition (T.datetime >= Q.datetime)
on T.id = Q.id
order by T.id, T.datetime;
