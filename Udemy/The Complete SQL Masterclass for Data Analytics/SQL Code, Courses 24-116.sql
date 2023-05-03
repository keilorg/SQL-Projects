-- Course 23 - 27: Restore and Back-up, debugging restoration issues, SQL for Data Analytics, Exercise
SELECT * FROM customer

SELECT * FROM product

SELECT * FROM sales





-- Course 28: IN

SELECT * 
FROM customer 
WHERE city IN ('Philadelphia', 'Seattle')





-- Course 29: BETWEEN

SELECT *
FROM customer
WHERE age BETWEEN 20 AND 30

SELECT *
FROM customer
WHERE age NOT BETWEEN 20 AND 30

SELECT *
FROM sales
WHERE ship_date BETWEEN '2016-11-11' AND '2016-11-21'






-- Course 30: LIKE

SELECT *
FROM customer
WHERE customer_name LIKE 'J%'

SELECT *
FROM customer
WHERE customer_name ILIKE 'j%'

SELECT *
FROM customer
WHERE customer_name ILIKE '%nelson%'

SELECT *
FROM customer
WHERE customer_name LIKE '____ %'

SELECT DISTINCT city
FROM customer
WHERE city NOT LIKE 'S%'

SELECT DISTINCT city
FROM customer
WHERE customer_name LIKE 'G\%'






-- Course 31: Exercise
-- 1. Get the list of all cities where the region is north or east without any duplicates using IN statement
SELECT DISTINCT city, region
FROM customer
WHERE region IN ('North', 'East')

-- 2. Get the list of all orders where the 'sales' value is between 100 and 500 using the BETWEEN operator
SELECT *
FROM sales
WHERE sales BETWEEN 100 AND 500

-- 3. Get the list of customers whose last name contains only 4 characters using LIKE
SELECT *
FROM customer
WHERE customer_name LIKE '% ____'





-- Course 32: Side lecture about how to make comments

-- Comment one line like this

/* make
multi-line comments
like this */ 





-- Course 33: ORDER BY

SELECT * 
FROM customer 
WHERE state = 'California'
ORDER BY customer_name

SELECT * 
FROM customer 
WHERE state = 'California'
ORDER BY customer_name DESC

SELECT * 
FROM customer 
ORDER BY city, customer_name DESC

SELECT *
FROM customer
ORDER BY 2

SELECT *
FROM customer
ORDER BY age DESC





-- Course 34: LIMIT

SELECT *
FROM customer
WHERE age > 35
ORDER BY age DESC
LIMIT 8

SELECT *
FROM customer
WHERE age > 25
ORDER BY age
LIMIT 10





-- Course 35: Exercise on sorting
-- 1. Retrieve all orders where "discount" value is greater than zero ordered in descending order basis "discount" value
SELECT *
FROM sales
WHERE discount > 0
ORDER BY discount DESC

-- 2. Limit the number of results in above query to top 10
SELECT *
FROM sales
WHERE discount > 0
ORDER BY discount DESC
LIMIT 10





-- Course 36: AS
SELECT 
	customer_id "serial_number",
	customer_name "name",
	age "customer_age"
FROM customer




-- Course 37: COUNT
SELECT COUNT(*)
FROM sales;

SELECT
	COUNT(order_line) "Number of products ordered",
	COUNT(DISTINCT order_id) "Number of orders"
FROM sales
WHERE customer_id = 'CG-12520'





-- Course 38: SUM
SELECT
	SUM(Profit) "Total Profit"
FROM sales

SELECT SUM(quantity) total_quantity
FROM sales
WHERE product_id = 'FUR-TA-10000577'





-- Course 39: AVG
SELECT AVG(age)
FROM customer

SELECT AVG(sales)*0.1 "Average Commision Value"
FROM sales





-- Course 40: MIN & MAX
SELECT MIN(sales) min_sales_value_june_15
FROM sales
WHERE order_date BETWEEN '2015-06-01' AND '2015-06-30'


SELECT sales
FROM sales
WHERE order_date BETWEEN '2015-06-01' AND '2015-06-30'
ORDER BY sales

SELECT MAX(sales) min_sales_value_june_15
FROM sales
WHERE order_date BETWEEN '2015-06-01' AND '2015-06-30'

SELECT sales
FROM sales
WHERE order_date BETWEEN '2015-06-01' AND '2015-06-30'
ORDER BY sales DESC





