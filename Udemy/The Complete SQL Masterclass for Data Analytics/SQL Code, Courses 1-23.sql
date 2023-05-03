-- Courses 8-12, CREATE & INSERT

CREATE TABLE Customer_table (
	cust_id int,
	first_name varchar,
	last_name varchar,
	age int,
	email_id varchar
);

INSERT INTO customer_table VALUES
(1, 'bee', 'cee', 32, 'bc@xyz.com')

INSERT INTO customer_table (cust_id, first_name, age, email) VALUES
(2, 'dee', 23, 'd@xyz.com')

INSERT INTO customer_table (cust_id, first_name, age, email_id) VALUES
(2, 'dee', 23, 'd@xyz.com')

INSERT INTO customer_table VALUES
(3, 'ee', 'ef', 27, 'ef@xyz.com'),
(4, 'gee', 'eh', 35, 'gh@xyz.com')

Select * From customer_table;





-- Course 13, Inserting & Importing

SELECT * FROM Science_class;

CREATE TABLE Science_class (
	student_id int,
	student_name varchar,
	score int
);

SELECT * FROM Science_class

INSERT INTO science_class VALUES
(1, 'Popeye', 33),
(2, 'Olive', 54),
(3, 'Brutus', 98)

SELECT * FROM science_class

COPY science_class FROM '/Applications/PostgreSQL 15/data/Student.csv' delimiter ',' csv header;

SELECT * FROM science_class





-- Course 14 & 15, SELECT & SELECT DISTINCT

SELECT first_name from customer_table

SELECT DISTINCT(first_name) from customer_table





-- Course 16, WHERE

SELECT * FROM customer_table

INSERT INTO customer_table VALUES 
(5, 'Gee', 'Etch', 25, 'ge@xyz.com'),
(6, 'Jay', 'Kay', 35, 'jk@xyz.com'),
(7, 'Gee', 'Etch', 25, 'ge@xyz.com'),
(8, 'Jay', 'Kay', 35, 'jk@xyz.com')


SELECT first_name FROM customer_table WHERE age = 25

SELECT distinct first_name FROM customer_table WHERE age = 25

SELECT * FROM customer_table WHERE first_name = 'Gee'





-- Course 17, Logical Operators

SELECT first_name, last_name, age 
FROM customer_table 
WHERE age < 30 AND age > 20

SELECT first_name, last_name, age 
FROM customer_table 
WHERE age >= 30 OR age < 20

SELECT * 
FROM customer_table 
WHERE NOT age = 25

SELECT * 
FROM customer_table 
WHERE (NOT age = 25) AND (NOT first_name='Jay')





-- Course 18, Exercise 3: SELECT & WHERE
-- 1. Retrieve all data from the table 'Science_Class'
SELECT * FROM science_class

-- 2. Retrieve the name of students who are over 60 yrs old
SELECT student_name
FROM science_class
WHERE age > 60

-- 3. Retrieve all data of students who are over 35 but less than 60
SELECT *
FROM science_class
WHERE (age > 35) AND (age < 60)

SELECT *
FROM science_class
WHERE age BETWEEN 36 AND 59 -- note that BETWEEN is inclusive

-- 4. Retrieve all other students i.e. who are younger than or equal to 35 or older than or equal to 60
SELECT *
FROM science_class
WHERE (age <= 35) OR (age >= 60)






-- Course 19, UPDATE
SELECT * FROM customer_table WHERE cust_id = 2

UPDATE customer_table 
SET last_name='Pe', age=17 
WHERE cust_id = 2


SELECT * FROM customer_table

UPDATE customer_table
SET email_id = 'gee@xyz.com'
WHERE (first_name = 'Gee') or (first_name = 'gee')






-- Course 20, DELETE
DELETE FROM customer_table
WHERE cust_id = 6

SELECT * FROM customer_table ORDER BY cust_id

DELETE FROM customer_table
WHERE age > 30

DELETE FROM customer_table





-- Course 21, ALTER
SELECT * FROM customer_table

ALTER TABLE customer_table
ADD test varchar(255)

ALTER TABLE customer_table
DROP test

ALTER TABLE customer_table
ALTER COLUMN age type varchar

ALTER TABLE customer_table
RENAME COLUMN email_id TO customer_email

ALTER TABLE customer_table
ALTER COLUMN cust_id SET NOT NULL

INSERT INTO customer_table (first_name, last_name, age, customer_email) VALUES ('aa', 'bb', '25', 'ab@xyz.com')

ALTER TABLE customer_table
ALTER COLUMN cust_id DROP NOT NULL

ALTER TABLE customer_table
ADD CONSTRAINT cust_id CHECK (cust_id > 0)

INSERT INTO customer_table VALUES (-1, 'aa', 'bb', '25', 'ab@xyz.com')

ALTER TABLE customer_table
ADD PRIMARY KEY (cust_id)

DELETE FROM customer_table

INSERT INTO customer_table VALUES (1, 'aa', 'bb', '25', 'ab@xyz.com')






-- Course 22: Exercise 4: Upating Table
-- 1. Update the marks of Popeye to 45
SELECT * FROM science_class

ALTER TABLE science_class
RENAME COLUMN age TO marks

UPDATE science_class
SET marks = 45
WHERE student_name = 'Popeye'

-- 2. Delete the row containing details of student named 'Robb'
DELETE FROM science_class
WHERE student_name = 'Robb'

-- 3. Rename column 'student_name' to 'student_name_2', and change back again
ALTER TABLE science_class
RENAME COLUMN student_name TO student_name_2

SELECT * FROM science_class

ALTER TABLE science_class
RENAME COLUMN student_name_2 TO student_name






-- Course 23: Restore and Back-up
SELECT * FROM customer
