-- COURSE 41: Exercise 8: Aggregate Functions
-- 1. Find the sum of all 'sales' values
SELECT sum(sales)
FROM sales

-- 2. Find count of the number of customers with age between 20 & 30
SELECT COUNT(DISTINCT(customer_id))
FROM customer
WHERE (age BETWEEN 20 AND 30)

-- 3. Find the average age of East region customers
SELECT AVG(age)
FROM customer
WHERE region = 'East'

-- 4. Find the Minimum & Maximum aged customers from Philadelphia
SELECT
	MIN(age) min_age,
	MAX(age) max_age
FROM customer
WHERE city = 'Philadelphia'





-- Course 42: GROUP BY
SELECT 
	region,
	COUNT(customer_id) customer_count,
FROM customer
GROUP BY 1

SELECT 
	product_id,
	SUM(sales) total_sales
FROM sales
GROUP BY 1
ORDER BY 2 DESC

SELECT
	customer_id,
	MIN(sales) min_sales,
	MAX(sales) max_sales,
	AVG(sales) avg_sales,
	SUM(sales) total_sales
FROM sales
GROUP BY 1
ORDER BY 5 DESC
LIMIT 5



-- Course 43: HAVING
SELECT 
	region,
	COUNT(customer_id) total_customers
FROM customer
GROUP BY 1
HAVING COUNT(customer_id) > 200

SELECT
	region,
	COUNT(customer_id) total_customers
FROM customer
WHERE customer_name LIKE 'A%'
GROUP BY 1
HAVING COUNT(customer_id) > 15





-- Course 44: Exercise: GROUP BY
SELECT 
	product_id,
	SUM(sales) total_sales,
	SUM(quantity) total_quantity,
	COUNT(DISTINCT(order_id)) total_orders,
	MAX(sales) max_sales,
	MIN(sales) min_sales,
	AVG(sales) avg_sales
FROM sales
GROUP BY 1
ORDER BY 2 DESC


SELECT
	product_id,
	SUM(quantity) total_quantity
FROM sales
GROUP BY 1
HAVING SUM(quantity) > 10




-- Course 45: CASE WHEN
SELECT
	*,
	CASE
		WHEN age < 30 THEN 'Young'
		WHEN age < 60 THEN 'Middle Aged'
		ELSE 'Senior Citizen'
		END age_category
FROM customer




-- Course 46 & 47: Intro to Joins





-- Course 48: Preparing the Data
CREATE TABLE sales_2015 AS (
	SELECT *
	FROM sales
	WHERE ship_date BETWEEN '2015-01-01' AND '2015-12-31')

SELECT COUNT(*) FROM sales_2015
SELECT COUNT(DISTINCT customer_id) FROM sales_2015


CREATE TABLE customer_20_60 AS (
	SELECT *
	FROM customer
	WHERE age BETWEEN 20 AND 60)

SELECT COUNT(*) FROM customer_20_60




-- Course 49: Inner Join
SELECT
	a.order_line,
	a.product_id,
	a.customer_id,
	a.sales,
	b.customer_name,
	b.age
FROM sales_2015 a 
	INNER JOIN customer_20_60 b ON a.customer_id = b.customer_id
ORDER BY customer_id




-- Course 50: LEFT Join
SELECT
	a.order_line,
	a.product_id,
	a.customer_id,
	a.sales,
	b.customer_name,
	b.age
FROM sales_2015 a 
	LEFT JOIN customer_20_60 b ON a.customer_id = b.customer_id
ORDER BY customer_id





-- Course 51: RIGHT Join
SELECT
	a.order_line,
	a.product_id,
	a.customer_id,
	a.sales,
	b.customer_name,
	b.age
FROM sales_2015 a 
	RIGHT JOIN customer_20_60 b ON a.customer_id = b.customer_id
ORDER BY customer_id





-- Course 52: FULL OUTER JOIN
SELECT
	a.order_line,
	a.product_id,
	a.customer_id,
	a.sales,
	b.customer_name,
	b.age,
	b.customer_id
FROM sales_2015 a 
	FULL OUTER JOIN customer_20_60 b ON a.customer_id = b.customer_id
ORDER BY customer_id





-- Course 53: CROSS JOIN
CREATE TABLE month_values (MM integer)
CREATE TABLE year_values (YYYY integer)

INSERT INTO month_values VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12)
INSERT INTO year_values VALUES (2011), (2012), (2013), (2014), (2015), (2016), (2017), (2018), (2019)

SELECT a.YYYY, b.MM
FROM year_values a CROSS JOIN month_values b
ORDER BY a.YYYY, b.MM




-- Course 54: INTERSECT and INTERSECT ALL
SELECT customer_id FROM sales_2015
INTERSECT
SELECT customer_id FROM customer_20_60

SELECT customer_id FROM sales_2015
INTERSECT ALL
SELECT customer_id FROM customer_20_60





-- Course 55: EXCEPT
SELECT customer_id FROM sales_2015
EXCEPT
SELECT customer_id FROM customer_20_60





-- Course 56: UNION and UNION ALL
SELECT customer_id FROM sales_2015
UNION
SELECT customer_id FROM customer_20_60
ORDER BY customer_id

SELECT customer_id FROM sales_2015
UNION ALL
SELECT customer_id FROM customer_20_60
ORDER BY customer_id




-- Course 57: Exercise 10: Joins
-- 1. Find the total sales done in every state for customer_20_60 and sales_2015 table
SELECT * FROM customer_20_60
SELECT * FROM sales_2015
SELECT * FROM product

SELECT
	state,
	SUM(sales) total_sales
FROM sales_2015 a 
	LEFT JOIN customer_20_60 b ON a.customer_id = b.customer_id
GROUP BY 1
ORDER BY 2 DESC

/* 2. Get data containing Product_id, product name, category, total sales value of that product 
and total quantity sold. (Use sales and product table) */

SELECT
	a.product_id,
	a.product_name,
	a.category,
	SUM(b.sales) total_sales,
	SUM(b.quantity) total_quantity
FROM product a
	LEFT JOIN sales b ON a.product_id = b.product_id
GROUP BY 1, 2, 3
ORDER BY 4 DESC
	
	
select a.*, sum(b.sales) as total_sales, sum(quantity) as total_quantity
from product as a left join sales as b
on a.product_id = b.product_id
group by a.product_id
ORDER BY total_sales DESC





-- Course 58: Subqueries
SELECT *
FROM sales
WHERE customer_id IN (SELECT customer_id FROM customer WHERE age > 60)

SELECT
	a.product_id,
	a.product_name,
	a.category,
	b.quantity
FROM product a
	LEFT JOIN (SELECT product_id, SUM(quantity) quantity FROM sales GROUP BY product_id) b
	ON a.product_id = b.product_id
ORDER BY b.quantity DESC

SELECT 
	customer_id,
	order_line,
	(SELECT customer_name FROM customer WHERE customer.customer_id = sales.customer_id)
FROM sales
ORDER BY customer_id





-- Course 59: Exercise 11: Subqueries
/* Get data with all columns of sales table, and customer name, customer age, product name
and category are in the same result set. (use JOIN in subquery) */
SELECT 
	a.*, 
	b.customer_name, 
	b.age, 
	c.product_name,
	c.category
FROM sales a
	LEFT JOIN customer b ON a.customer_id = b.customer_id
	LEFT JOIN product c ON a.product_id = c.product_id

select c.customer_name, c.age, sp.* from
customer as c
right join (select s.*, p.product_name, p.category
from sales as s
left join product as p
on s.product_id = p.product_id) as sp
on c.customer_id = sp.customer_id





-- Course 60: VIEWS
CREATE OR REPLACE VIEW logistics AS (
	SELECT 
		a.order_line, 
		a.order_id, 
		b.customer_name, 
		b.city, 
		b.state, 
		b.country
	FROM sales a
		LEFT JOIN customer b ON a.customer_id = b.customer_id
	ORDER BY a.order_line)

SELECT * FROM logistics

DROP VIEW logistics





-- Course 61: INDEX
SELECT *
FROM month_values

CREATE INDEX mon_id
ON month_values(MM)

DROP INDEX IF EXISTS mon_id





-- Course 62: Exercise 12: Views
CREATE OR REPLACE VIEW Daily_Billing AS (
	SELECT
		order_line,
		product_id,
		sales,
		discount
	FROM sales
	WHERE order_date = (SELECT MAX(order_date) FROM sales)
)

DROP VIEW Daily_Billing





-- Course 63: LENGTH
SELECT customer_name, LENGTH(customer_name) name_length
FROM customer
WHERE age > 30





-- Course 64: UPPER LOWER
SELECT UPPER('Start-Tech Academy')





-- Course 65: REPLACE
SELECT 
	customer_name,
	country,
	REPLACE(country, 'United States', 'US')
FROM customer





-- Course 66: TRIM, LTRIM, RTRIM
SELECT 
	customer_name,
	TRIM(LEADING 'A' FROM customer_name)
FROM customer

SELECT 
	customer_name,
	TRIM(TRAILING 'e' FROM customer_name)
FROM customer

SELECT 
	customer_name,
	RTRIM(customer_name, 'e')
FROM customer

SELECT 
	customer_name,
	LTRIM(customer_name, 'A')
FROM customer




-- Course 67: CONCATENATION
SELECT
	customer_name,
	city || ', ' || state || ', ' || country address
FROM customer	





-- Course 68: SUBSTRING

SELECT
	customer_id,
	customer_name,
	SUBSTRING(customer_id, 1, 2) cust_group,
	SUBSTRING(customer_id FOR 2) cust_group_2,
	SUBSTRING(customer_id FROM 4 FOR 5) cust_group_3
FROM customer






-- COURSE 69: LIST AGGREGATION
-- STRING_AGG()

SELECT 
	order_id, 
	STRING_AGG(product_id, ', ')
FROM sales
GROUP BY order_id






-- Course 70: Exercise 13: String Functions
-- 1. Find Maximum length of characters in the Product name string from Product table
SELECT MAX(LENGTH(product_name))
FROM product

/* 2. Retrieve product name, sub-category and category from Product table and an additional column named
"product_details" which contains a concatenated string of product name, sub-category and category */
SELECT
	product_name,
	sub_category,
	category,
	(product_name || sub_category || category) product_details
FROM product

-- 3. Analyze the product_id column and take out the three parts composing the product_id in three different columns
SELECT
	product_id,
	SUBSTRING(product_id, 1, 3) part_1,
	SUBSTRING(product_id, 5, 2) part_2,
	SUBSTRING(product_id, 8, 8) part_3
FROM product

-- 4. List down comma separated product name where sub-category is either Chairs or Tables
SELECT
	sub_category,
	STRING_AGG(product_name, ', ') product_names
FROM product
WHERE sub_category IN ('Chairs', 'Tables')
GROUP BY 1





-- Course 71: CEIL & FLOOR
SELECT 
	sales,
	CEIL(sales),
	FLOOR(sales)
FROM sales






-- Course 72: RANDOM
SELECT RANDOM()

SELECT RANDOM()*(20-10)+10





-- Course 73: SETSEED
SELECT SETSEED(0.5)

SELECT RANDOM()
--.98516
--.82530




-- Course 74: ROUND
SELECT sales, ROUND(sales) FROM sales




-- Course 75: POWER
SELECT age, POWER(age, 2)
FROM customer



-- Course 76: Exercise 14: Mathematical Functions
-- 1. You are running a lottery for your customer. So, pick a list of 5 lucky customers from customer table using random function.
SELECT
	*,
	RANDOM() identifier
FROM customer
ORDER BY identifier DESC
LIMIT 5

/* 2. Suppose you cannot charge the customer in fraction points. So, for sales value of 1.63, you will get either
1 or 2. In such a scenario, find out: */
-- a) Total sales revenue if you are charging the lower integer value of sales always
-- b) Total sales revenue if you are charging the higher integer value of sales always
-- c) Total sales revenue if you are rounding-off the sales always
SELECT
	SUM(sales),
	SUM(FLOOR(sales)) sales_floor,
	SUM(CEIL(sales)) sales_ceil,
	SUM(ROUND(sales)) sales_round
FROM sales





-- Course 77: CURRENT DATE & TIME

SELECT CURRENT_DATE, CURRENT_TIME, CURRENT_TIME(1), CURRENT_TIMESTAMP





-- Course 78: AGE
SELECT 
	order_date,
	AGE(order_date, CURRENT_DATE)
FROM sales





-- Course 79: EXTRACT
SELECT EXTRACT(DAY FROM CURRENT_DATE)

SELECT CURRENT_TIMESTAMP, EXTRACT(HOUR FROM CURRENT_TIMESTAMP)

SELECT 
	order_date,
	ship_date,
	EXTRACT(EPOCH FROM ship_date) - EXTRACT(EPOCH FROM order_date)
FROM sales




-- Course 80: Exercise 15: Date-time Functions
-- 1. Find out the current age of "Batman" who was born on "April 6, 1939" in years, months & days
SELECT
	AGE(CURRENT_DATE, '1939-04-06') batman_age

-- 2. Analyze and find out the monthly sales of sub-category Chair. Do you observe any seasonality in sales of this sub-category?
SELECT 
	DATE(EXTRACT(YEAR FROM ship_date) || '-' || EXTRACT(MONTH FROM ship_date) || '-01') ship_month,
	SUM(sales)
FROM sales a
	LEFT JOIN product b ON a.product_id = b.product_id
WHERE sub_category = 'Chairs'
GROUP BY 1
ORDER BY 1





-- Course 81: PATTERN MATCHING BASICS
SELECT 
	customer_name
FROM customer
WHERE NOT (SUBSTRING(customer_name, 1, 1) IN ('A', 'B', 'C', 'D'))





-- Course 82: ADVANCE PATTERN MATCHING (REGULAR EXPRESSIONS)
SELECT *
FROM customer
WHERE customer_name ~*'^a+[a-z\s]+$'

SELECT *
FROM customer
WHERE customer_name ~*'^(a|b|c|d)+[a-z\s]+$'

SELECT *
FROM customer
WHERE customer_name ~*'^(a|b|c|d)[a-z]{3}\s[a-z]{4}$'

create table users(id serial primary key, name character varying)
insert into users (name) VALUES ('Alex'), ('Jon Snow'), ('Christopher'), 
('Arya'),('Sandip Debnath'), ('Lakshmi'),('alex@gmail.com'),('@sandip5004'), ('lakshmi@gmail.com');


SELECT *
FROM users

SELECT *
FROM users
WHERE name ~* '[a-z0-9\.\-\_]+@[a-z0-9\-]+\.[a-z]{2,5}'





-- Course 83: Exercise 16: Pattern Matching
-- 1. Find out all customers who have first name and last name of 5 characters each and last name starts with "a/b/c/d"

SELECT *
FROM customer
WHERE customer_name ~* '^[a-z]{5}\s(a|b|c|d)[a-z]{4}$'

-- 2. Create a table "zipcode" and insert the below data in it. Find out the valid zipcodes from this table (5 or 6 numeric characters)

CREATE TABLE zipcode (pin_or_zipcode VARCHAR)
INSERT INTO zipcode VALUES ('234432'), ('23345'), ('sdfe4'), ('123&3'), ('67424'), ('7895432'), ('12312')
SELECT * FROM zipcode

SELECT pin_or_zipcode
FROM zipcode
WHERE pin_or_zipcode ~* '^[0-9]{5,6}$'




-- Course 84-86: Introduction to Window Functions, ROW_NUMBER()

WITH temp AS (
	SELECT
		b.state,
		a.customer_id,
		COUNT(DISTINCT(order_id)) orders
	FROM sales a
		LEFT JOIN customer b ON a.customer_id = b.customer_id
	GROUP BY 1, 2
	ORDER BY 1, 3 DESC
), temp2 AS (
	SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY state ORDER BY orders DESC) rnk
	FROM temp
)

SELECT *
FROM temp2
WHERE rnk < 4





-- Course 87: RANK & DENSE_RANK()

WITH temp AS (
	SELECT
		b.state,
		a.customer_id,
		COUNT(DISTINCT(order_id)) orders
	FROM sales a
		LEFT JOIN customer b ON a.customer_id = b.customer_id
	GROUP BY 1, 2
	ORDER BY 1, 3 DESC
), temp2 AS (
	SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY state ORDER BY orders DESC) rn,
		RANK() OVER (PARTITION BY state ORDER BY orders DESC) rnk,
		DENSE_RANK() OVER (PARTITION BY state ORDER BY orders DESC) drnk
	FROM temp
)

SELECT *
FROM temp2





-- Course 88: NTILE
WITH temp AS (
	SELECT
		b.state,
		a.customer_id,
		COUNT(DISTINCT(order_id)) orders
	FROM sales a
		LEFT JOIN customer b ON a.customer_id = b.customer_id
	GROUP BY 1, 2
	ORDER BY 1, 3 DESC
), temp2 AS (
	SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY state ORDER BY orders DESC) rn,
		RANK() OVER (PARTITION BY state ORDER BY orders DESC) rnk,
		DENSE_RANK() OVER (PARTITION BY state ORDER BY orders DESC) drnk,
		NTILE(5) OVER (PARTITION BY state ORDER BY orders DESC) ntl
	FROM temp
)

SELECT *
FROM temp2




-- Course 89: AVG function
WITH temp AS (
	SELECT
		customer_id,
		SUM(sales) sales_tot
	FROM sales
	GROUP BY 1
)
SELECT 
	state,
	customer_name,
	sales_tot,
	AVG(sales_tot) OVER (PARTITION BY state) state_average_sales
FROM temp a
	LEFT JOIN customer b ON a.customer_id = b.customer_id
ORDER BY state





-- Course 90: COUNT
SELECT
	customer_id,
	customer_name,
	state,
	COUNT(customer_id) OVER (PARTITION BY state) as customer_count
FROM customer





-- Course 91: SUM TOTAL
SELECT
	a.customer_id,
	customer_name,
	state,
	sales,
	SUM(sales) OVER (PARTITION BY state) as state_sales
FROM customer a
	LEFT JOIN sales b ON a.customer_id = b.customer_id





-- Course 92: RUNNING TOTAL
SELECT
	a.customer_id,
	customer_name,
	state,
	sales,
	SUM(sales) OVER (PARTITION BY state ORDER BY sales) as state_sales_cum_sum
FROM customer a
	LEFT JOIN sales b ON a.customer_id = b.customer_id





-- Course 93: LAG & LEAD
WITH temp AS (
	SELECT 
		state,
		a.customer_id,
		SUM(sales) customer_sales
	FROM sales a
		LEFT JOIN customer b ON a.customer_id = b.customer_id
	GROUP BY 1, 2
)

SELECT
	*,
	LAG(customer_sales, 1) OVER (PARTITION BY state ORDER BY customer_sales) sales_lag,
	LEAD(customer_sales, 1) OVER (PARTITION BY state ORDER BY customer_sales) sales_lead
FROM temp


SELECT 
	customer_id,
	order_date,
	sales,
	LEAD(sales, 1) OVER (PARTITION BY customer_id ORDER BY order_date DESC)
FROM sales
ORDER BY customer_id, order_date DESC





-- Course 94: COALESCE
SELECT COALESCE(null, sales), sales
FROM sales




-- Course 95: Converting Numbers/Date to String
SELECT 
	sales,
	'Total sales value for this order is' || TO_CHAR(sales, '9999.99') message
FROM sales

SELECT order_date, TO_CHAR(order_date,'MM-DD-YY')
FROM sales






-- Course 96: Converting String to Number/Date
SELECT TO_DATE('2019/01/15', 'YYYY/MM/DD')
SELECT TO_DATE('26122018', 'DDMMYYYY')

SELECT TO_NUMBER('2045.0876', '9999.999')
SELECT TO_NUMBER('$2,045.876', 'L9,9999.99')





-- Course 97: User Access Control
CREATE USER starttech
WITH PASSWORD 'academy'

GRANT SELECT, UPDATE, INSERT, DELETE ON product TO starttech

REVOKE DELETE ON product FROM starttech

REVOKE ALL ON product FROM starttech

DROP USER starttech





-- Course 99: TABLESPACE
CREATE TABLESPACE NewSpace LOCATION ''

SELECT * FROM pg_tablespace





-- Course 100: PRIMARY KEY & FOREIGN KEY
-- PRIMARY KEY: Uniquely identifies each row in a table. Can be one column or a combination of multiple columns. Cannot be null
-- FOREIGN KEY: Primary Key in a different table. Can be used to uniquely map a row in one table to a row in another table




-- Course 101: ACID Compliance. A reliable database must achieve all four of the following:
-- ATOMICITY: This is an all-or-none proposition
-- CONSISTENCY: Ensures that a transaction can only bring the database from one valid state to another
-- ISOLATION: Keeps transactions separated from each other until they're finished
-- DURABILITY: Guarantees that the database will keep track of pending changes in such a way that the server can recover from an abnormal termination





-- Course 102: TRUNCATE





-- Course 103: EXPLAIN statement
EXPLAIN SELECT * FROM customer

EXPLAIN SELECT DISTINCT * FROM customer



-- Course 104: SOFT DELETE vs HARD DELETE
-- Course 105: UPDATE and CASE STATEMENT
-- Course 106: VACUUM
-- Course 107: TRUNCATE
-- Course 108: STRING FUNCTIONS
-- Course 109: JOINS
-- Course 110: SCHEMAS

-- Course 111: What is SQL?
-- Course 112: Tables and DBMS
-- Course 113: Types of SQL commands
-- Course 114: PostgreSQL
-- Course 115: The final milestone
-- Course 116: Bonus Lecture





