
/* Questions 1-10 are only attemptable if you have system tables (sys schema). Because I
	am using a recreated version of the AdventureWorks database in postgres that doesn't have
	the sys schema, we will skip these first 10 questions for now. */
	
	
-- QUESTION 11


-- a. How many employees exist in the Database?
SELECT 
	COUNT(businessentityid)
FROM humanresources.employeedepartmenthistory
-- Answer: 296

-- b. How many of these employees are active employees?
SELECT COUNT(*)
FROM humanresources.employeedepartmenthistory
WHERE enddate IS NULL
-- Answer: 290

-- c. How many Job Titles equal the 'SP' Person type?
SELECT COUNT(DISTINCT(jobtitle))
FROM humanresources.employee a
	LEFT JOIN person.person b ON a.businessentityid = b.businessentityid
WHERE b.persontype = 'SP'
-- Answer: 4

-- d. How many of these employees are active sales people?
SELECT 
	jobtitle,
	COUNT(*)
FROM humanresources.employeedepartmenthistory a
	LEFT JOIN humanresources.department b ON a.departmentid = b.departmentid
	LEFT JOIN humanresources.employee c ON a.businessentityid = c.businessentityid
WHERE a.enddate IS NULL
	AND b.name = 'Sales'
GROUP BY 1
-- Answer: 18





-- QUESTION 12

-- a. What is the name of the CEO? Concatenate first & last name
SELECT 
	CONCAT(firstname, ' ', lastname) full_name
FROM humanresources.employee a
	JOIN person.person b ON a.businessentityid = b.businessentityid
WHERE a.jobtitle = 'Chief Executive Officer'
-- Answer: Ken Sánchez

-- b. When did this person start working for AdventureWorks?
SELECT 
	CONCAT(firstname, ' ', lastname) full_name,
	startdate
FROM humanresources.employee a
	LEFT JOIN humanresources.employeedepartmenthistory b ON a.businessentityid = b.businessentityid
	LEFT JOIN person.person c ON a.businessentityid = c.businessentityid
WHERE a.jobtitle = 'Chief Executive Officer'
	AND b.enddate IS NULL
-- Answer: 2009-01-14

-- c. Who reports to the CEO? Include their names and titles
SELECT 
	firstname,
	lastname,
	jobtitle,
	organizationnode
FROM humanresources.employee a
	LEFT JOIN person.person b ON a.businessentityid = b.businessentityid
WHERE LENGTH(organizationnode) = 3
ORDER BY 4
-- Answer: VP of Engineering, Marketing Manager, VP of Production, CFO, Information Services Mgr, VP of Sales





-- QUESTION 13

-- a. What is the job title for John Evans
SELECT 
	firstname,
	lastname,
	jobtitle
FROM humanresources.employee a
	LEFT JOIN person.person b ON a.businessentityid = b.businessentityid
WHERE firstname = 'John'
	AND lastname = 'Evans'
-- Answer: Production Technician - WC50

-- b. What department does John Evans work in?
SELECT 
	firstname,
	lastname,
	jobtitle,
	d.name department_name
FROM humanresources.employee a
	LEFT JOIN person.person b ON a.businessentityid = b.businessentityid
	LEFT JOIN humanresources.employeedepartmenthistory c ON a.businessentityid = c.businessentityid
	LEFT JOIN humanresources.department d ON c.departmentid = d.departmentid
WHERE firstname = 'John'
	AND lastname = 'Evans'
	AND enddate IS NULL
-- Answer: Production





-- QUESTION 14

-- a. Which Purchasing vendors have the highest credit rating?
SELECT *
FROM purchasing.vendor
WHERE creditrating = 1 -- note credit ratings go from 1-5, with 1 being the highest
-- Answer: 84 vendors have the highest credit rating

-- b. Using a case statement replace the 1 and 0 in Vendor.PreferredVendorStatus to "Preferred" vs "Not Preferred". How many vendors are considered Preferred?
WITH temp AS (
SELECT
	*,
	CASE WHEN preferredvendorstatus = True THEN 'Preferred'
		WHEN preferredvendorstatus = False THEN 'Not Preferred'
		ELSE NULL END AS preferredvendorstatus_2
FROM purchasing.vendor
)
SELECT
	preferredvendorstatus_2,
	COUNT(*)
FROM temp
GROUP BY 1
-- Answer: 93

-- c. For Active Vendors only, do Preferred vendors have a higher or lower average credit rating?
SELECT
	CASE WHEN preferredvendorstatus = True THEN 'Preferred'
		WHEN preferredvendorstatus = False THEN 'Not Preferred'
		ELSE NULL END AS preferredvendorstatus_2,
	COUNT(*) vendor_count,
	AVG(CAST(creditrating AS decimal)) average_credit_rating
FROM purchasing.vendor
WHERE activeflag = True
GROUP BY 1
-- Answer: lower (recall 1 is the best credit rating)

-- d. How many vendors are active and Not Preferred?
SELECT
	CASE WHEN preferredvendorstatus = True THEN 'Preferred'
		WHEN preferredvendorstatus = False THEN 'Not Preferred'
		ELSE NULL END AS preferredvendorstatus_2,
	COUNT(*) vendor_count
FROM purchasing.vendor
WHERE activeflag = True
GROUP BY 1
-- Answer: 7




-- QUESTION 15

-- a. Calculate the age for every current employee. What is the age of the oldest employee
SELECT 
	CONCAT(firstname, ' ', lastname) full_name,
	birthdate,
	(CURRENT_DATE - birthdate)/365::FLOAT employee_age,
	AGE(current_date, birthdate) employee_age_2
FROM humanresources.employee a
	JOIN person.person b ON a.businessentityid = b.businessentityid
ORDER BY 3 DESC
-- Answer: 71 yrs old (as of 2023)

-- b. What is the average age by organization level? Show answer with a single decimal
SELECT 
	CASE 
		WHEN LENGTH(organizationnode) >= 9 THEN 5
		WHEN LENGTH(organizationnode) = 8 THEN 4
		WHEN LENGTH(organizationnode) = 7 THEN 4
		WHEN LENGTH(organizationnode) = 5 THEN 3
		WHEN LENGTH(organizationnode) = 3 THEN 2
		WHEN LENGTH(organizationnode) = 1 THEN 1
		ELSE NULL END AS organization_level,
	ROUND(AVG((CURRENT_DATE - birthdate)/365::FLOAT)::numeric, 1) employee_age
FROM humanresources.employee a
	JOIN person.person b ON a.businessentityid = b.businessentityid
GROUP BY 1
ORDER BY 1


-- c. Use the ceiling function to round up
SELECT 
	CASE 
		WHEN LENGTH(organizationnode) >= 9 THEN 5
		WHEN LENGTH(organizationnode) = 8 THEN 4
		WHEN LENGTH(organizationnode) = 7 THEN 4
		WHEN LENGTH(organizationnode) = 5 THEN 3
		WHEN LENGTH(organizationnode) = 3 THEN 2
		WHEN LENGTH(organizationnode) = 1 THEN 1
		ELSE NULL END AS organization_level,
	CEILING(AVG((CURRENT_DATE - birthdate)/365::FLOAT)::numeric) employee_age
FROM humanresources.employee a
	JOIN person.person b ON a.businessentityid = b.businessentityid
GROUP BY 1
ORDER BY 1



-- d. Use the floow function to round down
SELECT 
	CASE 
		WHEN LENGTH(organizationnode) >= 9 THEN 5
		WHEN LENGTH(organizationnode) = 8 THEN 4
		WHEN LENGTH(organizationnode) = 7 THEN 4
		WHEN LENGTH(organizationnode) = 5 THEN 3
		WHEN LENGTH(organizationnode) = 3 THEN 2
		WHEN LENGTH(organizationnode) = 1 THEN 1
		ELSE NULL END AS organization_level,
	FLOOR(AVG((CURRENT_DATE - birthdate)/365::FLOAT)::numeric) employee_age
FROM humanresources.employee a
	JOIN person.person b ON a.businessentityid = b.businessentityid
GROUP BY 1
ORDER BY 1






-- QUESTION 16

-- a. How many products are sold by AdventureWorks?
SELECT COUNT(DISTINCT(productid))
FROM production.product
WHERE finishedgoodsflag = True
-- Answer: 295

-- b. How many of these products are actively being sold by Adventureworks?
SELECT COUNT(DISTINCT(productid))
FROM production.product
WHERE finishedgoodsflag = True
	AND sellenddate IS NULL
-- Answer: 197


-- c. How many of these active products are made in house vs purchased?
SELECT 
	makeflag made_in_house,
	COUNT(DISTINCT(productid))
FROM production.product
WHERE finishedgoodsflag = True
	AND sellenddate IS NULL
GROUP BY 1
-- Answer: 136






-- QUESTION 17

-- a. Sum the total_sales in SalesOrderDetail. Format as currency
SELECT CAST(SUM(orderqty * (unitprice - unitpricediscount)) AS money) total_sales
FROM sales.salesorderdetail
-- Answer: $110,371,846.20

-- b. Sum the total_sales in SalesOrderDetail by the MakeFlag in the product table.
--    Use a case statement to specify manufactured vs. purchased. Format as currency.
SELECT
	CASE WHEN makeflag = True THEN 'manufactured'
	ELSE 'purchased' END makeflag,
	CAST(SUM(orderqty * (unitprice - unitpricediscount)) AS money) total_sales
FROM sales.salesorderdetail a
	LEFT JOIN production.product b ON a.productid = b.productid
GROUP BY 1
-- Answer: manufactured $106,673,860.88; purchased $3,697,985.32

-- c. Add a count of distinct SalesOrderIDs
SELECT
	CASE WHEN makeflag = True THEN 'manufactured'
	ELSE 'purchased' END makeflag,
	CAST(SUM(orderqty * (unitprice - unitpricediscount)) AS money) total_sales,
	COUNT(DISTINCT(salesorderid)) orders
FROM sales.salesorderdetail a
	LEFT JOIN production.product b ON a.productid = b.productid
GROUP BY 1
-- Answer: manufactured 18801; purchased 23773

-- d. What is the average sales per SalesOrderID
SELECT
	CAST(SUM(orderqty * (unitprice - unitpricediscount)) AS money) total_sales,
	COUNT(DISTINCT(salesorderid)) orders,
	CAST(SUM(orderqty * (unitprice - unitpricediscount)) / COUNT(DISTINCT(salesorderid)) AS money) avg_sales
FROM sales.salesorderdetail a
	LEFT JOIN production.product b ON a.productid = b.productid
-- Answer: $3,507.77






-- QUESTION 18

/* a. In the TransactionHistory and TransactionHistoryArchive
tables a "W", "S", and "P" are used as Transaction types. What
do these abbreviations mean? */
SELECT 
	transactiontype,
	name,
	finishedgoodsflag, 
	safetystocklevel,
	standardcost,
	daystomanufacture,
	productline,
	class,
	style
FROM production.transactionhistory a
	LEFT JOIN production.product b ON a.productid = b.productid
-- WHERE transactiontype = 'P'

/* Answer: 
	W = $0 actualcost, always manufactured in house
	S = >$0 actualcost, referenceorderid > 4000, generally few items in each order (44 or less),
		both manufactured and not manufactured in house, 
	P = >$0 actualcost, referenceorderid <= 4000, always not manufactured in house
	
	After looking up the definitions, W = Workorder, S = Salesorder, P = Purchaseorder. These
	definitions make sense, given our findings above. For example, it makes sense that work orders
	have $0 cost and are manufactured in house, it makes sense that purchase orders tend to have 
	much higher purchase amounts and quantities than a regular salesorder, and it makes sense that
	purchase orders have no cost and are always manufactured in house. */

-- b. Union TransactionHistory and TransactionHistoryArchive
(SELECT * FROM production.transactionhistory)
UNION
(SELECT * FROM production.transactionhistoryarchive)

/* Find the First and Last TransactionDate in the TransactionHistory
and TransactionHistoryArchive tables. Use the union written in part
b. The current data type for TransactionDate is datetime. Convert or
Cast the data type to date. */
WITH temp AS (
	(SELECT * FROM production.transactionhistory)
	UNION
	(SELECT * FROM production.transactionhistoryarchive)
)
SELECT 
	CAST(MAX(transactiondate) AS date) last_transactiondate,
	CAST(MIN(transactiondate) AS date) first_transactiondate
FROM temp
-- Answer: first 2011-04-16; last 2014-08-03

/* d. Find the First and Last Date for each transaction type. Use a
case statement to specify the transaction types. */
WITH temp AS (
	(SELECT * FROM production.transactionhistory)
	UNION
	(SELECT * FROM production.transactionhistoryarchive)
)
SELECT
	CASE 
		WHEN transactiontype = 'P' THEN 'purchase_order'
		WHEN transactiontype = 'W' THEN 'work_order'
		WHEN transactiontype = 'S' THEN 'sales_order'
		ELSE NULL END AS transactiontype,
	CAST(MIN(transactiondate) AS date) first_date,
	CAST(MAX(transactiondate) AS date) last_date
FROM temp
GROUP BY 1
/* Answer:
trxtype			first_date		last_date
"sales_order"	"2011-05-31"	"2014-06-30"
"work_order"	"2011-06-03"	"2014-06-02"
"purchase_order"	"2011-04-16"	"2014-08-03"
*/





-- QUESTION 19

/* a. We learned in Question 18 that the most recent sales order transaction
occurred on 2014-06-30 and the first sales order transaction occurred on
2011-05-31. Does the SalesOrderHeader table show a similar order date for the 
first and last sale? Format as Date. */
SELECT
	CAST(MAX(orderdate) AS date) last_order,
	CAST(MIN(orderdate) AS date) first_order
FROM sales.salesorderheader
-- Answer: Yes, we see the same first/last sales order dates





-- QUESTION 20

/* We learned in Question 19 that the first and most recent OrderDate in the
SalesOrderHeader table matches the Sales Order Date in the transactionhistory 
table (Question 18). */

/* a. Find the other tables and dates that should match the WorkOrder and
PurchaseOrder Dates. Format these dates as a date in the YYYY-MM-DD format. */
SELECT
	CAST(MAX(startdate) AS date) last_order,
	CAST(MIN(startdate) AS date) first_order
FROM production.workorder
/* Answer
last_order		first_order
"2014-06-02"	"2011-06-03"
*/

SELECT
	CAST(MAX(orderdate) AS date) last_order,
	CAST(MIN(orderdate) AS date) first_order
FROM purchasing.purchaseorderheader
/* Answer
last_order		first_order
"2014-09-22"	"2011-04-16"
*/

-- b. Do the dates match? Why / Why not?
/* Answer: All dates match, except the last purchase order date, which is greater in our new table
than in the transactionhistory table. Looking at the status column, we see that the status of this
transaction may be pending (status 2), which would explain why it's not yet recorded in the
transactionhistory table. */






-- QUESTION 21

/* AdventureWorks works with customers, employees and business partners all over the globe. The
accounting department needs to be sure they are up-to-date on Country and State tax rates. */

-- a. Pull a list of every country and state in the database.
SELECT
	CountryRegionCode,
	name
FROM person.stateprovince
GROUP BY 1, 2
ORDER BY 1, 2

-- b. Include tax rates.
SELECT
	CountryRegionCode,
	a.name,
	taxtype,
	taxrate
FROM person.stateprovince a
	LEFT JOIN sales.salestaxrate b ON a.stateprovinceid = b.stateprovinceid
ORDER BY 1, 2

/* c. There are 181 rows when looking at countries and states, but once you add tax rates the
number of rows increases to 184. Why is this? */
-- Answer: Certain regions in Canada (Alberta, Ontario & Quebec) each have two different taxtypes.


-- d. Which location has the highest tax rate?
SELECT
	CountryRegionCode,
	a.name,
	taxtype,
	taxrate
FROM person.stateprovince a
	LEFT JOIN sales.salestaxrate b ON a.stateprovinceid = b.stateprovinceid
WHERE taxrate IS NOT NULL
ORDER BY 4 DESC
-- Answer: France





-- QUESTION 22
/* The Marketing Department has never run ads in the United Kingdom and
would like you to pull a list of every individual customer (PersonType = IN)
by country */

-- a. How many individual (retail) customers exist in the person table?
SELECT COUNT(*)
FROM person.person
WHERE persontype = 'IN'
-- Answer: 18,484

-- b. Show this breakdown by country
SELECT 
	e.name country,
	COUNT(DISTINCT(a.businessentityid)) people
FROM person.person a
	LEFT JOIN person.businessentityaddress b ON a.businessentityid = b.businessentityid
	LEFT JOIN person.address c ON b.addressid = c.addressid
	LEFT JOIN person.stateprovince d ON c.stateprovinceid = d.stateprovinceid
	LEFT JOIN person.countryregion e ON d.countryregioncode = e.countryregioncode
WHERE persontype = 'IN'
GROUP BY 1
ORDER BY 2 DESC


/* c. What percent of total customers reside in each country? For Example, if
there are 1000 total customers and 200 live in the US then 20% of the customers
live in the United States. */
SELECT 
	e.name country,
	COUNT(DISTINCT(a.businessentityid)) people,
	CONCAT(ROUND((100.0 * COUNT(DISTINCT(a.businessentityid)))::decimal / 
		(SELECT COUNT(DISTINCT(businessentityid)) FROM person.person WHERE persontype = 'IN')::decimal, 2)::VARCHAR, '%') pct_share 
FROM person.person a
	LEFT JOIN person.businessentityaddress b ON a.businessentityid = b.businessentityid
	LEFT JOIN person.address c ON b.addressid = c.addressid
	LEFT JOIN person.stateprovince d ON c.stateprovinceid = d.stateprovinceid
	LEFT JOIN person.countryregion e ON d.countryregioncode = e.countryregioncode
WHERE persontype = 'IN'
GROUP BY 1
ORDER BY 2 DESC






-- QUESTION 23:

/* In Question 22 I used an Innery Query as the denominator when calculation the "%ofTotal" (see below).
Take this query and replace the denominator with a declare/local variable. Below you will find a 
"Current Query" and a "Desired Query". Write the syntax necessary to make the "Desired Query" Functional.
*/

-- Answer: Not able to cleanly declare constant variable in Postgres. Best practice is to use WITH statement and CROSS JOIN

WITH temp AS ( 
SELECT 
	COUNT(DISTINCT(businessentityid)) as TotalRetailCustomers
	FROM person.person 
	WHERE persontype = 'IN')

SELECT
	e.name country,
	COUNT(DISTINCT(a.businessentityid)) people,
	CONCAT(ROUND((100.0 * COUNT(DISTINCT(a.businessentityid)))::decimal / 
				 AVG(TotalRetailCustomers), 2)::VARCHAR, '%') pct_share 
FROM temp CROSS JOIN person.person a
	LEFT JOIN person.businessentityaddress b ON a.businessentityid = b.businessentityid
	LEFT JOIN person.address c ON b.addressid = c.addressid
	LEFT JOIN person.stateprovince d ON c.stateprovinceid = d.stateprovinceid
	LEFT JOIN person.countryregion e ON d.countryregioncode = e.countryregioncode
WHERE persontype = 'IN'
GROUP BY 1
ORDER BY 2 DESC;






-- QUESTION 24:

-- a. In the SalesOrderHeader what is the difference between "SubTotal" and "TotalDue"?
SELECT 
	subtotal,
	taxamt,
	freight,
	totaldue
FROM sales.salesorderheader
-- Answer: Totaldue includes tax amount and freight costs.

-- b. Which one of these matches the "LineTotal" in the SalesOrderDetail?
SELECT 
	a.salesorderid,
	AVG(subtotal) subtotal,
	AVG(totaldue) totaldue,
	SUM(orderqty * unitprice * (1-unitpricediscount)) AS linetotal
FROM sales.salesorderheader a
	JOIN sales.salesorderdetail b ON a.salesorderid = b.salesorderid
GROUP BY 1
-- Answer: Subtotal

-- c. How is TotalDue calculated in SalesOrderHeader?
SELECT
	totaldue,
	(subtotal + taxamt + freight) totaldue_calculated
FROM sales.salesorderheader
-- Answer: Subtotal + taxamt + freight.

-- d. How is LineTotal calculated in SalesOrderDetail?
SELECT
	linetotal,
	(orderqty * unitprice * (1-unitpricediscount)) AS linetotal_calculated
FROM sales.salesorderdetail
-- Answer: orderqty * unitprice * (1-unitpricediscount)

-- e. BONUS: practice formatting in postgresql
SELECT
	totaldue,
	FORMAT('totaldue = %s', CAST(totaldue as money)) totaldue_2,
	FORMAT('%s', CONCAT(ROUND(totaldue*100, 2), '%')) totaldue_3
FROM sales.salesorderheader






-- QUESTION 25: 

/* In general Gross Revenue is calculated by taking the Amount of Sales/Revenue without removing the
expenses to sell that item. Which also means that in general Net Revenue is the Amount of Sales/Revenue 
after the expenses have been subtracted.

Which product has the best margins? (Highest Net Revenue) */

SELECT
	productid,
	name,
	listprice,
	standardcost,
	listprice-standardcost net_revenue
FROM production.product
ORDER BY net_revenue DESC
-- Answer: Mountain-100 Silver, [44, 48, 38, 42]





-- QUESTION 26:

/* As we learned in Question 25, the "Mountain-100 Silver" and the "Mountain-100 Black" bicycles have the 
highest margins... meaning the ListPrice to StandardCost ratio is higher than any other product. */

-- a. Within the Production.Product table find a identifier that groups the 8 "Mountain-100" bicycles (4 Silver and 4 Black).
SELECT *
FROM production.product
WHERE productmodelid = 19
-- Answer: use productmodelid = 19


-- b. How many special offers have been applied to these 8 bicycles? 
SELECT
	a.productid,
	b.specialofferid,
	COUNT(*)
FROM production.product a
	LEFT JOIN sales.specialofferproduct b ON a.productid = b.productid
WHERE productmodelid = 19
GROUP BY 1, 2
ORDER BY 1, 2
-- Answer: 3 special offers (1, 2 & 7) have been applied across these 8 products. The majority of these products
--         have had all 3 special offers applied, but a few products have only had 2 of the offers applied (1 & 7).

-- b. When did the special offer start? When did the special offer end? What was the special offer?
SELECT
	c.specialofferid,
	startdate,
	enddate,
	description,
	discountpct,
	type
FROM production.product a
	LEFT JOIN sales.specialofferproduct b ON a.productid = b.productid
	LEFT JOIN sales.specialoffer c ON b.specialofferid = c.specialofferid
WHERE productmodelid = 19
--GROUP BY 1
ORDER BY 1
-- Answer: specialofferid = 1 started on 2011-05-01 and ended on 2014-11-30. This offer did not include a discount
--		   specialofferid = 2 started on 2011-05-31 and ended on 2014-05-30. This included a 2% volume discount and only applied to 5 of the 8 products
--		   specialofferid = 7 started on 2012-04-13 and ended on 2012-05-29. This included a 35% clearance discount to move discontinued products


-- c. Based on the most recent special offer start date is the product actually discontinued? Is the product still sold?
SELECT
	a.productid,
	a.name,
	orderdate
FROM production.product a
	LEFT JOIN sales.salesorderdetail b ON a.productid = b.productid
	LEFT JOIN sales.salesorderheader c ON b.salesorderid = c.salesorderid
WHERE a.productmodelid = 19
ORDER BY 3 DESC
-- Answer: It looks like the last sale of these bikes was on the last day of the 35% clearance sale. 
--         So it does appear that the product was discontinued, or at least no purchases have been made since end of clearance sale.


-- d. When was the last date the product was sold to an actual customer?
-- Answer: Per query in part c, the last sale was made on 5/29/2012, the last day of the clearance sale.






-- QUESTION 27

/* We learned in Question 26 that the 8 bicycles that fall under the 19 ProductModelID don't have a discontinued
date. However, this model hasn't been ordered since  May 29, 2012. The most recent purchase (any item) was June 30, 2014. 
Which means this product either has been discounted and there isn't a discontinued date, or the product is still being 
sold, but hasn't been purchased in 2 years. Which is it?  */
SELECT
	a.name,
	SUM(quantity) total_inventory
FROM Production.product a
	LEFT JOIN production.productinventory b ON a.productid = b.productid
WHERE a.productid BETWEEN 771 AND 778
GROUP BY 1
ORDER BY 2 DESC

-- Answer: We still see items in inventory, so this implies that the items are still being sold but no sales have occurred since 2012-05-29






-- QUESTION 28

-- a. Using Sales.SalesReason pull a distinct list of every sales reason.
SELECT 
	DISTINCT name sales_reason,
	COUNT(DISTINCT(c.salesorderid)) total_sales_orders
FROM sales.salesreason a
	LEFT JOIN sales.salesorderheadersalesreason b ON a.salesreasonid = b.salesreasonid
	LEFT JOIN sales.salesorderheader c ON b.salesorderid = c.salesorderid
GROUP BY 1
ORDER BY 2 DESC


-- b. Add a count of SalesOrderID's to the sales reason.
SELECT 
	DISTINCT name sales_reason,
	COUNT(DISTINCT(c.salesorderid)) total_sales_orders
FROM sales.salesreason a
	LEFT JOIN sales.salesorderheadersalesreason b ON a.salesreasonid = b.salesreasonid
	LEFT JOIN sales.salesorderheader c ON b.salesorderid = c.salesorderid
GROUP BY 1
ORDER BY 2 DESC


-- c. Which Sales Reason is most common?
-- Answer: Price






-- QUESTION 29

/* Based on the results in question 28, there are 27,647 rows in the SalesOrderHeaderSalesReason table. 
Which means these 27,647 are assigned to a SalesReason. However, there are 31,465 unique SalesOrderIDs in the SalesOrderHeader 
table. This is due to the fact that a SalesOrder can have zero, one, or multiple sales reasons listed. For Example, 
SalesOrderID 44044 has "Manufacturer" and "Quality" listed as reasons why the customer purchased. The most reasons listed 
for a single SalesOrderID is 3.

Using a CTE (Common Table Expression) find the number of SalesOrderIDs that have zero, one, two, and three sales reasons.
*/

WITH temp AS (
	SELECT
		a.salesorderid,
		COUNT(DISTINCT(b.salesreasonid)) sales_reason_count
	FROM sales.salesorderheader a
		LEFT JOIN sales.salesorderheadersalesreason b ON a.salesorderid = b.salesorderid
	GROUP BY 1
	ORDER BY 2 DESC
)

SELECT
	sales_reason_count,
	COUNT(*) total_salesorderids,
	CONCAT(ROUND(100.0 * CAST(COUNT(*) AS numeric) / CAST((SELECT COUNT(*) FROM temp) AS numeric), 2), '%') pct_share
FROM temp
GROUP BY 1
ORDER BY 1






-- QUESTION 30

/* Assume the sales team wants to reach out to folks who left a review (ProductReview). Is it possible to find 
the customers that left a review in the Person table? Make your best attempt at finding these customers.  */

WITH temp AS (
	SELECT
		reviewername,
		SPLIT_PART(reviewername, ' ', 1) first_name,
		SPLIT_PART(reviewername, ' ', 2) last_name,
		emailaddress
	FROM production.productreview
)

SELECT *
FROM temp a
	LEFT JOIN person.person b ON (a.first_name = b.firstname AND a.last_name = b.lastname)

-- Answer: No clean way of identifying reviewers. Tried matching emails in person.emailaddress table, but no luck. Best
-- 			alternative was to match on first & last names, which still didn't work well. Would be great if we had a table
--			of business that each person was associated with, and attempt to match business name with email alias.





-- QUESTION 31

-- Ken Sánchez, the CEO of AdventureWorks, has recently changed his email address.

-- a. What is Ken's current email address?
SELECT 
	emailaddress,
	*
FROM person.person a
	LEFT JOIN person.emailaddress b ON a.businessentityid = b.businessentityid
	LEFT JOIN humanresources.employee c ON a.businessentityid = c.businessentityid
WHERE (firstname = 'Ken')
	AND (lastname = 'Sánchez')
	AND (jobtitle = 'Chief Executive Officer')
--LIMIT 1

-- b. Update his email address to 'Ken.Sánchez@adventure-works.com'
UPDATE person.emailaddress
SET emailaddress = 'Ken.Sánchez@adventure-works.com'
WHERE businessentityid = 1


UPDATE person.emailaddress
SET emailaddress = 'ken3@adventure-works.com'
WHERE businessentityid = 1726




-- QUESTION 32:

/* As we learned in Question 31 there are two individuals in the AdventureWorks Database named Ken Sánchez. 
One is the CEO of the Company the other is a retail customer. Lets assume for this question that you used the 
following script to update the email address:

        Update Person.EmailAddress
	Set EmailAddress = 'Ken.Sánchez@adventure-works.com'
	Where p.FirstName ='Ken'
	  and p.LastName = 'Sánchez'
	  
The script above is not correct and would update both records. One of which is not the Ken Sánchez we are 
wanting to update. In this question we are going to set Ken's (the CEO) email back to the original email 
(assuming it has been updated from question 31). Then we are going to use BEGIN TRANSACTION, ROLLBACK, and 
COMMIT to fix/correct a mistake.  */

-- a. Update Ken's Email Address to the orginial address using the script below:

Update Person.EmailAddress
Set EmailAddress = 'ken0@adventure-works.com'
Where BusinessEntityID = 1


-- b. Check the number of open transactions by running: Select @@TranCount
SELECT @@TRANCOUNT


-- c. Start the transaction with the BEGIN TRAN statement. You can use BEGIN TRANSACTION
--    or BEGIN TRAN. Then check the number of open transactions again.
BEGIN TRANSACTION


-- d. Run our incorrect update statement
Update Person.EmailAddress
Set EmailAddress = 'Ken.Sánchez@adventure-works.com'
Where BusinessEntityID IN (1, 1726)

 
-- e. Correct the mistake/error by running the ROLLBACK statement
ROLLBACK

-- f. Check to see if the mistake has been fixed.
SELECT
	emailaddress,
	*
FROM person.emailaddress
WHERE emailaddress = 'Ken.Sánchez@adventure-works.com'

-- g. Start the transaction, run the correct update statement, COMMIT the transaction

BEGIN TRANSACTION;

UPDATE Person.EmailAddress
SET EmailAddress = 'Ken.Sánchez@adventure-works.com'
WHERE BusinessEntityID = 1;

COMMIT;


-- h. Question 33 we will automate whether the Transaction commits or rollsback.





-- QUESTION 33:

/* 
Complete questions 31 and 32 before attempting this question.

Before starting this question be sure the email address for both Ken Sánchez's are updated to their 
original emails. Run the statements below to be sure:

    Update Person.EmailAddress
	Set EmailAddress = 'ken0@adventure-works.com'
	Where BusinessEntityID = 1;
 
	Update Person.EmailAddress
	Set EmailAddress = 'ken3@adventure-works.com'
	Where BusinessEntityID = 1726;


In Question 32 we used BEGIN TRAN, ROLLBACK, and COMMIT to be sure that our updates work properly. 
Write a script that will commit if the update is correct. If the update is not correct then rollback. 
For example, If we know how many rows need to be updated then we can use a @@ROWCOUNT and if that number 
doesn't meet the condition then rollsback. If it does meet the condition then it commits.

Use the same update statement used in Question 32 (see below):

    Update Person.EmailAddress
	Set EmailAddress = 'Ken.Sánchez@adventure-works.com'
	Where BusinessEntityID = 1 
*/

BEGIN TRANSACTION;

UPDATE Person.EmailAddress
SET EmailAddress = 'Ken.Sánchez@adventure-works.com'
WHERE BusinessEntityID = 1


IF (SELECT COUNT(*) FROM person.emailaddress WHERE emailaddress = 'Ken.Sánchez@adventure-works.com') = 1 THEN COMMIT
ELSE ROLLBACK






-- QUESTION 34:

-- a. Using the RANK function rank the employees in the Employee table by the hiredate. Label the column as 'Seniority'
SELECT
	RANK() OVER (ORDER BY hiredate) AS seniority,
	*
FROM humanresources.employee
ORDER BY 1


-- b. Assuming Today is March 3, 2014, add 3 columns for the number of days, months, and years the employee has been employed.
SELECT
	RANK() OVER (ORDER BY hiredate) AS seniority,
	AGE('2014-03-03'::timestamp, hiredate) period_employed,
	ROUND(EXTRACT(epoch FROM ('2014-03-03'::timestamp - hiredate))/60/60/24, 0) days_employed,
	ROUND(EXTRACT(YEAR FROM AGE('2014-03-03'::timestamp, hiredate)) * 12 +
		EXTRACT(MONTH FROM AGE('2014-03-03'::timestamp, hiredate)) +
		EXTRACT(DAY FROM AGE('2014-03-03'::timestamp, hiredate))/30, 2) AS months_employed,
	ROUND(EXTRACT(YEAR FROM AGE('2014-03-03'::timestamp, hiredate)) +
		EXTRACT(MONTH FROM AGE('2014-03-03'::timestamp, hiredate))/12 +
		EXTRACT(DAY FROM AGE('2014-03-03'::timestamp, hiredate))/365, 2) AS years_employed,
	*
FROM humanresources.employee
ORDER BY 1








-- QUESTION 35:

-- In Question 34 we add 4 columns to the Employee table - Seniority, DaysEmployed, MonthsEmployed, and YearsEmployed.

-- a. Using a Select Into Statement put this table into a Temporary Table. Name the table '#Temp1'
WITH temp_1 AS (
	SELECT
		RANK() OVER (ORDER BY hiredate) AS seniority,
		AGE('2014-03-03'::timestamp, hiredate) period_employed,
		ROUND(EXTRACT(epoch FROM ('2014-03-03'::timestamp - hiredate))/60/60/24, 0) days_employed,
		ROUND(EXTRACT(YEAR FROM AGE('2014-03-03'::timestamp, hiredate)) * 12 +
			EXTRACT(MONTH FROM AGE('2014-03-03'::timestamp, hiredate)) +
			EXTRACT(DAY FROM AGE('2014-03-03'::timestamp, hiredate))/30, 2) AS months_employed,
		ROUND(EXTRACT(YEAR FROM AGE('2014-03-03'::timestamp, hiredate)) +
			EXTRACT(MONTH FROM AGE('2014-03-03'::timestamp, hiredate))/12 +
			EXTRACT(DAY FROM AGE('2014-03-03'::timestamp, hiredate))/365, 2) AS years_employed,
		*
	FROM humanresources.employee
	ORDER BY 1
)
SELECT *
INTO Temp1
FROM temp_1;

SELECT *
FROM Temp1;


/* b. Run this statement:

Select * 
From Temp1
Where BusinessEntityID in ('288','286');

Notice that these two Employees have worked for AdventureWorks for 10 months; however, the 
YearsEmployed says "1." The DateDiff Function I used in our statement above does simple math:(2014 - 2013 = 1). 
Update the YearsEmployed to "0" for these two Employees. */

UPDATE Temp1
SET years_employed = 0
WHERE BusinessEntityID in ('288','286');

-- c. Using the Temp table, how many employees have worked for AdventureWorks over 5 years and 6 months?

SELECT COUNT(*)
FROM Temp1
WHERE months_employed > 66;
-- Answer: 19

/* d. Create a YearsEmployed Grouping like below:
	- Employed Less Than 1 Year
	- Employed 1-3 Years
	- Employed 4-6
	- Employed Over 6 Years
Show a count of Employees in each group. */
SELECT
	CASE 
		WHEN years_employed < 1 THEN 'Employed Less Than 1 Year'
		WHEN years_employed < 3.5 THEN 'Employed 1-3 Years'
		WHEN years_employed <= 6 THEN 'Employed 4-6 Years'
		WHEN years_employed > 6 THEN 'Employed Over 6 Years'
	ELSE NULL END AS years_employed_grouping,
	COUNT(*)
FROM Temp1
GROUP BY 1
ORDER BY 2 DESC

/* e. Show the average VacationHours and SickLeaveHours by the YearsEmployed Group. Which Group has 
the highest average Vacation and SickLeave Hours? */
SELECT
	CASE 
		WHEN years_employed < 1 THEN 'Employed Less Than 1 Year'
		WHEN years_employed < 3.5 THEN 'Employed 1-3 Years'
		WHEN years_employed <= 6 THEN 'Employed 4-6 Years'
		WHEN years_employed > 6 THEN 'Employed Over 6 Years'
	ELSE NULL END AS years_employed_grouping,
	COUNT(*) employee_count,
	ROUND(AVG(vacationhours), 2) avg_vacation_hrs,
	ROUND(AVG(sickleavehours), 2) avg_sickleave_hrs
FROM Temp1
GROUP BY 1
ORDER BY 3 DESC
-- Answer: Employed 4-6 Years






-- QUESTION 36:

-- AdventureWorks leadership has asked you to put together a report. Follow the steps below to build the report.

-- a. Pull a distinct list of every region. Use the SalesTerritory as the region.
SELECT
	territoryid,
	name
FROM sales.salesterritory

-- b. Add the Sum(TotalDue) to the list of regions
SELECT
	a.territoryid,
	a.name,
	CAST(SUM(totaldue) AS money) totaldue_total
FROM sales.salesterritory a
	LEFT JOIN sales.salesorderheader b
	ON a.territoryid = b.territoryid
GROUP BY 1, 2
ORDER BY 3 DESC

-- c. Add each customer name. Concatenate First and Last Names
SELECT
	c.name territory,
	CONCAT(firstname, ' ', lastname) full_name,
	CAST(SUM(totaldue) AS money) totaldue_total	
FROM sales.customer a
	LEFT JOIN person.person b ON a.customerid = b.businessentityid
	LEFT JOIN sales.salesterritory c ON a.territoryid = c.territoryid
	RIGHT JOIN sales.salesorderheader d ON a.customerid = d.customerid
GROUP BY 1, 2
ORDER BY 1, 3 DESC


-- d. Using ROW_NUMBER and a partition rank each customer by region. For example, Australia is a region 
-- 	  and we want to rank each customer by the Sum(TotalDue). 
WITH temp1 AS (
	SELECT
		c.name territory,
		CONCAT(firstname, ' ', lastname) full_name,
		CAST(SUM(totaldue) AS money) totaldue_total	
	FROM sales.customer a
		LEFT JOIN person.person b ON a.personid = b.businessentityid
		LEFT JOIN sales.salesterritory c ON a.territoryid = c.territoryid
		RIGHT JOIN sales.salesorderheader d ON a.customerid = d.customerid
	GROUP BY 1, 2
	ORDER BY 1, 3 DESC
)
SELECT
	*,
	ROW_NUMBER() OVER (PARTITION BY territory ORDER BY totaldue_total DESC) rnk
FROM temp1
ORDER BY 4






-- QUESTION 37

/* In Question 36 the leadership team asked you to build a report. Based on those results
the leadership team has decided to start a loyalty program and gift the top 25 customers (in
terms of totaldue/sales) a free loyalty membership.

Below is the script we wrote in question 36:

Select 
	distinct st.Name as RegionName
	,Concat(p.FirstName,' ',p.LastName) as CustomerName
	,Format(Sum(TotalDue),'C0') as TotalDue
	,ROW_NUMBER() Over(Partition by st.Name Order by Sum(TotalDue) desc) as RowNum
From Sales.SalesTerritory st
	Inner Join Sales.SalesOrderHeader soh on soh.TerritoryID = st.TerritoryID
	Inner Join Sales.Customer c on c.CustomerID = soh.CustomerID
	Inner Join Person.Person p on p.BusinessEntityID = c.PersonID
Group by 
	st.Name
	,Concat(p.FirstName,' ',p.LastName) 
*/

-- a. Limit the results in question 36 to only show the top 25 customers in  each region. 
--    There are 10 regions so you should have 250 rows.
WITH temp1 AS (
	SELECT
		c.name territory,
		CONCAT(firstname, ' ', lastname) full_name,
		CAST(SUM(totaldue) AS money) totaldue_total	
	FROM sales.customer a
		LEFT JOIN person.person b ON a.personid = b.businessentityid
		LEFT JOIN sales.salesterritory c ON a.territoryid = c.territoryid
		RIGHT JOIN sales.salesorderheader d ON a.customerid = d.customerid
	GROUP BY 1, 2
	ORDER BY 1, 3 DESC
), temp2 AS (
	SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY territory ORDER BY totaldue_total DESC) rnk
	FROM temp1
	ORDER BY 4
)
SELECT *
FROM temp2
WHERE rnk < 26
ORDER BY 1, 4


-- b. What is the average TotalDue per Region? Leave the top 25 filter
WITH temp1 AS (
	SELECT
		c.name territory,
		CONCAT(firstname, ' ', lastname) full_name,
		CAST(SUM(totaldue) AS money) totaldue_total	
	FROM sales.customer a
		LEFT JOIN person.person b ON a.personid = b.businessentityid
		LEFT JOIN sales.salesterritory c ON a.territoryid = c.territoryid
		RIGHT JOIN sales.salesorderheader d ON a.customerid = d.customerid
	GROUP BY 1, 2
	ORDER BY 1, 3 DESC
), temp2 AS (
	SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY territory ORDER BY totaldue_total DESC) rnk
	FROM temp1
	ORDER BY 4
)
SELECT
	territory,
	CAST(AVG(CAST(totaldue_total AS numeric)) AS money) avg_totaldue_total
FROM temp2
WHERE rnk < 26
GROUP BY 1
ORDER BY 2 DESC






-- QUESTION 38

-- Due to an increase in shipping cost you've been asked to pull a few figures related to the freight column in Sales.SalesOrderHeader

-- a. How much has AdventureWorks spent on freight in totality?
SELECT 
	CAST(SUM(freight) AS money) total_freight_cost
FROM sales.salesorderheader
-- Answer: $3,183,430.25

-- b. Show how much has been spent on freight by year (ShipDate)
SELECT 
	EXTRACT(year FROM shipdate) ship_year,
	CAST(SUM(freight) AS money) total_freight_cost
FROM sales.salesorderheader
GROUP BY 1
ORDER BY 1

-- c. Add the average freight per SalesOrderID
SELECT 
	EXTRACT(year FROM shipdate) ship_year,
	CAST(SUM(freight) AS money) total_freight_cost,
	CAST(SUM(freight)/COUNT(DISTINCT(salesorderid)) AS money) avg_freight_per_salesorderid
FROM sales.salesorderheader
GROUP BY 1
ORDER BY 1

-- d. Add a Cumulative/Running Total sum
WITH temp1 AS (
	SELECT 
		EXTRACT(year FROM shipdate) ship_year,
		CAST(SUM(freight) AS money) total_freight_cost,
		CAST(SUM(freight)/COUNT(DISTINCT(salesorderid)) AS money) avg_freight_per_salesorderid
	FROM sales.salesorderheader
	GROUP BY 1
	ORDER BY 1
)
SELECT
	*,
	SUM(total_freight_cost) OVER (ORDER BY ship_year) freight_cumulative_sum
FROM temp1






-- QUESTION 39

/*
In Question 38 we did some simple analysis on Freight costs by year. However, the TotalFreight 
value could be skewed by incomplete years. Take the script written in Question 38 (see below) 
and answer the following questions.

Select 
	ShipYear
	,Format(TotalFreight,'C0') as TotalFreight
	,Format(AvgFreight,'C0') as AvgFreight
	,Format(Sum(TotalFreight) Over (Order by ShipYear),'C0') as RunningTotal
From(
	Select 
		Year(ShipDate) as ShipYear
		,Sum(Freight) as TotalFreight
		,Avg(Freight) as AvgFreight 
	From Sales.SalesOrderHeader
	Group by 
		Year(ShipDate))a
*/

-- a. How many months were completed in each Year. 
--    Obviously a full year has 12 months, but some of these years could be partial. 
--    Leave all of the columns, just add the count of completed months in each Year.
WITH temp1 AS (
	SELECT 
		EXTRACT(year FROM shipdate) ship_year,
		CAST(SUM(freight) AS money) total_freight_cost,
		CAST(SUM(freight)/COUNT(DISTINCT(salesorderid)) AS money) avg_freight_per_salesorderid,
		COUNT(DISTINCT(EXTRACT(month FROM shipdate))) months_completed
	FROM sales.salesorderheader
	GROUP BY 1
	ORDER BY 1
)
SELECT
	*,
	SUM(total_freight_cost) OVER (ORDER BY ship_year) freight_cumulative_sum
FROM temp1


-- b. Calculate the average Total Freight by completed month
WITH temp1 AS (
	SELECT 
		EXTRACT(year FROM shipdate) ship_year,
		CAST(SUM(freight) AS money) total_freight_cost,
		CAST(SUM(freight)/COUNT(DISTINCT(salesorderid)) AS money) avg_freight_per_salesorderid,
		COUNT(DISTINCT(EXTRACT(month FROM shipdate))) months_completed
	FROM sales.salesorderheader
	GROUP BY 1
	ORDER BY 1
)
SELECT
	*,
	SUM(total_freight_cost) OVER (ORDER BY ship_year) freight_cumulative_sum,
	total_freight_cost / months_completed avg_monthly_freight_cost
FROM temp1






-- QUESTION 40

/* In Question 38 and 39 we analyzed the Freight costs by Year.

In Question 39 we adjusted some of those calculations by accounting for incomplete years. 
In this question we are going to analyze freight costs at the Monthly level.
*/

-- a. Start by writing a query that shows freight costs by Month (use ShipDate). Be sure to include year. 
--    Include two Month columns one where month is 1-12 and another with the full month written out (i.e. January)
SELECT 
	EXTRACT(year FROM shipdate) ship_year,
	EXTRACT(month FROM shipdate) ship_month_number,
	TO_CHAR(shipdate, 'Month') ship_month_name,		
	CAST(SUM(freight) AS money) total_freight_cost
FROM sales.salesorderheader
GROUP BY 1, 2, 3
ORDER BY 1, 2

-- b. Add an average
SELECT 
	EXTRACT(year FROM shipdate) ship_year,
	EXTRACT(month FROM shipdate) ship_month_number,
	TO_CHAR(shipdate, 'Month') ship_month_name,		
	CAST(SUM(freight) AS money) total_freight_cost,
	CAST(SUM(freight)/COUNT(DISTINCT(salesorderid)) AS money) avg_freight_per_salesorderid
FROM sales.salesorderheader
GROUP BY 1, 2, 3
ORDER BY 1, 2
	
	
-- c. Add a cumulative sum start with June 2011 and go to July 2014. July 2014 should reconile to the Freight in
--    totality ($3,183,430)
WITH temp1 AS (
	SELECT 
		EXTRACT(year FROM shipdate) ship_year,
		EXTRACT(month FROM shipdate) ship_month_number,
		TO_CHAR(shipdate, 'Month') ship_month_name,		
		CAST(SUM(freight) AS money) total_freight_cost,
		CAST(SUM(freight)/COUNT(DISTINCT(salesorderid)) AS money) avg_freight_per_salesorderid
	FROM sales.salesorderheader
	GROUP BY 1, 2, 3
	ORDER BY 1, 2
)
SELECT
	*,
	SUM(total_freight_cost) OVER (ORDER BY ship_year, ship_month_number) frieght_cost_cumulative_sum
FROM temp1

-- d. Add a yearly cumulative Sum, which means every January will start over.
WITH temp1 AS (
	SELECT 
		EXTRACT(year FROM shipdate) ship_year,
		EXTRACT(month FROM shipdate) ship_month_number,
		TO_CHAR(shipdate, 'Month') ship_month_name,		
		CAST(SUM(freight) AS money) total_freight_cost,
		CAST(SUM(freight)/COUNT(DISTINCT(salesorderid)) AS money) avg_freight_per_salesorderid
	FROM sales.salesorderheader
	GROUP BY 1, 2, 3
	ORDER BY 1, 2
)
SELECT
	*,
	SUM(total_freight_cost) OVER (PARTITION BY ship_year ORDER BY ship_month_number) frieght_cost_annual_cumulative_sum
FROM temp1






-- QUESTION 41

/*
In this question we are going to build a report that will be used in Question 42 to update a 
null column in the SalesOrderHeader. The results in this question need to include one row per SalesOrderID (31,465 rows). 
Include the following columns:

	a. SalesOrderID
	b. Customer Name (include First and Last Names)
	c. Person.PersonType (don't use the abbreviations, spell out each PersonType)
	d. Sales Person Name (include First and Last Names). If a SalesOrderID doesn't have a Sales person then specify with 'No Sales Person'
	e. OrderDate
	f. Amount of Product quantity purchased
*/

SELECT
	a.salesorderid,
	CONCAT(c.firstname, ' ', c.lastname) customer_name,
	CASE
		WHEN c.persontype = 'IN' THEN 'Individual Customer'
		WHEN c.persontype = 'SC' THEN 'Store Contact'
		ELSE NULL END AS persontype,
	CASE 
		WHEN d.firstname IS NULL THEN 'No Sales Person' 
		ELSE CONCAT(d.firstname, ' ', d.lastname) END salesperson_name,
	orderdate,
	SUM(orderqty) order_qty
FROM sales.salesorderheader a
	LEFT JOIN sales.customer b ON a.customerid = b.customerid
	LEFT JOIN person.person c ON b.personid = c.businessentityid
	LEFT JOIN person.person d ON a.salespersonid = d.businessentityid
	LEFT JOIN sales.salesorderdetail e ON a.salesorderid = e.salesorderid
GROUP BY 1, 2, 3, 4, 5
ORDER BY 6 DESC






-- QUESTION 42

/*
Using the results from Question 41 (see below) we are going to update the comment column 
in SalesOrderHeader. The column is currently null. We want the comment in SalesOrderHeader to say:
	"[CustomerName] is a(n) [PersonType] and purchased [OrderQty] Product(s) from [SalesPersonName] on [OrderDate]."

a. Using the column elements From Question 41 build a CTE (common table expression) that includes two 
	columns - SalesOrderID and Comment. Here is an example for Customer (BusinessEntityID) 49123:
		"Michael Allen is a(n) Store Contact and purchased 72 Product(s) from Jillian Carson on 12/31/2012."
*/
WITH temp1 AS (
	SELECT
		a.salesorderid,
		CONCAT(c.firstname, ' ', c.lastname) customer_name,
		CASE
			WHEN c.persontype = 'IN' THEN 'Individual Customer'
			WHEN c.persontype = 'SC' THEN 'Store Contact'
			ELSE NULL END AS persontype,
		CASE 
			WHEN d.firstname IS NULL THEN 'No Sales Person' 
			ELSE CONCAT(d.firstname, ' ', d.lastname) END salesperson_name,
		orderdate,
		SUM(orderqty) order_qty
	FROM sales.salesorderheader a
		LEFT JOIN sales.customer b ON a.customerid = b.customerid
		LEFT JOIN person.person c ON b.personid = c.businessentityid
		LEFT JOIN person.person d ON a.salespersonid = d.businessentityid
		LEFT JOIN sales.salesorderdetail e ON a.salesorderid = e.salesorderid
	GROUP BY 1, 2, 3, 4, 5
	ORDER BY 6 DESC
)
SELECT
	salesorderid,
	CONCAT(customer_name, ' is a(n) ', persontype, ' and purchased ', order_qty,
		   ' Product(s) from ', salesperson_name, ' on ', TO_CHAR(orderdate::date, 'mm/dd/yyyy'), '.') AS comment
FROM temp1


-- b. Update SalesOrderHeader.Comment using the CTE from part a. Remember there are 31,465 unique SalesOrderID's.

WITH temp1 AS (
	SELECT
		a.salesorderid,
		CONCAT(c.firstname, ' ', c.lastname) customer_name,
		CASE
			WHEN c.persontype = 'IN' THEN 'Individual Customer'
			WHEN c.persontype = 'SC' THEN 'Store Contact'
			ELSE NULL END AS persontype,
		CASE 
			WHEN d.firstname IS NULL THEN 'No Sales Person' 
			ELSE CONCAT(d.firstname, ' ', d.lastname) END salesperson_name,
		orderdate,
		SUM(orderqty) order_qty
	FROM sales.salesorderheader a
		LEFT JOIN sales.customer b ON a.customerid = b.customerid
		LEFT JOIN person.person c ON b.personid = c.businessentityid
		LEFT JOIN person.person d ON a.salespersonid = d.businessentityid
		LEFT JOIN sales.salesorderdetail e ON a.salesorderid = e.salesorderid
	GROUP BY 1, 2, 3, 4, 5
	ORDER BY 6 DESC
), temp2 AS (
	SELECT
		salesorderid,
		CONCAT(customer_name, ' is a(n) ', persontype, ' and purchased ', order_qty,
			   ' Product(s) from ', salesperson_name, ' on ', TO_CHAR(orderdate::date, 'mm/dd/yyyy'), '.') AS comment
	FROM temp1
)

UPDATE sales.salesorderheader z
SET comment = temp2.comment
FROM temp2
WHERE temp2.salesorderid = z.salesorderid






-- QUESTION 43

-- a. How many Sales people are meeting their YTD Quota? 
--    Use an Inner query (subquery) to show a single value meeting this criteria

WITH temp1 AS (
	SELECT
		businessentityid,
		CAST(salesytd AS money),
		CAST(salesquota AS money),
		CONCAT(ROUND(100*salesytd / salesquota, 2), '%') pct_quota_attainment
	FROM sales.salesperson
	WHERE (salesytd / salesquota) >= 1
)
SELECT COUNT(*)
FROM temp1

-- Answer: 14

-- b. How many Sales People have YTD sales greater than the average Sales Person YTD sales.
--    Also use an Inner Query to show a single value of those meeting this criteria.

WITH temp1 AS (
	SELECT
		businessentityid,
		CAST(salesytd AS money) salesytd		
	FROM sales.salesperson
	WHERE salesytd > (SELECT AVG(salesytd) FROM sales.salesperson)
)
SELECT COUNT(*)
FROM temp1

-- Answer: 8





-- QUESTION 44

/*
a. Create a stored procedure called "Sales_Report_YTD" without an output parameter that
	will show the sales people the following information:

	- BusinessEntityID
	- CommissionPct
	- SalesYTD
	- Commission
	- Bonus
*/

CREATE PROCEDURE sales_report_ytd AS (
	SELECT
		businessentityid,
		CONCAT(ROUND(100*commissionpct, 1), '%') commissionpct,
		CAST(salesytd AS money),
		CAST(commissionpct * salesytd AS money) commission,
		CAST(bonus AS money)
	FROM sales.salesperson
);

-- b. Execute the Stored Procedure
EXEC sales_report_ytd

-- c. Delete the Stored Procedure
DROP PROCEDURE sales_report_ytd






-- QUESTION 45

/*
In Question 44 we created a stored Procedure called "Sales_Report_YTD." In this question
we are going to create the same stored procedure with a single parameter. In Question 44 
when we execute the stored procedure it shows all the sales information for each 
BusinessEntity. Lets assume this information is highly sensitive and each sales person 
should only know their unique BusinessEntityID. Add a parameter that would require a user 
to input their BusinessEntityID to view their own personal sale information.
*/

-- a. Create the Stored Procedure with the BusinessEntityID as the single parameter
CREATE PROCEDURE sales_report_ytd 
businessentityid_input INT AS (
	SELECT
		businessentityid,
		CONCAT(ROUND(100*commissionpct, 1), '%') commissionpct,
		CAST(salesytd AS money),
		CAST(commissionpct * salesytd AS money) commission,
		CAST(bonus AS money)
	FROM sales.salesperson
	WHERE businessentityid = businessentityid_input
);


-- b. Execute the Stored Procedure for BussinessEntityID 279
EXEC sales_report_ytd
businessentityid_input = 279

-- c. Delete the Stored Procedure
DROP PROCEDURE sales_report_ytd






-- QUESTION 46

-- In this question we are going to be working with Purchasing.Vendor.

-- a. Show each credit rating by a count of vendors

SELECT
	creditrating,
	COUNT(*) vendor_count
FROM purchasing.vendor
GROUP BY 1
ORDER BY 2 DESC

/* b. Use a case statement to specify each rating by a count of vendors:
	1 = Superior
	2 = Excellent
	3 = Above Average
	4 = Average
	5 = Below Average
*/

SELECT
	creditrating,
	CASE
		WHEN creditrating = 1 THEN 'Superior'
		WHEN creditrating = 2 THEN 'Excellent'
		WHEN creditrating = 3 THEN 'Above Average'
		WHEN creditrating = 4 THEN 'Average'
		WHEN creditrating = 5 THEN 'Below Average'
	ELSE NULL END creditrating_2,
	COUNT(*) vendor_count
FROM purchasing.vendor
GROUP BY 1, 2
ORDER BY 3 DESC


/* c. Using the Choose Function accomplish the same results as part b (Don't use case statement).
	1 = Superior
	2 = Excellent
	3 = Above Average
	4 = Average
	5 = Below Average
*/

SELECT
	creditrating,
	CASE
		WHEN creditrating = 1 THEN 'Superior'
		WHEN creditrating = 2 THEN 'Excellent'
		WHEN creditrating = 3 THEN 'Above Average'
		WHEN creditrating = 4 THEN 'Average'
		WHEN creditrating = 5 THEN 'Below Average'
	ELSE NULL END creditrating_2,
	CHOOSE (creditrating, 'Superior', 'Excellent', 'Above Average', 'Average', 'Below Average') creditrating_3,
	COUNT(*) vendor_count
FROM purchasing.vendor
GROUP BY 1, 2, 3
ORDER BY 4 DESC



/* d. Using a case statement show the PreferredVendorStatus by a count of Vendors. 
(This might seem redundant, but This exercise will help you learn when to use a case 
statement and when to use the choose function).
	0 = Not Preferred
	1 = Preferred
*/

SELECT
	preferredvendorstatus,
	CASE
		WHEN preferredvendorstatus = True THEN 'Preferred'
		WHEN preferredvendorstatus = False THEN 'Not Preferred'
	ELSE NULL END preferredvendorstatus_2,
	COUNT(*) vendor_count
FROM purchasing.vendor
GROUP BY 1, 2
ORDER BY 3 DESC



/* e. Using the Choose Function accomplish the same results as part d 
(Don't use case statement).  Why doesn't the Choose Function give the same 
results as part d? Which is correct?
	0 = Not Preferred
	1 = Preferred
*/

SELECT
	preferredvendorstatus,
	CASE
		WHEN preferredvendorstatus = True THEN 'Preferred'
		WHEN preferredvendorstatus = False THEN 'Not Preferred'
	ELSE NULL END preferredvendorstatus_2,
	CHOOSE (preferredvendorstatus, 'Not Preferred', 'Preferred'),
	COUNT(*) vendor_count
FROM purchasing.vendor
GROUP BY 1, 2, 3
ORDER BY 4 DESC






-- QUESTION 47

/*
In Question 46 we wrote two scripts that gave the same output/results. One script we used a 
case statement the other statement we used a choose function. In this question we are going 
to write very similar scripts and it might seem redundant to answer these questions but this 
will help you learn when to use Case, Choose, and IIf. In question 46 we learned that the credit 
rating has a description (i.e. 1 = Superior). However, in this question we are going to assume 
that AdventureWorks only deems a vendor as "Approved" if they have a "Superior" credit rating. 
If the vendor has any other rating then they are "Not Approved". Credit Rating Grouping:

	1 = Approved
	2 = Not Approved
	3 = Not Approved
	4 = Not Approved
	5 = Not Approved
*/

-- a. Using a case statement show a count of vendors by "Approved" vs. "Not Approved".
SELECT
	CASE
		WHEN creditrating = 1 THEN 'Approved'
	ELSE 'Not Approved' END approval_status,
	COUNT(*) vendor_count
FROM purchasing.vendor
GROUP BY 1
ORDER BY 2 DESC


-- b. Using the Choose function show a count of vendors by "Approved" vs. "Not Approved".
SELECT
	CASE
		WHEN creditrating = 1 THEN 'Approved'
	ELSE 'Not Approved' END approval_status,
	CHOOSE(creditrating, 'Approved', 'Not Approved', 'Not Approved', 'Not Approved', 'Not Approved') approval_status_2,
	COUNT(*) vendor_count
FROM purchasing.vendor
GROUP BY 1, 2
ORDER BY 3 DESC


-- c. Using the IIF function show a count of vendors by "Approved" vs. "Not Approved".
SELECT
	CASE
		WHEN creditrating = 1 THEN 'Approved'
	ELSE 'Not Approved' END approval_status,
	CHOOSE(creditrating, 'Approved', 'Not Approved', 'Not Approved', 'Not Approved', 'Not Approved') approval_status_2,
	IFF(creditrating = 1, 'Approved', 'Not Approved') approval_status_3,
	COUNT(*) vendor_count
FROM purchasing.vendor
GROUP BY 1, 2, 3
ORDER BY 4 DESC





-- QUESTION 48

/* a. Write an Alter Statement that will add a column to the Purchasing.Vendor. Name the Column 
		- CreditRatingDesc" (varchar(100) data type). */

ALTER TABLE purchasing.vendor
	ADD creditratingdesc VARCHAR(100);
	
	
/* b. Using the credit rating and a case statement (Question 46 part b)  or a Choose function 
		(Question 46 part c) update "CreditRatingDesc".
		
		1 = Superior
		2 = Excellent
		3 = Above Average
		4 = Average
		5 = Below Average
*/

UPDATE purchasing.vendor
SET creditratingdesc = temp1.creditrating_2
FROM purchasing.vendor b INNER JOIN 
	(
	SELECT
		businessentityid,
		CASE
			WHEN creditrating = 1 THEN 'Superior'
			WHEN creditrating = 2 THEN 'Excellent'
			WHEN creditrating = 3 THEN 'Above Average'
			WHEN creditrating = 4 THEN 'Average'
			WHEN creditrating = 5 THEN 'Below Average'
		ELSE NULL END creditrating_2
	FROM purchasing.vendor) temp1
		ON b.businessentityid = temp1.businessentityid

SELECT *
FROM purchasing.vendor


-- c. Drop the "CreditRatingDesc" Column.

ALTER TABLE purchasing.vendor
DROP COLUMN creditratingdesc







-- QUESTION 49

-- a. Using the INFORMATION_SCHEMA.COLUMNS table find the data type for Vendor.Name
SELECT data_type
FROM information_schema.columns
WHERE (table_name = 'vendor')
	AND (column_name = 'name')
-- Answer: VARCHAR(50)


-- b. Does this data type have an alias? In other words, is it a user defined data type?
--    If so, what is it?
Select 
	DOMAIN_SCHEMA
	,DOMAIN_NAME
From INFORMATION_SCHEMA.COLUMNS
Where TABLE_NAME = 'Vendor'
	and COLUMN_NAME = 'Name'
-- Answer: Yes, name.


-- c. Using the INFORMATION_SCHEMA.COLUMNS table show a count of data types by user defined data types.
SELECT
	domain_schema,
	domain_name,
	COUNT(*)
FROM information_schema.columns
GROUP BY 1, 2








-- QUESTION 50

-- In question 49 we learned there are 6 user defined data types in the AdventureWorks database. In this 
-- question we are going to create a new user defined data type.

-- a. Using INFORMATION_SCHEMA.COLUMNS write a query that will show every column that has the 
--		columnName = Status.  What is the data type for these columns?

SELECT data_type, *
FROM information_schema.columns
WHERE (column_name = 'status')
	OR (column_name = 'Status')
-- Answer: smallint


-- b. Create a new User defined data type named 'Status." The data type will be tinyint and notice 
--		that in the INFORMATION_SCHEMA.COLUMNS table the IS_NULLABLE column says 'No.' This means 
--		when you're creating the user defined data type be sure to specify Not Null.
CREATE TYPE status FROM tinyint NOT NULL


-- c. Write an Alter statement to change the data type on PurchaseOrderHeader.Status from tinyint
--		to the new User Defined data type, status. Did the Domain Name in INFORMATION_SCHEMA.COLUMNS change?

ALTER TABLE purchasing.purchaseorderheader
ALTER COLUMN [status] status


-- d. Try to Drop the Status User Defined Data Type. You will get an error. Why?
DROP TYPE status


-- e. Write an Alter Statement to change the data type on PurchaseOrderHeader.Status back to the tinyint
--		(don't forget the NOT NULL).

ALTER TABLE purchasing.purchaseorderheader
ALTER COLUMN [status] tinyint NOT NULL


-- f. Now Drop the Status User Defined Data Type
DROP TYPE status






-- QUESTION 51

/* This fictional scenario will be true for questions 51, 52, and 53.

As AdventureWorks continues to grow more and more data will be captured, meaning proper storage 
and server space will be needed. Dan Wilson, the database administrator at AdventureWorks has 
reached out to you. Dan is currently working on a project to determine how much storage and server
space will be needed for the next year. He has asked you to idenitfy the following 5 columns:

	a. Table Name
	b. The number of rows in each user table (remember there are 71 user tables. 72 if you count 
		sysdiagrams for the entity relationship diagram.) Use the rows column in sys.partitions.
	c. The current allocated space for each table in kilobytes (kb)
	d. The used space for each table in kilobytes (kb)
	e. The unused space for each table in kilobytes (kb)

*Note* (pages * 8) = kilobytes
*/


Select 
    t.name as TableName
    ,Max(p.rows) as RowCNT
    ,Sum(u.total_pages * 8) as TotalAllocated_kb
    ,Sum(u.used_pages * 8) as Used_kb
    ,(Sum(u.total_pages * 8) - Sum(u.used_pages * 8)) as Unused_kb
From sys.allocation_units u
    Inner Join sys.partitions p on p.hobt_id = u.container_id
    Inner Join sys.tables t on t.object_id = p.object_id
Group by t.name

-- ^Note, this won't work in Postgres, or where sys tables aren't available






-- QUESTION 52

/* As AdventureWorks continues to grow more and more data will be captured, meaning proper 
storage and server space will be needed. Dan Wilson, the database administrator at AdventureWorks 
has reached out to you. Dan is currently working on a project to determine how much storage and 
server space will be needed for the next year. Use the script provided in the question 51 explanation.

	SELECT 
		t.name as TableName
		,Max(p.rows) as RowCNT
		,Sum(u.total_pages) * 8 as TotalAllocated_kb
		,Sum(u.used_pages) * 8 as Used_kb
		,(Sum(u.total_pages) * 8) - (Sum(u.used_pages) * 8) as Unused_kb
	FROM sys.allocation_units AS u
		Inner Join sys.partitions AS p ON u.container_id = p.hobt_id
		Inner Join sys.tables AS t ON p.object_id = t.object_id
	GROUP BY t.name
*/	
	
-- a. Add a flag that will show the tables that have less than 10% space unused.
SELECT 
    t.name as TableName
    ,Max(p.rows) as RowCNT
    ,Sum(u.total_pages) * 8 as TotalAllocated_kb
    ,Sum(u.used_pages) * 8 as Used_kb
    ,(Sum(u.total_pages) * 8) - (Sum(u.used_pages) * 8) as Unused_kb
    ,Case When Cast((Sum(u.total_pages) * 8) - (Sum(u.used_pages) * 8) as decimal)
        /nullif(Sum(u.total_pages)*8,0) < .10
      Then 1 Else 0 End as Flg
FROM sys.allocation_units AS u
    Inner Join sys.partitions AS p ON u.container_id = p.hobt_id
    Inner Join sys.tables AS t ON p.object_id = t.object_id
GROUP BY t.name


-- b. Put the results in a view. This could easily be shared with Dan and others. Name the View: vDatabaseAllocation
Create View vDatabaseAllocation
As 
(SELECT 
    t.name as TableName
    ,Max(p.rows) as RowCNT
    ,Sum(u.total_pages) * 8 as TotalAllocated_kb
    ,Sum(u.used_pages) * 8 as Used_kb
    ,(Sum(u.total_pages) * 8) - (Sum(u.used_pages) * 8) as Unused_kb
    ,Case When Cast((Sum(u.total_pages) * 8) - (Sum(u.used_pages) * 8) as decimal)
        /nullif(Sum(u.total_pages)*8,0) < .10
      Then 1 Else 0 End as Flg
FROM sys.allocation_units AS u
    Inner Join sys.partitions AS p ON u.container_id = p.hobt_id
    Inner Join sys.tables AS t ON p.object_id = t.object_id
GROUP BY t.name)

-- ^Note, this won't work in Postgres, or where sys tables aren't available






-- QUESTION 53

/*
This fictional scenario will be true for questions 51, 52, and 53.

As AdventureWorks continues to grow more and more data will be captured, meaning proper storage
and server space will be needed. Dan Wilson, the database administrator at AdventureWorks has 
reached out to you. Dan is currently working on a project to determine how much storage and server
space will be needed for the next year.

Now that we have calculated current state of the Adventureworks database in terms of storage and
space we need to calculate however much space will be needed for next year. Here are some 
assumptions we are going to use. First Adventureworks has been in operation for roughly 1127 days.
We also know that the next year will be 365 days. Which means we need to calculate the space 
(kilobytes) needed per day. Then we can use that daily average to determine what will be needed 
for the next year (1127 + 365 = 1492).

Here is the script provided in the 52 explanation:

	Create View vDatabaseAllocation
	AS
	(SELECT 
		t.name as TableName
		,Max(p.rows) as RowCNT
		,Sum(u.total_pages) * 8 as TotalAllocated_kb
		,Sum(u.used_pages) * 8 as Used_kb
		,(Sum(u.total_pages) * 8) - (Sum(u.used_pages) * 8) as Unused_kb
		,Case when cast((Sum(u.total_pages) * 8) - (Sum(u.used_pages) * 8) as decimal)
			/nullif(Sum(u.total_pages) * 8,0) < .10
			Then 1 Else 0 End as Flg
	FROM sys.allocation_units AS u
		Inner Join sys.partitions AS p ON u.container_id = p.hobt_id
		Inner Join sys.tables AS t ON p.object_id = t.object_id
	GROUP BY t.name)

Using the assumptions above calculate the projected space needed per table for current state and
the next 365 days. Again, 1127 + 365 = 1492. Either recreate the view or write an alter statement 
adding the new column.
*/

Alter View vDatabaseAllocation
AS
(SELECT 
    t.name as TableName
    ,Max(p.rows) as RowCNT
    ,Sum(u.total_pages) * 8 as TotalAllocated_kb
    ,Sum(u.used_pages) * 8 as Used_kb
    ,(Sum(u.total_pages) * 8) - (Sum(u.used_pages) * 8) as Unused_kb
    ,Case when cast((Sum(u.total_pages) * 8) - (Sum(u.used_pages) * 8) as decimal)
        /nullif(Sum(u.total_pages) * 8,0) < .10
            Then 1 Else 0 End as Flg
    ,Format((cast((Sum(u.used_pages) * 8) as decimal)
        /1127) * 1492,'N0') as Projected_kb
FROM sys.allocation_units AS u
    Inner Join sys.partitions AS p ON u.container_id = p.hobt_id
    Inner Join sys.tables AS t ON p.object_id = t.object_id
GROUP BY t.name)

-- ^Note, this won't work in Postgres, or where sys tables aren't available







-- QUESTION 54

/*
The Most recent order date in the salesorderheader table was June 30, 2014. 
Assume for this question that AdventureWorks has a sale coming up on July 4, 2014.
What is the avg totaldue on July 4 in years past for the whole day (not per order)?
*/

WITH temp1 AS (
	SELECT
		orderdate::date,
		SUM(totaldue) totaldue
	FROM sales.salesorderheader
	WHERE (EXTRACT(MONTH FROM orderdate) = 7)
		AND (EXTRACT(DAY FROM orderdate) = 4)
	GROUP BY 1
	ORDER BY 1
)
SELECT
	CAST(SUM(totaldue) / COUNT(DISTINCT(orderdate)) AS money) avg_daily_totaldue
FROM temp1

-- Alternative approach
SELECT
	CAST(SUM(totaldue) / COUNT(DISTINCT(orderdate)) AS money) avg_daily_totaldue
FROM sales.salesorderheader
WHERE (EXTRACT(MONTH FROM orderdate) = 7)
	AND (EXTRACT(DAY FROM orderdate) = 4)
	





-- QUESTION 55
 
-- Now that we have the average TotalDue sold on July 4:

-- a. calculate the totaldue by Year (still filtered to July 4). Which year has the most 
--		sold on July 4?
SELECT
	orderdate::date,
	CAST(SUM(totaldue) AS money) totaldue
FROM sales.salesorderheader
WHERE (EXTRACT(MONTH FROM orderdate) = 7)
	AND (EXTRACT(DAY FROM orderdate) = 4)
GROUP BY 1
ORDER BY 1
-- Answer: 2011


-- b. Add Day of the week - i.e. Monday, Tuesday, etc.
SELECT
	orderdate::date,
	EXTRACT(year FROM orderdate) order_year,
	TO_CHAR(orderdate, 'Day') order_dow,
	CAST(SUM(totaldue) AS money) totaldue
FROM sales.salesorderheader
WHERE (EXTRACT(MONTH FROM orderdate) = 7)
	AND (EXTRACT(DAY FROM orderdate) = 4)
GROUP BY 1, 2, 3
ORDER BY 1


-- c. Put this script in a temp table called #Temp1

DROP TABLE IF EXISTS Temp1;

SELECT
	orderdate::date,
	EXTRACT(year FROM orderdate) order_year,
	TO_CHAR(orderdate, 'Day') order_dow,
	CAST(SUM(totaldue) AS money) totaldue
INTO Temp1
FROM sales.salesorderheader
WHERE (EXTRACT(MONTH FROM orderdate) = 7)
	AND (EXTRACT(DAY FROM orderdate) = 4)
GROUP BY 1, 2, 3
ORDER BY 1;






-- QUESTION 56:
/*
Now that we have TotalDue sold on July 4 by year and by DayofWeek:

	Select 
		Year(OrderDate) as 'Year'
		,DATENAME(WEEKDAY,OrderDate) as 'DayofWeek'
		,Format(Sum(TotalDue),'C0') as TotalDue
	Into #Temp1
	From Sales.SalesOrderHeader
	Where (DATEPART(MM, OrderDate) = 7)
		AND (DATEPART(DD, OrderDate) = 4)
	Group by Year(OrderDate)
		,DATENAME(WEEKDAY,OrderDate)
	
a. Create another temp table (#Temp2) with the average TotalDue by DayofWeek. 
	For example, the average    TotalDue on Wednesday. You will need to calculate the 
	number of times that specific day has occured. Include the following columns:
	(all dates within the db)
	
	- DayofWeek
	- DayCount
	- TotalDue
	- AvgTotalperWkDay
*/

DROP TABLE Temp2;

SELECT
	EXTRACT(DOW FROM orderdate) counter,
	TO_CHAR(orderdate, 'Day') day_of_week,
	COUNT(DISTINCT(orderdate::date)) day_count,
	CAST(SUM(totaldue) AS money) total_due,
	CAST(SUM(totaldue) / COUNT(DISTINCT(orderdate::date)) AS money) avg_total_per_weekday
INTO Temp2
FROM sales.salesorderheader
GROUP BY 1, 2
ORDER BY 1;

SELECT *
FROM Temp2


-- b. Join #Temp2 back to #Temp1 (script written in question 55). Compare the average 
-- 		totaldue during a normal Dayofweek to the TotalDue on July 4.
SELECT
	*
FROM Temp1 
	FULL OUTER JOIN Temp2 ON Temp2.day_of_week = Temp1.order_dow
ORDER BY counter
-- Answer: Avg daily Totaldue is roughly 5-10 times greater on a normal weekday than on July 4.
-- 			This implies that the store is either closed and/or has very little traffic on the July 4th holiday.


-- c. Create a flag that shows whether the TotalDue on July 4 is higher or lower than 
--		the average DayofWeek. In years past has the July 4 sale been worth it?

SELECT
	CASE
		WHEN totaldue <= avg_total_per_weekday THEN False
		WHEN totaldue > avg_total_per_weekday THEN True
		WHEN totaldue IS NULL THEN NULL
	ELSE NULL END AS flag_july4_greater_than_avg,
	*
FROM Temp1 
	FULL OUTER JOIN Temp2 ON Temp2.day_of_week = Temp1.order_dow
ORDER BY counter






-- QUESTION 57

/*
In questions 55 and 56 we created temp tables. For the sake of practice lets assume you're
going to put those scripts in an automated workflow that will run everyday. Which means if
you try to create #Temp1 and #Temp2, but they already exist then you will get this error
- "There is already an object named '#temp1' in the database." In order to avoid this error
you want to drop the temp table before recreating. However if you attempt to drop the temp
table and it doesn't exist then you will get this error - "Invalid object name '#Temp1'."
Getting either of this errors could disrupt the automated workflow.

Therefore, you need to write a statement that will drop the table if it does exist, but will 
not fail if the table doesn't exist.
*/


DROP TABLE IF EXISTS Temp1;

SELECT
	orderdate::date,
	EXTRACT(year FROM orderdate) order_year,
	TO_CHAR(orderdate, 'Day') order_dow,
	CAST(SUM(totaldue) AS money) totaldue
INTO Temp1
FROM sales.salesorderheader
WHERE (EXTRACT(MONTH FROM orderdate) = 7)
	AND (EXTRACT(DAY FROM orderdate) = 4)
GROUP BY 1, 2, 3
ORDER BY 1;


DROP TABLE IF EXISTS Temp2;

SELECT
	EXTRACT(DOW FROM orderdate) counter,
	TO_CHAR(orderdate, 'Day') day_of_week,
	COUNT(DISTINCT(orderdate::date)) day_count,
	CAST(SUM(totaldue) AS money) total_due,
	CAST(SUM(totaldue) / COUNT(DISTINCT(orderdate::date)) AS money) avg_total_per_weekday
INTO Temp2
FROM sales.salesorderheader
GROUP BY 1, 2
ORDER BY 1;

SELECT *
FROM Temp2





-- QUESTION 58

/*
Run this statment:

    Select * 
    From Sales.vSalesPersonSalesByFiscalYears
	ORDER BY 1, 4
	
This is a view that is created from multiple AdventureWorks tables. You will notice that the data is outdated.
The data in the current database is from 2011-2014. As noted by the view name these dates are fiscal year. 
Without using the "Create to" in object explorer attempt to recreate this output for 2012, 2013, and 2014 
(the OrderDates are calendar year which means you will need to use a DateAdd to create fiscal year... adjusted 6 months).
The Dollar value is the SubTotal in the SalesOrderHeader.
*/

WITH temp1 AS (
	SELECT
		salespersonid,
		CONCAT(firstname, ' ', middlename, ' ', lastname) full_name,
		jobtitle,
		e.name salesterritory,
		EXTRACT(year FROM (orderdate::date + INTERVAL '6 MONTHS')) fiscal_year,
		CAST(SUM(subtotal) AS numeric) sales
	FROM sales.salesorderheader a
		LEFT JOIN person.person b ON a.salespersonid = b.businessentityid
		LEFT JOIN humanresources.employee c ON a.salespersonid = c.businessentityid	
		LEFT JOIN sales.salesperson d ON a.salespersonid = d.businessentityid
		LEFT JOIN sales.salesterritory e ON d.territoryid = e.territoryid
	GROUP BY 1, 2, 3, 4, 5
)
SELECT
	salespersonid "SalesPersonID",
	full_name "FullName",
	jobtitle "JobTitle",
	salesterritory "SalesTerritory",
--	CAST(SUM(CASE WHEN fiscal_year = 2011 THEN sales ELSE NULL END) AS money) "2011",
	CAST(SUM(CASE WHEN fiscal_year = 2012 THEN sales ELSE NULL END) AS money) "2012",
	CAST(SUM(CASE WHEN fiscal_year = 2013 THEN sales ELSE NULL END) AS money) "2013",	
	CAST(SUM(CASE WHEN fiscal_year = 2014 THEN sales ELSE NULL END) AS money) "2014"
FROM temp1
WHERE salesterritory IS NOT NULL
GROUP BY 1, 2, 3, 4
ORDER BY 1, 4






-- QUESTION 59

/*
In Question 58 we recreated the sales by fiscal year view by using the pivot function.
In this question we are also  going to use the pivot function.

In the ProductSubCategory table you will find the three highest selling (LineTotal) Product 
SubCategories are - Road Bikes, Mountain Bikes, and Touring Bikes. Create a table that 
will show you the Linetotal for each sales person by the subcategories for 2013 (orderdate). 
Order by the combined total of all three subcategories
*/


WITH temp1 AS (
	SELECT
		CONCAT(firstname, ' ', middlename, ' ', lastname) full_name,
		d.name product_subcategory,
		CAST(SUM(orderqty * unitprice * (1-unitpricediscount)) AS numeric) sales
	FROM sales.salesorderheader a
		LEFT JOIN sales.salesorderdetail b ON a.salesorderid = b.salesorderid
		LEFT JOIN production.product c ON b.productid = c.productid
		LEFT JOIN production.productsubcategory d ON c.productsubcategoryid = d.productsubcategoryid
		LEFT JOIN person.person e ON a.salespersonid = e.businessentityid
	WHERE (EXTRACT(year FROM orderdate) = 2013)
		AND (d.name IN ('Road Bikes', 'Mountain Bikes', 'Touring Bikes'))
	GROUP BY 1, 2
)
SELECT
	full_name,
	CAST(SUM(CASE WHEN product_subcategory = 'Road Bikes' THEN sales ELSE NULL END) AS money) "Road Bikes",
	CAST(SUM(CASE WHEN product_subcategory = 'Mountain Bikes' THEN sales ELSE NULL END) AS money) "Mountain Bikes",
	CAST(SUM(CASE WHEN product_subcategory = 'Touring Bikes' THEN sales ELSE NULL END) AS money) "Touring Bikes"
FROM temp1
WHERE NOT(full_name = '  ')
GROUP BY 1
ORDER BY SUM(sales) DESC





-- QUESTION 60

/*
In this question we are going to unpivot a data table. Below you will find a script. 
Run this script. I have created a table that can be deleted after this question.

Imagine AdventureWorks has sent a survey to 10 customers. Leadership wants feedback on 
how Sales People are treating clients. Before going any further run the script below:


	DROP TABLE IF EXISTS SalesPersonSurvey;

	CREATE TABLE SalesPersonSurvey (
		SurveyId INT NOT NULL,
		Overall_Experience INT NOT NULL,
		Will_you_purchase_from_AdventureWorks_Again INT NOT NULL,
		Likelihood_to_recommend_to_a_friend INT NOT NULL,
		SalesPerson_I_worked_with_was_helpful INT NOT NULL,
		SalesPerson_I_worked_with_was_Kind INT NOT NULL);

	INSERT INTO SalesPersonSurvey  
		(SurveyID
		,Overall_Experience
		,Will_you_purchase_from_AdventureWorks_Again
		,Likelihood_to_recommend_to_a_friend
		,SalesPerson_I_worked_with_was_helpful
	   	,SalesPerson_I_worked_with_was_Kind)
	VALUES
	 (1,5,4,3,3,3),(2,2,3,4,2,2),(3,1,1,4,1,1)
	,(4,4,5,5,5,2),(5,2,3,5,5,5),(6,3,3,5,5,5)
	,(7,4,3,5,5,5),(8,1,1,1,1,1),(9,4,3,5,4,5)
	,(10,2,3,3,3,3);

	Select * From SalesPersonSurvey;


Unpivot this table, create three columns - SurveyID, Question, Response.
*/


SELECT a.surveyid, b.question, b.response
FROM salespersonsurvey a
CROSS JOIN LATERAL (VALUES	('Overall_Experience', a.Overall_Experience),
							('Will_you_purchase_from_AdventureWorks_Again', a.Will_you_purchase_from_AdventureWorks_Again),
				   			('Likelihood_to_recommend_to_a_friend', a.Likelihood_to_recommend_to_a_friend),
				   			('SalesPerson_I_worked_with_was_helpful', a.SalesPerson_I_worked_with_was_helpful),
				   			('SalesPerson_I_worked_with_was_Kind', a.SalesPerson_I_worked_with_was_Kind))
					b(question, response);





-- QUESTION 61

/*
You've been asked my Brian Welcker, VP of Sales, to create a sales report for him. 
This scenario is true for questions 61, 62, 63, and 64.

Write a script that will show the following Columns

	- BusinessEntityID
	- Sales Person Name - Include Middle
	- SalesTerritory Name
	- SalesYTD from Sales.SalesPerson

Order by SalesYTD desc
*/

SELECT
	a.businessentityid,
	CASE
		WHEN middlename IS NULL THEN CONCAT(firstname, ' ', lastname)
		ELSE CONCAT(firstname, ' ', middlename, ' ', lastname) END full_name,
	c.name salesterritory,
	CAST(a.salesytd AS money)
FROM sales.salesperson a
	LEFT JOIN person.person b ON a.businessentityid = b.businessentityid
	LEFT JOIN sales.salesterritory c ON a.territoryid = c.territoryid
ORDER BY 4 DESC





-- QUESTION 62

/* Continuing on with question 61, add three columns to the script.

	1. Rank each Sales Person's SalesYTD to all the sales persons. The highest SalesYTD will be rank number 1
	2. Rank each Sales Person's SalesYTD to the sales persons in their territory. The highest SalesYTD
		in the territory will be rank number 1
	3. Create a Percentile for each sales person compared to all the sales people. The highest 
		SalesYTD will be in the 100th percentile
*/

SELECT
	a.businessentityid,
	CASE
		WHEN middlename IS NULL THEN CONCAT(firstname, ' ', lastname)
		ELSE CONCAT(firstname, ' ', middlename, ' ', lastname) END full_name,
	c.name salesterritory,
	CAST(a.salesytd AS money) salesytd,
	ROW_NUMBER() OVER (ORDER BY a.salesytd DESC) rnk_overall,
	ROW_NUMBER() OVER (PARTITION BY c.name ORDER BY a.salesytd DESC) rnk_territory,
	CONCAT(ROUND(100*(ROW_NUMBER() OVER (ORDER BY a.salesytd)) / (SELECT COUNT(*) FROM sales.salesperson), 0), '%') percentile_overall,
	CONCAT(ROUND(CAST((100*PERCENT_RANK() OVER (ORDER BY a.salesytd)) AS numeric), 0), '%') percentile_overall_2
FROM sales.salesperson a
	LEFT JOIN person.person b ON a.businessentityid = b.businessentityid
	LEFT JOIN sales.salesterritory c ON a.territoryid = c.territoryid
ORDER BY 4 DESC






-- QUESTION 63

/* Continuing on with question 62, Add Four columns to this script.

	1. Using the Lag function show the value one rank below. The highest SalesYTD will show the value of the second rank.
	2. Using the Lag function show the BusinessEntityID one rank below. The highest SalesYTD will show the BusinessEntityID of the second rank
	3. Using the Lead function show the value one rank above. The highest SalesYTD will show a null value (no rank is higher)
	4. Using the Lead function show the value 1 rank above. The highest SalesYTD will show a null value (no rank is higher)
*/

SELECT
	a.businessentityid,
	CASE
		WHEN middlename IS NULL THEN CONCAT(firstname, ' ', lastname)
		ELSE CONCAT(firstname, ' ', middlename, ' ', lastname) END full_name,
	c.name salesterritory,
	CAST(a.salesytd AS money) salesytd,
	ROW_NUMBER() OVER (ORDER BY a.salesytd DESC) rnk_overall,
	ROW_NUMBER() OVER (PARTITION BY c.name ORDER BY a.salesytd DESC) rnk_territory,
	CONCAT(ROUND(100*(ROW_NUMBER() OVER (ORDER BY a.salesytd)) / (SELECT COUNT(*) FROM sales.salesperson), 0), '%') percentile_overall,
	CONCAT(ROUND(CAST((100*PERCENT_RANK() OVER (ORDER BY a.salesytd)) AS numeric), 0), '%') percentile_overall_2
FROM sales.salesperson a
	LEFT JOIN person.person b ON a.businessentityid = b.businessentityid
	LEFT JOIN sales.salesterritory c ON a.territoryid = c.territoryid
ORDER BY 4 DESC






-- QUESTION 64

-- Rather than sending Brian a flat file you are going to put this script into a view called 
-- Sales.vSalesPersonSalesYTD. Be sure to delete the view when you are done with this question.

CREATE VIEW Sales.vSalesPersonSalesYTD AS
	SELECT
		a.businessentityid,
		CASE
			WHEN middlename IS NULL THEN CONCAT(firstname, ' ', lastname)
			ELSE CONCAT(firstname, ' ', middlename, ' ', lastname) END full_name,
		c.name salesterritory,
		CAST(a.salesytd AS money) salesytd,
		ROW_NUMBER() OVER (ORDER BY a.salesytd DESC) rnk_overall,
		ROW_NUMBER() OVER (PARTITION BY c.name ORDER BY a.salesytd DESC) rnk_territory,
		CONCAT(ROUND(100*(ROW_NUMBER() OVER (ORDER BY a.salesytd)) / (SELECT COUNT(*) FROM sales.salesperson), 0), '%') percentile_overall,
		CONCAT(ROUND(CAST((100*PERCENT_RANK() OVER (ORDER BY a.salesytd)) AS numeric), 0), '%') percentile_overall_2
	FROM sales.salesperson a
		LEFT JOIN person.person b ON a.businessentityid = b.businessentityid
		LEFT JOIN sales.salesterritory c ON a.territoryid = c.territoryid
	ORDER BY 4 DESC;

SELECT *
FROM Sales.vSalesPersonSalesYTD;

DROP VIEW Sales.vSalesPersonSalesYTD;






-- QUESTION 65

/*
Run this statement before proceeding:

Select *
From HumanResources.vEmployeeDepartmentHistory 


There are only 290 employees in the adventureworks database. However, in the view above there are 
296 rows of data. This view is created from 5 tables. You can use those five tables to help you answer this question.
*/

-- a. Show the list of employees (First and Last Name) that are in the view above more than once.

SELECT
	firstname,
	middlename,
	lastname,
	COUNT(*)
FROM HumanResources.vEmployeeDepartmentHistory 
GROUP BY 1, 2, 3
HAVING COUNT(*) > 1


-- b. Now show why they are listed more than once

WITH temp1 AS (
	SELECT
		CONCAT(firstname, middlename, lastname) name_,
		COUNT(*)
	FROM HumanResources.vEmployeeDepartmentHistory 
	GROUP BY 1
	HAVING COUNT(*) > 1
)
SELECT *
FROM HumanResources.vEmployeeDepartmentHistory 
WHERE CONCAT(firstname, middlename, lastname) IN (SELECT name_ FROM temp1)
-- Answer: Duplicates represent employees that have had multiple jobs at AdventureWorks. Each row represents an employed role.





-- QUESTION 66

-- This question we are going to setup a script that will allow us to practice the Percent_Rank Function in questions 67 and 68.

-- a. Join vEmployeeDepartmentHistory to EmployeePayHistory.
SELECT *
FROM humanresources.vEmployeeDepartmentHistory a
	INNER JOIN humanresources.employeepayhistory b ON a.businessentityid = b.businessentityid

/*
b. You will noticed after joining those two tables together that there are multiple rows per employee. 
	For Example, BusinessEntityID 4 has 6 rows of data because of multiple rate changes. Write a statement that 
	will give you one row per employee (290 rows) and only show the most recent and active rate. Include the Following Columns:
	
		-RowNum (see hint)
		-BusinessEntityID
		-FullName (First and Last Name)
		-Department
		-RateChangeDate
		-Rate
*/
WITH temp1 AS (
	SELECT
		ROW_NUMBER() OVER (PARTITION BY a.businessentityid ORDER BY ratechangedate DESC) rnk,
		a.businessentityid,
		CONCAT(firstname, ' ', lastname) fullname,
		department,
		ratechangedate,
		rate	
	FROM humanresources.vEmployeeDepartmentHistory a
		INNER JOIN humanresources.employeepayhistory b ON a.businessentityid = b.businessentityid
)
SELECT *
FROM temp1
WHERE rnk = 1





-- QUESTION 67

/*
In this question we are going to use the script above to practice the Percent_Rank function. 
Add a line of SQL code that will show the rate percentile for each Adventureworks employee. 
Order by the highest percentile. For example, Ken Sanchez the CEO has the highest pay rate therefore 
his rate will be 100th percentile.
*/

WITH temp1 AS (
	SELECT
		ROW_NUMBER() OVER (PARTITION BY a.businessentityid ORDER BY ratechangedate DESC) rnk,
		a.businessentityid,
		CONCAT(firstname, ' ', lastname) fullname,
		department,
		ratechangedate,
		rate
	FROM humanresources.vEmployeeDepartmentHistory a
		INNER JOIN humanresources.employeepayhistory b ON a.businessentityid = b.businessentityid
)
SELECT 
	*,
	CONCAT(ROUND(CAST(100*(PERCENT_RANK() OVER (ORDER BY rate)) AS numeric), 2), '%') rate_pctile
FROM temp1
WHERE rnk = 1
ORDER BY (PERCENT_RANK() OVER (ORDER BY rate)) DESC;






-- QUESTION 68

/*
In this question we are going to use the script above to practice another Percent_Rank scenario. 
Add a line of SQL code that will show the department rate percentile for each Adventureworks employee. 
For Example, in question 67 we learned that Laura Norman has a pay rate that is in the 99th percentile, 
but what is her pay rate within her department?
*/
WITH temp1 AS (
	SELECT
		ROW_NUMBER() OVER (PARTITION BY a.businessentityid ORDER BY ratechangedate DESC) rnk,
		a.businessentityid,
		CONCAT(firstname, ' ', lastname) fullname,
		department,
		ratechangedate,
		rate
	FROM humanresources.vEmployeeDepartmentHistory a
		INNER JOIN humanresources.employeepayhistory b ON a.businessentityid = b.businessentityid
)
SELECT 
	*,
	CONCAT(ROUND(CAST(100*(PERCENT_RANK() OVER (ORDER BY rate)) AS numeric), 2), '%') rate_pctile_overall,
	CONCAT(ROUND(CAST(100*(PERCENT_RANK() OVER (PARTITION BY department ORDER BY rate)) AS numeric), 2), '%') rate_pctile_dept
FROM temp1
WHERE rnk = 1
ORDER BY department, (PERCENT_RANK() OVER (PARTITION BY department ORDER BY rate)) DESC;






-- QUESTION 69

/*
In this question we are going to use the script above to practice creating quartiles using the nTile 
Function. Just to be clear, a quartile is 4 equal parts. For example, the 1st quartile is percentiles
75-100%... see below:

	- 1st quartile: 75-100 percentile
	- 2nd quartile: 50-75 percentile
	- 3rd quartile: 25-50 percentile
	- 4th quartile: 0-25 percentile

Add two lines of sql code. The first will show the quartile for each employee compared to the whole company.
The second will show the quartile for each employee within their department. If a department only has two 
employees then the department will only have 2 quartiles.
*/


WITH temp1 AS (
	SELECT
		ROW_NUMBER() OVER (PARTITION BY a.businessentityid ORDER BY ratechangedate DESC) rnk,
		a.businessentityid,
		CONCAT(firstname, ' ', lastname) fullname,
		department,
		ratechangedate,
		rate
	FROM humanresources.vEmployeeDepartmentHistory a
		INNER JOIN humanresources.employeepayhistory b ON a.businessentityid = b.businessentityid
)
SELECT 
	*,
	CONCAT(ROUND(CAST(100*(PERCENT_RANK() OVER (ORDER BY rate)) AS numeric), 2), '%') rate_pctile_overall,
	NTILE(4) OVER (ORDER BY rate DESC) ntile_overall,
	CONCAT(ROUND(CAST(100*(PERCENT_RANK() OVER (PARTITION BY department ORDER BY rate)) AS numeric), 2), '%') rate_pctile_dept,
	NTILE(4) OVER (PARTITION BY department ORDER BY rate DESC) ntile_dept	
FROM temp1
WHERE rnk = 1
ORDER BY department, rate DESC, ntile_dept;




-- QUESTION 70

-- a. How many distinct orderdates exist in Sales.SalesOrderHeader?
SELECT
	COUNT(DISTINCT(orderdate))
FROM sales.salesorderheader
-- Answer: 1124

-- b. Using DateDiff, how many days are between the first orderdate and last orderdate? 
--		*Note DateDiff is counting the days between two dates, which means you need to add a 1 when counting number of days.
SELECT
	MAX(orderdate) max_date,
	MIN(orderdate) min_date,
	(MAX(orderdate) - MIN(orderdate) + INTERVAL '1 DAY') days_between
FROM sales.salesorderheader	
-- Answer: 1127 days between

-- c. There are 1124 distinct days in Sales.SalesOrderHeader. However, there are 1127 from the first
--		orderdate and the last orderdate. Find the missing three dates. Dozens of ways to answer this question correctly.
WITH temp1 AS (
	SELECT
		DISTINCT(orderdate::date) orderdate
	FROM sales.salesorderheader
	ORDER BY 1
), temp2 AS (
	SELECT
		orderdate::date,
		LAG(orderdate::date) OVER (ORDER BY orderdate::date) orderdate_lag
	FROM temp1
)
SELECT
	*,
	orderdate - orderdate_lag diff,
	orderdate - 1 missing_dates
FROM temp2
WHERE NOT(orderdate - orderdate_lag = 1)
-- Answer: 2011-07-16, 2011-08-11, 2011-09-23





-- QUESTION 71

/*
AdventureWorks is implementing a third party software to track customer and product information. 
Each person in the database will be assigned a default username and password.

a. Create a username for each person by removing the "@adventure-works.com" on their email in 
	the EmailAddress table. For example, the CEO, Ken Sanchez's username will be "Ken0".  */
SELECT
	emailaddress,
	SUBSTRING(emailaddress, 0, LENGTH(emailaddress)-19) username,
	POSITION('@' IN emailaddress),
	SUBSTRING(emailaddress, 0, POSITION('@' IN emailaddress)) username_2,
	*
FROM person.person a
	LEFT JOIN person.emailaddress b ON a.businessentityid = b.businessentityid


-- b. Are there any duplicate usernames?
SELECT
	SUBSTRING(emailaddress, 0, LENGTH(emailaddress)-19) username,
	COUNT(*) username_count
FROM person.person a
	LEFT JOIN person.emailaddress b ON a.businessentityid = b.businessentityid
GROUP BY 1
ORDER BY 2 DESC
-- Answer: No


/* c. Take the results from Part A and join Person.Person. Then create a temporary password by concatenating the elements below:

	1. First 2 characters of First Name
	2. "."
	3. Last 2 characters of Last Name
	4. "."
	5. First 5 characters of NewID()
*/

SELECT
	emailaddress,
	SUBSTRING(emailaddress, 0, LENGTH(emailaddress)-19) username,
	CONCAT(SUBSTRING(firstname, 1, 2), '.', SUBSTRING(lastname, LENGTH(lastname)-1, LENGTH(lastname)), '.', SUBSTRING(SUBSTRING(emailaddress, 0, LENGTH(emailaddress)-19), 0, 6)) pword,
	CONCAT(LEFT(firstname, 2), '.', RIGHT(lastname, 2), '.', LEFT(SUBSTRING(emailaddress, 0, LENGTH(emailaddress)-19), 5)) pword_2,
	*
FROM person.person a
	LEFT JOIN person.emailaddress b ON a.businessentityid = b.businessentityid





-- QUESTION 72

/*
Below you will find the results from Question 71 part a:

	Select 
		BusinessEntityID
		,EmailAddress
		,CHARINDEX('@',EmailAddress) CharCNT
		,Left(EmailAddress,CHARINDEX('@',EmailAddress)-1) Username
	From Person.EmailAddress
	Order by 1 asc

a. Select this data into a table called "Person.Username" */

Select 
	BusinessEntityID
	,EmailAddress
	,POSITION('@' IN EmailAddress) CharCNT
	,SUBSTRING(emailaddress, 0, LENGTH(emailaddress)-19) username
INTO person.username
From Person.EmailAddress
Order by 1 asc;

SELECT *
FROM person.username


-- b. Select all from Person.Username and add a line of code that will return the length of the character string in the username.

SELECT 
	*,
	LENGTH(username) username_length
FROM person.username

/* c. For security purposes each username needs at least 5 characters. Therefore if a username only has 2 
		characters then add a "123" at the end. See Below:
		
		- 2 characters then add '123'
		- 3 characters then add '12'
		- 4 characters then add '1'

Then write an update statement that will add the characters to the usernames that need it.  */

SELECT 
	*,
	LENGTH(username) username_length,
	LEFT(CONCAT(username, '123'), 5) username_2
FROM person.username
	
UPDATE person.username
SET username = LEFT(CONCAT(username, '123'), 5);

SELECT *
FROM person.username;


-- d. Truncate the table. Know the difference between truncate and drop table.
TRUNCATE person.username;
SELECT * FROM person.username


-- e. Drop table. (Keep the AdventureWorks database original)

DROP TABLE person.username;






-- QUESTION 73

/*
The Senior leadership team would like to send each employee a card/gift for the holidays. Build a report with the following information:

	- Employee First and Last Name
	- Job Title
	- Country
	- State
	- City
	- Postal Code
	- AddressLine1
	- AddressLine2
*/

SELECT
	CONCAT(firstname, ' ', lastname) fullname,
	jobtitle,
	f.name country,
	e.name state,
	d.city,
	d.postalcode,
	d.addressline1,
	d.addressline2
FROM humanresources.employee a
	LEFT JOIN person.person b ON a.businessentityid = b.businessentityid
	LEFT JOIN person.businessentityaddress c ON a.businessentityid = c.businessentityid
	LEFT JOIN person.address d ON c.addressid = d.addressid
	LEFT JOIN person.stateprovince e ON d.stateprovinceid = e.stateprovinceid
	LEFT JOIN person.countryregion f ON e.countryregioncode = f.countryregioncode





-- QUESTION 74

-- What is the heaviest product that AdventureWorks sells?
SELECT
	weightunitmeasurecode,
	CASE
		WHEN weightunitmeasurecode='G' THEN (weight * 0.00220462)
		ELSE weight END AS weight_adj_lbs,
	weight,
	name,
	*
FROM production.product
WHERE weight IS NOT NULL
ORDER BY weight_adj_lbs desc
-- Answer: Touring-300 62 in Yellow & Blue





-- QUESTION 75

/*
a. Build a table that shows Product Inventory Quantity by Product Name. Insert into a Temp Table and 
	Include the following columns: (call the table #Temp1)
	
		- Product Name
		- SafetyStockLevel
		- Total Quantity
		- Reorder Point
		- Flag to indicate Inventory is below safety stock level
		- Flag to indicate Inventory is below reorder point
*/


DROP TABLE IF EXISTS Temp1;

WITH tempa AS (
	SELECT
		b.name product_name,
		safetystocklevel,
		SUM(a.quantity) quantity,
		reorderpoint
	FROM production.productinventory a
		LEFT JOIN production.product b ON a.productid = b.productid
	GROUP BY 1, 2, 4
)
SELECT
	*,
	CASE WHEN quantity < safetystocklevel THEN 1 ELSE 0 END safetystocklevel_flag,
	CASE WHEN quantity < reorderpoint THEN 1 ELSE 0 END reorderpoint_flag
INTO Temp1
FROM tempa;

SELECT * FROM Temp1


-- b. How many productIDs in Production.Product?
SELECT DISTINCT(COUNT(productid)) FROM production.product
-- Answer: 504

-- c. How many unique productIDs in inventory?
SELECT DISTINCT(COUNT(productid)) FROM production.productinventory
-- Answer: 1069

-- d. Write a query to show a count of products in the Product table but not in the inventory table.
SELECT
	DISTINCT(COUNT(a.productid))
FROM production.product a
	LEFT JOIN production.productinventory b ON a.productid = b.productid
WHERE b.productid IS NULL
-- Answer: 72

-- e. Use the Temp Table created in a, how many products below safety stock level?
SELECT SUM(safetystocklevel_flag)
FROM Temp1
-- Answer: 69

-- f. Use the Temp Table created in a, how many products below reorder point?
SELECT SUM(reorderpoint_flag)
FROM Temp1
-- Answer: 7





-- QUESTION 76

/*
Run this query:

    Select * From Sales.vPersonDemographics
    Where BusinessEntityID = '20392'

Then Run this query:

    Select * From Person.Person
    Where BusinessEntityID = '20392'
	
Click on the hyperlink in the Demographics column in Person.Person. Notice that the Demographics column is
used to create vPersonDemographics.

a. Select vPersonDemographics into a table and name the table Dup_PersonDemographics. Only insert
	rows/values that have a 'DateFirstPurchase'
*/

DROP TABLE IF EXISTS Dup_PersonDemographics;

SELECT *
INTO Dup_PersonDemographics
FROM Sales.vPersonDemographics
--WHERE datefirstpurchase IS NOT NULL
;

SELECT * FROM Dup_PersonDemographics


/*
b. Write an alter statement and add two columns to Dup_PersonDemographics. Column Names and datatypes:

- FullName: varchar(255)
- Age: int
*/
ALTER TABLE Dup_PersonDemographics
ADD COLUMN fullname VARCHAR(255),
ADD COLUMN age INT;

SELECT * FROM Dup_PersonDemographics


-- c. Update the FullName column to be the First and Last Name from Person.Person
UPDATE Dup_PersonDemographics
SET fullname = fullname_1
FROM (
	SELECT
		businessentityid,
		CONCAT(firstname, ' ', lastname) fullname_1
	FROM person.person
) a
WHERE a.businessentityid = Dup_PersonDemographics.businessentityid;

SELECT * FROM Dup_PersonDemographics


-- d. Update the age column to be the years between the persons birthday and August 15, 2014.

UPDATE Dup_PersonDemographics
SET age = age_yrs
FROM (
	SELECT 
		a.businessentityid,
		birthdate,
		ROUND(('2014-08-15'::date - birthdate)/365.25, 1) age_yrs
	FROM person.person a
		LEFT JOIN humanresources.employee b ON a.businessentityid = b.businessentityid
) AS d
WHERE d.businessentityid = Dup_PersonDemographics.businessentityid;

SELECT * FROM Dup_PersonDemographics





-- QUESTION 77

/*
In Question 76 we duplicated the PersonDemographics view and created a couple additional columns. 
Continue to use Dup_PersonDemographics in the following questions:

a. What are the distinct values in the MartialStatus column?  */

SELECT DISTINCT(maritalstatus) 
FROM Dup_PersonDemographics


-- b. Update the MartialStatus column to Single and Married. S = Single and M = Married. Be sure this works
--		and if it doesn't then figure out what might be going wrong.

ALTER TABLE Dup_PersonDemographics
ALTER COLUMN maritalstatus TYPE VARCHAR(50);


UPDATE Dup_PersonDemographics
SET maritalstatus = maritalstatus_2
FROM (
	SELECT
		businessentityid,
		CASE WHEN age IS NOT NULL THEN 'Single' ELSE 'Married' END AS maritalstatus_2
	FROM Dup_PersonDemographics
) a
WHERE a.businessentityid = Dup_PersonDemographics.businessentityid;

SELECT *
FROM Dup_PersonDemographics


-- c. Update the Gender column to Male and Female. M = Male and F = Female. Be sure this works and if it 
-- 		doesn't then figure out what might be going wrong.

ALTER TABLE Dup_PersonDemographics
ALTER COLUMN gender TYPE VARCHAR(50);


UPDATE Dup_PersonDemographics
SET gender = gender_2
FROM (
	SELECT
		businessentityid,
		CASE WHEN businessentityid > 100 THEN 'Male' ELSE 'Female' END AS gender_2
	FROM Dup_PersonDemographics
) a
WHERE a.businessentityid = Dup_PersonDemographics.businessentityid;

SELECT *
FROM Dup_PersonDemographics





-- QUESTION 78

/*
In Question 76 we duplicated the PersonDemographics view and created a couple additional columns.
Then in Question 77 we updated the Gender and MartialStatus Columns. Continue to use Dup_PersonDemographics
to answer the questions below:

a. What is the average age by YearlyIncome Group? Order by YearlyIncome. */
SELECT
	yearlyincome,
	AVG(age)
FROM Dup_PersonDemographics
GROUP BY 1
ORDER BY 1

-- b. Which combination of YearlyIncome, Education, and MaritalStatus has the highest average TotalPurchaseYTD
SELECT
	yearlyincome,
	education,
	maritalstatus,
	AVG(CAST(totalpurchaseytd AS numeric))
FROM Dup_PersonDemographics
GROUP BY 1, 2, 3
ORDER BY 4 DESC
LIMIT 1


-- c. Drop Dup_PersonDemographics
DROP TABLE Dup_PersonDemographics;






-- QUESTION 79

-- a. Based on ScrappedQty, what are the top five reasons material becomes scrap?

SELECT
	b.name reason,
	SUM(scrappedqty) scrapped_qty
FROM production.workorder a
	LEFT JOIN production.scrapreason b ON a.scrapreasonid = b.scrapreasonid
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- b. Which Product has the most Scrap?
SELECT
	a.productid,
	name product,
	SUM(scrappedqty) scrapped_qty
FROM production.product a
	LEFT JOIN production.workorder b ON a.productid = b.productid
GROUP BY 1, 2
HAVING SUM(scrappedqty) IS NOT NULL
ORDER BY 3 DESC
-- Answer: Fork End

-- c. Use the rollup function to show a grand total for the results in part b
SELECT
	name product,
	SUM(scrappedqty) scrapped_qty
FROM production.product a
	LEFT JOIN production.workorder b ON a.productid = b.productid
GROUP BY ROLLUP(1)
ORDER BY 2 DESC

/*
SELECT
	LEFT(CAST(customerid AS varchar), 1),
	LEFT(CAST(salesorderid AS varchar), 1),
	SUM(totaldue)
FROM sales.salesorderheader
GROUP BY CUBE(1, 2)

SELECT
	LEFT(CAST(customerid AS varchar), 1),
	LEFT(CAST(salesorderid AS varchar), 1),
	SUM(totaldue)
FROM sales.salesorderheader
GROUP BY ROLLUP(1, 2)

SELECT *
FROM sales.salesorderheader
*/






-- QUESTION 80

/*
Below you will see a script. The purpose of the script is to show a count of each Person Type 
(all six). However, the script has three errors. Two of the errors will not allow the script 
to successfully run. The other error is causing the script to show incorrect results.

Fix the script so that it runs and shows correct results. Try accomplishing without running the script.

Script:
	Select 
		Case When PersonType = 'IN' Then 'Individual Customer'
			 When PersonType = 'EM' Then 'Employee'
		 When PersonType = 'SP' Then 'Sales Person'
		 When PersonType = 'SC' Then 'Store Contact'
		 When PersonType = 'VC' Then 'Vendor Contact'
		 When PersonType = 'GC' Then 'General Contact'
		,Format(Count(*),'N0') as SPCNT
	From Person.Person P
		Inner Join HumanResources.Employee E 
		on P.BusinessEntityID = E.BusinessEntityID
		Left Join Sales.Customer C 
		on C.PersonID = P.BusinessEntityID
*/

Select 
	Case 
		When PersonType = 'IN' Then 'Individual Customer'
		When PersonType = 'EM' Then 'Employee'
		When PersonType = 'SP' Then 'Sales Person'
		When PersonType = 'SC' Then 'Store Contact'
		When PersonType = 'VC' Then 'Vendor Contact'
		When PersonType = 'GC' Then 'General Contact'
		ELSE NULL END person_type_2
	,Count(*) SPCNT
From Person.Person P
	LEFT Join HumanResources.Employee E on P.BusinessEntityID = E.BusinessEntityID
	Left Join Sales.Customer C on C.PersonID = P.BusinessEntityID
GROUP BY 1
ORDER BY 2 DESC






-- QUESTION 81

-- AdventureWorks does its best to ship product 7 days after the OrderDate. How many unique SalesOrderIDs
-- were shipped before or after 7 days?

SELECT
	shipdate - orderdate diff,
	COUNT(DISTINCT(salesorderid)) orders
FROM sales.salesorderheader
GROUP BY 1
ORDER BY 2 DESC
-- Answer: 9 orders were shipped 8 days later






-- QUESTION 82

-- a. Find the BusinessEntityID for the SalesPerson that has the highest SalesYTD.
SELECT
	businessentityid,
	CAST(salesytd AS money)
FROM sales.salesperson
ORDER BY 2 DESC
LIMIT 1
-- Answer: 276

-- b. Declare a local variable and put the BusinessEntityID from part a into the local variable.
--		Name the local variable @TopSalesPersonID. Make the datatype int

DECLARE @TopSalesPersonID INT;
SET @TopSalesPersonID = (
	SELECT
		businessentityid
	FROM sales.salesperson
	ORDER BY salesytd DESC
	LIMIT 1
);

-- c. Declare a second local variable called @CurrentYear. Insert the most recent orderdate year
--		into @CurrentYear. Data type int.

DECLARE @CurrentYear INT;
SET @CurrentYear = (
	SELECT
		MAX(EXTRACT(year FROM orderdate))
	FROM sales.salesorderheader
);



-- d. Use @TopSalesPersonID and @currentYear in a where clause and show top 10 products (SubTotal)
--		that this person has sold in the current year.
SELECT
	name,
	SUM(orderqty) quantity_sold,
	CAST(SUM(orderqty * (unitprice * (1-unitpricediscount))) AS money) sales_amount,
	CAST(SUM(subtotal) AS money) sales_amount_2 
FROM sales.salesorderheader a
	LEFT JOIN sales.salesorderdetail b ON a.salesorderid = b.salesorderid
	LEFT JOIN production.product c ON b.productid = c.productid
WHERE (salespersonid = 276) AND (EXTRACT(year FROM orderdate) = 2014)
GROUP BY 1
ORDER BY 4 DESC
LIMIT 10





-- QUESTION 83

/*
Building on question 82, Rather than pull the top ten products for the top SalesPerson...
pull the top ten products for the third best (SalesYTD) salesperson.
*/

SELECT
	name,
	SUM(orderqty) quantity_sold,
	CAST(SUM(orderqty * (unitprice * (1-unitpricediscount))) AS money) sales_amount,
	CAST(SUM(subtotal) AS money) sales_amount_2 
FROM sales.salesorderheader a
	LEFT JOIN sales.salesorderdetail b ON a.salesorderid = b.salesorderid
	LEFT JOIN production.product c ON b.productid = c.productid
WHERE (salespersonid = (SELECT
			businessentityid
		FROM sales.salesperson
		ORDER BY salesytd DESC
		LIMIT 1 
		OFFSET 2))
	AND (EXTRACT(year FROM orderdate) = 2014)
GROUP BY 1
ORDER BY 4 DESC
LIMIT 10






-- QUESTION 84

-- a. How many Unique credit card numbers does AdventureWorks have on file?
SELECT
	COUNT(DISTINCT(cardnumber))
FROM sales.creditcard
-- Answer: 19118

-- b. Show this count by Person.PersonType
SELECT
	persontype,
	TO_CHAR(COUNT(DISTINCT(cardnumber)), 'fm999G999') cc_count
FROM sales.creditcard a
	LEFT JOIN sales.personcreditcard b ON a.creditcardid = b.creditcardid
	LEFT JOIN person.person c ON b.businessentityid = c.businessentityid
GROUP BY 1
ORDER BY 2 DESC



-- c. Assume Today is September 30, 2005. How many of these cards are expired? How many are valid? 
--		The Credit Card doesn't expire until October 1, 2005. Show by PersonType
SELECT
	persontype,
	TO_CHAR(COUNT(DISTINCT(cardnumber)), 'fm999G999') total_cc_count,
	COUNT(DISTINCT(CASE
		WHEN ((expyear < 2005) OR ((expyear = 2005) AND (expmonth < 9))) THEN cardnumber ELSE null END)) AS expired_cards,
	COUNT(DISTINCT(CASE
		WHEN ((expyear > 2005) OR ((expyear = 2005) AND (expmonth >= 9))) THEN cardnumber ELSE null END)) AS active_cards	
FROM sales.creditcard a
	LEFT JOIN sales.personcreditcard b ON a.creditcardid = b.creditcardid
	LEFT JOIN person.person c ON b.businessentityid = c.businessentityid
GROUP BY 1
ORDER BY 2 DESC





-- QUESTION 85

/*
In question 84 we created a statement that gave us a count of credit card numbers by PersonType and 
Valid vs. Expired. We found out that 3,149 credit cards are expired. See Question 84 results below:

	Select 
		PersonType
		,Count(Case When Concat(ExpYear,Right(100+ExpMonth,2)) >= 200509
				  Then CardNumber Else Null End) as ValidCardCNT
		,Count(Case When Concat(ExpYear,Right(100+ExpMonth,2)) < 200509
			  Then CardNumber Else Null End) as ExpiredCardCNT
	From Sales.CreditCard cc
		Inner Join Sales.PersonCreditCard pcc on pcc.CreditCardID = cc.CreditCardID
		Inner Join Person.Person p on p.BusinessEntityID = pcc.BusinessEntityID
	Group by PersonType 

AdventureWorks would like to send an automated voicemail message and email message to each customer that
has an expiring credit card number. Again, still assuming that today is September 30, 2005 and Credit Card expire on
October 1, 2005. Write a query that includes the following columns for the 3,149 Credit Cards that are expired:

	- Full Name on card (include middle name, but not include the extra space if a middle name doesn't exist)
	- Person.PersonType
	- Store.Name (If the person is a "IN" PersonType then have the store name value say "Retail Customer")
	- The date of expiration (each card expires on the first day of the month. For Example, 
		if the date is August 2005  then format it as 2005-08-01)
	- Email Address
	- Phone Number
*/

SELECT
	CASE
		WHEN middlename IS NULL THEN CONCAT(firstname, ' ', lastname)
		ELSE CONCAT(firstname, ' ', middlename, ' ', lastname) END fullname,
	persontype,
	b.businessentityid,
	CASE
		WHEN persontype = 'IN' THEN 'Retail Customer'
		ELSE e.name END store_name,
	MAKE_DATE(expyear, expmonth, 1) expiration_date,
	emailaddress,
	phonenumber
FROM sales.creditcard a
	LEFT JOIN sales.personcreditcard b ON a.creditcardid = b.creditcardid
	LEFT JOIN person.person c ON b.businessentityid = c.businessentityid
	LEFT JOIN sales.customer d ON c.businessentityid = d.personid
	LEFT JOIN sales.store e ON d.storeid = e.businessentityid
	LEFT JOIN person.emailaddress f ON c.businessentityid = f.businessentityid
	LEFT JOIN person.personphone g ON c.businessentityid = g.businessentityid
WHERE ((expyear < 2005) OR ((expyear = 2005) AND (expmonth < 9)))







-- QUESTION 86

/*
Gary Altman, the facilities manager, would like to be sure that each janitor has a list
of every department, shift name, StartTime, and EndTime.

Accomplish this task by using one single join... more specifically, only use a cross join. 
Also, put the start and end times in this format HH:MM
*/

SELECT
	a.name department_name,
	b.name shift_name,
	TO_CHAR(starttime, 'HH24:MM') starttime,
	TO_CHAR(endtime, 'HH24:MM') endtime
FROM humanresources.department a
	CROSS JOIN humanresources.shift b
WHERE CONCAT(a.departmentid, b.shiftid) IN (SELECT CONCAT(departmentid, shiftid) FROM humanresources.employeedepartmenthistory)
ORDER BY 1, 2






-- QUESTION 87

-- Show each product and the number of times the product has had a List price change.

SELECT
	productid,
	COUNT(*)-1 count_of_list_price_changes
FROM production.productlistpricehistory
GROUP BY 1
ORDER BY 2 DESC;





-- QUESTION 88

/*
You just learned that a local shipping company, specifically a trucking company in Beverly Hills, California 
had a driver that was intentionally damaging shipments. It was speculated that the driver was doing this during 
March and April of 2014. Just to be sure your customers received their products the marketing department is 
going to send a letter informing customers that AdventureWorks will send them a new product if their product was damaged.

Build a report with the following:

	- SalesOrderNumber
	- Customer Name (First and Last)
	- Address1
	- Address2
	- Totaldue
*/

SELECT
	a.salesorderid,
	CONCAT(firstname, ' ', lastname),
	addressline1,
	addressline2,
	g.name shipmethod,
	SUM(totaldue) total_due
FROM sales.salesorderheader a
	LEFT JOIN sales.customer b ON a.customerid = b.customerid
	LEFT JOIN person.person c ON b.personid = c.businessentityid
	LEFT JOIN person.businessentityaddress d ON c.businessentityid = d.businessentityid
	LEFT JOIN person.address e ON d.addressid = e.addressid
	LEFT JOIN person.stateprovince f ON e.stateprovinceid = f.stateprovinceid
	LEFT JOIN purchasing.shipmethod g ON a.shipmethodid = g.shipmethodid
WHERE (shipdate >= '2014-03-01')
	AND (shipdate < '2014-05-01')
	AND (city = 'Beverly Hills')
	AND (f.name = 'California')
GROUP BY 1, 2, 3, 4, 5
ORDER BY 5 DESC





-- QUESTION 89

/*
Create a report that shows each Product with their Product Document File Name. Include products
that don't have file documentation. If a product doesn't have a file then label the value as "No file on Record."

a. Insert the following columns into a Common Table Expression (CTE) or Temporary Table:

	- Product Name
	- Document FileName
	- Document Status
	- Document Revisions
	- First and Last Name of Employee File Owner
	- Employee Job Title
*/


-- Using the CTE or Temp Table created above answer the following questions

DROP TABLE IF EXISTS Temp2;
SELECT
	a.name Product_Name,
	CASE WHEN c.filename IS NULL THEN 'No file on record.' ELSE c.filename END Document_FileName,
	c.status Document_Status,
	c.revision Document_Revisions,
	CONCAT(e.firstname, ' ', e.lastname) First_and_Last_Name_of_Employee_File_Owner,
	d.jobtitle Employee_Job_Title
INTO Temp2
FROM production.product a
	LEFT JOIN production.productdocument b ON a.productid = b.productid
	LEFT JOIN production.document c ON b.documentnode = c.documentnode
	LEFT JOIN humanresources.employee d ON c.owner = d.businessentityid
	LEFT JOIN person.person e ON d.businessentityid = e.businessentityid;


-- b. How many Products have a FileName?

SELECT 
COUNT(Product_Name)
FROM temp2
WHERE NOT (Document_FileName = 'No file on record.')
-- Answer: 32


-- c. Use a Having function to find the product(s) Name(s) with more than one FileName
SELECT
	Product_Name,
	COUNT(DISTINCT(Document_FileName)) count_of_filenames
FROM Temp2
GROUP BY 1
HAVING COUNT(DISTINCT(Document_FileName)) > 1
ORDER BY 2 DESC
-- Answer: only Reflector has more than 1 filename.


-- d. What is the average number of revisions by Owner/Employee? Display answer as a decimal
SELECT
	First_and_Last_Name_of_Employee_File_Owner,
	ROUND(AVG(document_revisions::numeric), 2) avg_revisions
FROM Temp2
WHERE document_revisions IS NOT NULL
GROUP BY 1






-- QUESTION 90

-- Recreate this table:

(SELECT
	b.groupname Department_GroupName,
	COUNT(DISTINCT(CASE WHEN c.name = 'Day' THEN a.businessentityid ELSE NULL END)) Day_Employee_CNT,
	COUNT(DISTINCT(CASE WHEN c.name = 'Evening' THEN a.businessentityid ELSE NULL END)) Evening_Employee_CNT,
	COUNT(DISTINCT(CASE WHEN c.name = 'Night' THEN a.businessentityid ELSE NULL END)) Night_Employee_CNT,
	COUNT(DISTINCT(a.businessentityid)) Total_Employee_CNT
FROM humanresources.employeedepartmenthistory a
	LEFT JOIN humanresources.department b ON a.departmentid = b.departmentid
	LEFT JOIN humanresources.shift c ON a.shiftid = c.shiftid
WHERE enddate IS NULL
GROUP BY 1
ORDER BY 1)

UNION ALL 

(SELECT
	'GRAND TOTAL' AS Department_GroupName,
	COUNT(DISTINCT(CASE WHEN c.name = 'Day' THEN a.businessentityid ELSE NULL END)) Day_Employee_CNT,
	COUNT(DISTINCT(CASE WHEN c.name = 'Evening' THEN a.businessentityid ELSE NULL END)) Evening_Employee_CNT,
	COUNT(DISTINCT(CASE WHEN c.name = 'Night' THEN a.businessentityid ELSE NULL END)) Night_Employee_CNT,
	COUNT(DISTINCT(a.businessentityid)) Total_Employee_CNT
FROM humanresources.employeedepartmenthistory a
	LEFT JOIN humanresources.department b ON a.departmentid = b.departmentid
	LEFT JOIN humanresources.shift c ON a.shiftid = c.shiftid
WHERE enddate IS NULL
GROUP BY 1)






-- QUESTION 91

/*
There are 290 employees that work for AdventureWorks. Leadership would like to ensure 
that wish their employees Happy Birthday on their actual Birthday.

a. Using a Cross Join (Do not use any other join for practice purposes), write a 
	statement that will give a list of all    290 employees FullName, Birthdate, and Age. */

SELECT
	CONCAT(firstname, ' ', lastname) fullname,
	birthdate,
	ROUND((current_date - birthdate)/365.25, 1) age_yrs
FROM humanresources.employee a
	CROSS JOIN person.person b
WHERE a.businessentityid = b.businessentityid


-- b. Add a where clause that will use CURRENT_DATE to limit employees that have a Birthday today.

SELECT
	CONCAT(firstname, ' ', lastname) fullname,
	birthdate,
	ROUND((CURRENT_DATE - birthdate)/365.25, 1) age_yrs
FROM humanresources.employee a
	CROSS JOIN person.person b
WHERE a.businessentityid = b.businessentityid
	AND EXTRACT(month FROM birthdate) = EXTRACT(month FROM CURRENT_DATE)
	AND EXTRACT(day FROM birthdate) = EXTRACT(day FROM CURRENT_DATE)





-- QUESTION 92 ***NOTE THIS WON'T WORK IN POSTGRES***

/*
Batching using a while loop is an effective way to improve performance when working with 
large datasets. Although in this question we will not be working with a large dataset we 
will be creating a while loop. We are going to create a table with two columns - 
SalesOrderHeader.Orderdate and TotalDue... In other words this will give you Daily Gross Revenue.
We are going to insert this data into a table in increments of 100. Below you will see
a Create Table and Insert Into Statement:

	Create Table Sales.DailyRevenue
		(OrderDate Date
		,TotalDue money)
	Insert Into Sales.DailyRevenue
		(OrderDate
		,TotalDue)
	Select 
		OrderDate
		,Sum(Totaldue) as TotalDue
	From Sales.SalesOrderHeader
	Group by OrderDate
	Order by 1 desc


a. This insert statement is inserting 1,124 rows of data into Sales.DailyRevenue. 
	Put this statement into a while loop and only insert 100 rows at a time. */

If Object_ID('Sales.DailyRevenue') is not null drop table Sales.DailyRevenue
 
Create Table Sales.DailyRevenue
	(OrderDate Date
	,TotalDue money)
 
Declare @BeginDate datetime
Declare @EndDate datetime
Declare @InsertDays int
Declare @LoopEndDate datetime
Set @BeginDate = (Select Min(OrderDate) From Sales.SalesOrderHeader)
Set @EndDate = (Select Max(OrderDate) From Sales.SalesOrderHeader)
Set @InsertDays = 100
Set @LoopEndDate = @BeginDate+@InsertDays
 
 
While @BeginDate < @EndDate
Begin 
 
	Insert Into Sales.DailyRevenue
		(OrderDate,TotalDue)
		Select 
			OrderDate
			,Sum(Totaldue) as TotalDue
		From Sales.SalesOrderHeader
		Where 
			OrderDate > = @BeginDate
			and OrderDate <@LoopEndDate
			and OrderDate <= @EndDate
		Group by OrderDate
		Order by 1 desc
	

-- b. Print a message in the while loop that will give an update on what OrderDates 
--     were inserted into the table. For Example, "Data Between May 2011 through September 2011 inserted"

	Print 'Data Between ' + DateName(month,@BeginDate) +' '+DateName(Year,@BeginDate) 
	      + ' through ' + DateName(month,@LoopEndDate) +' '+DateName(Year,@LoopEndDate) 
	      + ' inserted'
 
	Set @BeginDate = @LoopEndDate
	Set @LoopEndDate = (@LoopEndDate + @InsertDays)
	
	
	
	
	
-- QUESTION 93

/*
You've been asked to create a stored procedure that can be used for an online interface. 
This interface will allow customers to search for their Purchase History at AdventureWorks. 
When the customer inputs their phone number and account number into the online interface they 
will be able to see the products they purchased, the date it was ordered/purchased on, and the line total for each product.

a. Write a statement that includes the following elements:

	- Person FullName (First and Last Name)
	- Account Number
	- Phone Number
	- Order Date (SalesOrderHeader)
	- Product Name
	- Line Total
*/

SELECT 
	CONCAT(firstname, ' ', lastname) fullname,
	AccountNumber,
	phonenumber,
	c.orderdate,
	f.name productname,
	(e.unitprice * e.orderqty * (1-e.unitpricediscount)) linetotal,
	e.rowguid
FROM person.person a
	LEFT JOIN sales.customer b ON a.businessentityid = b.personid
	LEFT JOIN sales.salesorderheader c ON b.customerid = c.customerid
	LEFT JOIN person.personphone d ON a.businessentityid = d.businessentityid
	LEFT JOIN sales.salesorderdetail e ON c.salesorderid = e.salesorderid
	LEFT JOIN production.product f ON e.productid = f.productid
GROUP BY 1, 2, 3, 4, 5, 6, 7



/* b. Put this statement into a stored procedure. Add two parameters to the stored procedure - 
		Account Number and Phone Number. These parameters will require input variables in order to 
		return the correct information. */

CREATE OR REPLACE FUNCTION purchases(
	Account_Number varchar(15),
	phone_number varchar(25))
RETURNS TABLE (
	fullname text,
	AccountNumber varchar(15),
	phonenumber varchar(25),
	orderdate timestamp without time zone,
	productname varchar(50),
	linetotal numeric)
AS $func$
	SELECT 
		CONCAT(firstname, ' ', lastname) fullname,
		AccountNumber,
		phonenumber,
		c.orderdate,
		f.name productname,
		(e.unitprice * e.orderqty * (1-e.unitpricediscount)) linetotal
	FROM person.person a
		LEFT JOIN sales.customer b ON a.businessentityid = b.personid
		LEFT JOIN sales.salesorderheader c ON b.customerid = c.customerid
		LEFT JOIN person.personphone d ON a.businessentityid = d.businessentityid
		LEFT JOIN sales.salesorderdetail e ON c.salesorderid = e.salesorderid
		LEFT JOIN production.product f ON e.productid = f.productid
	WHERE AccountNumber = Account_Number
		AND phonenumber = phone_number;
$func$
LANGUAGE sql;



/* c. Exec the Stored Procedure for the following Account Numbers and Phone numbers.

	- Phone Number: 245-555-0173 Account Number '10-4020-000001'
	- Phone Number: 417-555-0131 Account Number '10-4030-021762'
	- Phone Number 620-555-0117 Account Number '10-4020-000695' */

SELECT * FROM purchases('10-4020-000001', '245-555-0173');
SELECT * FROM purchases('10-4030-021762', '417-555-0131');
SELECT * FROM purchases('10-4020-000695', '620-555-0117');
SELECT * FROM purchases('10-4020-000676', '967-555-0129');

-- d. Drop the Stored Procedure

DROP FUNCTION purchases;






-- QUESTION 94

-- There is one table-valued function in the AdventureWorks database - dbo.ufnGetContactInformation

-- a. Write a query that will show you each column in dbo.ufnGetContactInformation for Ken Sanchez, PersonID/ BusinessEntityID 1.

SELECT *
FROM dbo.ufnGetContactInformation(1)


-- b. Write a query that will give you each column in dbo.ufnGetContactInformation for every BusinessEntityID in Person.Person.
SELECT
	f.*
FROM person.person a
CROSS JOIN dbo.ufnGetContactInformation(a.businessentityid) b


-- c. Now write a query that will give you each column in dbo.ufnGetContactInformation for BusinessEntityID's 250,315,3780,6856,2457.
SELECT
	*
FROM person.person a
CROSS JOIN dbo.ufnGetContactInformation(a.businessentityid) b
WHERE a.personid IN (250,315,3780,6856,2457)


-- d. Find the BusinessEntityIDs/PersonIDs that exist in Person.Person but do not exist in ufnGetContactInformation


SELECT
	businessentityid
FROM person.person c
	LEFT JOIN (
	SELECT
		f.*
	FROM person.person a
	CROSS JOIN dbo.ufnGetContactInformation(a.businessentityid) b
) d ON c.businessentityid = d.businessentityid
WHERE d.businessentityid IS NULL






-- QUESTION 95

/*
a. Write a query with the following columns:

	- ProductID
	- Product Name
	- Order Date (PurchaseOrderHeader)
	- Purchase OrderID (PurchaseOrderHeader)
	- Qrder Qty (PurchaseOrderDetail)
	- Line Total (PurchaseOrderDetail)
*/

SELECT
	a.productid,
	a.name product_name,
	c.orderdate,
	c.purchaseorderid,
	b.orderqty,
	(b.unitprice * b.orderqty) linetotal
FROM production.product a
	RIGHT JOIN purchasing.purchaseorderdetail b ON a.productid = b.productid
	RIGHT JOIN purchasing.purchaseorderheader c ON b.purchaseorderid = c.purchaseorderid
	

/* b. Put the query above into a table-valued function with a parameter on PurchaseOrderHeader.VendorID,
		which is an int datatype. Call the Function ufnSalesByVendor. */

CREATE OR REPLACE FUNCTION ufnSalesByVendor(
	Vendor_ID INT)
RETURNS TABLE (
	productid int,
	product_name varchar(50),
	orderdate timestamp without time zone,
	purchaseorderid INT,
	orderqty INT,
	linetotal numeric)
AS $func$
	SELECT
		a.productid,
		a.name product_name,
		c.orderdate,
		c.purchaseorderid,
		b.orderqty,
		(b.unitprice * b.orderqty) linetotal
	FROM production.product a
		RIGHT JOIN purchasing.purchaseorderdetail b ON a.productid = b.productid
		RIGHT JOIN purchasing.purchaseorderheader c ON b.purchaseorderid = c.purchaseorderid
	WHERE c.vendorid = Vendor_ID;
$func$
LANGUAGE sql;


-- c. Select every column from vendorID 1604

SELECT *
FROM ufnSalesByVendor(1604);

/* d. Using a Cross Apply and Purchasing.Vendor select columns from the function (ufnSalesByVendor). 
		Notice that the number of rows will match the number of rows in part a. */

SELECT *
FROM purchasing.vendor a
	CROSS JOIN ufnSalesByVendor(a.businessentityid)

-- e. Drop the function

DROP FUNCTION ufnSalesByVendor






-- QUESTION 96

/*
If you run the query below you will find that 293 Products have undergone a price change.

    Select 
        Count(Distinct ProductID) CNT		
    From Production.ProductListPriceHistory


In this question we are going to determine how many of these 293 products have undergone 
more than one price change. We are going to figure this out using 3 different methods.

	*Note: Results for a,b,c will all be the same.

a. Using an Inner Query determine how many products in ProductListPriceHistory have experienced more than one price change. */
SELECT
	COUNT(DISTINCT(a.productid))
FROM production.ProductListPriceHistory a
	RIGHT JOIN (
		SELECT productid, COUNT(*) price_changes
		FROM production.ProductListPriceHistory 
		GROUP BY 1
		HAVING COUNT(*) > 1) b ON a.productid = b.productid
-- Answer: 77

-- b. Using a CTE determine how many products in ProductListPriceHistory have experienced more than one price change.
WITH temp1 AS (
	SELECT 
		productid, 
		COUNT(*) price_changes
	FROM production.ProductListPriceHistory 
	GROUP BY 1
	HAVING COUNT(*) > 1
)
SELECT
	COUNT(DISTINCT(a.productid))
FROM production.ProductListPriceHistory a
	RIGHT JOIN temp1 ON a.productid = temp1.productid
-- Answer: 77

/* c. Using a Self Join (Without using a CTE or Inner Query) determine how many products in ProductListPriceHistory  
		have experienced more than one price change. */

SELECT
	COUNT(DISTINCT(b.productid))
FROM production.ProductListPriceHistory a
	LEFT JOIN production.productlistpricehistory b ON ((a.productid = b.productid) AND NOT(a.listprice = b.listprice))





-- QUESTION 97

/*
In this question we are going to practice the impact that an index makes on a table, especially a large table.
Indexes improve performance by organizing the table. Every table in the AdventureWorks database already has an 
index, because every table has a primary key. An index is created on primary keys. However, majority of tables
have indexes on secondary and tertiary columns. In order to answer this question we are going to create a new table.
And this table doesn't have any meaning or isn't useful... we just want a table with millions of rows. With that said,
run this query:

	Drop Table If Exists TestTable;
	
	Select 
		Person.*
		,NationalIDNumber
		,JobTitle
		,BirthDate
		,MaritalStatus
		,Gender
		,HireDate
		,VacationHours
		,SickLeaveHours
	Into TestTable
	From HumanResources.Employee
	Cross Join Person.Person;


a. Now we have a table with over 5 million rows. Write a query that will select everything from 
	TestTable with the BusinessEntityID 289. Take note of how long the query takes to complete. */

SELECT *
FROM testtable
WHERE businessentityid = 289;
   

-- b. Create an Index on BusinessEntityID. Call the index - idx_TestTable_BusinessEntityID

CREATE INDEX idx_TestTable_BusinessEntityID ON testtable (businessentityid);

-- c. Now run the same statement as part a. Again, take note of how long the query take to complete.

SELECT *
FROM testtable
WHERE businessentityid = 289;

-- d. Drop the TestTable

DROP TABLE testtable;





-- QUESTION 98

/*
You will notice that the Sales.SalesOrderDetail table has three indexes:

	- AK_SalesOrderDetail_rowguid
	- IX_SalesOrderDetail_ProductID
	- PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID

a. Drop the first index - AK_SalesOrderDetail_rowguid */

SELECT *
FROM sales.salesorderdetail

DROP INDEX AK_SalesOrderDetail_rowguid FROM sales.salesorderdetail

-- b. Drop the second index - IX_SalesOrderDetail_ProductID

DROP INDEX IX_SalesOrderDetail_ProductID


-- c. Drop the third index - PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID

DROP INDEX PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID;


/* d. Recreate the first index - AK_SalesOrderDetail_rowguid. Here are the details:

	- On the rowguid column
	- Unique
	- Non-Clustered */

CREATE UNIQUE INDEX AK_SalesOrderDetail_rowguid ON sales.salesorderdetail(rowguid);

/* e. Recreate the second index - IX_SalesOrderDetail_ProductID. Here are the details:

	- On the ProductID column
	- Non-Unique
	- Non-Clustered */

CREATE INDEX IX_SalesOrderDetail_ProductID ON sales.salesorderdetail(productid);


/* f. Recreate the third index - PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID. Here are the details:  

	- On the SalesOrderID and SalesOrderDetailID columns
	- Clustered */
	
CREATE INDEX PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID ON sales.salesorderdetail(salesorderid, salesorderdetailid);

SELECT *
FROM sales.salesorderdetail





-- QUESTION 99

/*
a. There are three main type of table triggers in the AdventureWorks database - Delete,
	Insert, and Update. Meaning a trigger will fire when a valid event (Delete, Insert, Update) occurs.
	Write a script that will show you every table trigger in the database. Include the Following Columns:

	- TriggerName (ObjectName)
	- SchemaName
	- TableName
	- TriggerType (Delete, Insert, Update) */

SELECT
	trigger_name,
	trigger_schema,
	event_object_table,
	*
FROM information_schema.triggers


/* b. You will notice that there is a delete error on the Employee table. This means that an 
	employee cannot be deleted from the table. Try to delete John Wood from the Employee table (BusinessEntityID - 18). */

DELETE FROM humanresources.employee
WHERE businessentityid = 18;

-- c. Now Delete BusinessEntityID 18 from the EmployeeDepartmentHistory table.

DELETE FROM humanresources.EmployeeDepartmentHistory
WHERE businessentityid = 18;

/* d. Notice that the EmployeeDepartmentHistory table does not have a delete Trigger, which means you were
		able to delete the record/row. Write an Insert Into statement to put BusinessEntityID back into the 
		EmployeeDepartmentHistory table. Here is the information you need to do so:
		
			- BusinessEntityID = '18'
			- DepartmentID = '4'
			- ShiftID = '1'
			- StartDate = '2011-02-07'
			- EndDate = NULL
			- ModifiedDate = '2011-02-06 00:00:00.000' */

INSERT INTO humanresources.employeedepartmenthistory(businessentityid, DepartmentID, ShiftID, StartDate, EndDate, ModifiedDate)
VALUES (18, 4, 1, '2011-02-07', NULL, '2011-02-06 00:00:00.000')


/* e. Create a trigger on EmployeeDepartmentHistory that will prevent records from being deleted. Name 
	the trigger "dEmployeeDepartmentHistory." And have the Error print a message that reads 'You Cannot 
	Delete Employee From EmployeeDepartmentHistory'. */

CREATE TRIGGER humanresources.demployeedepartmenthistory
	ON humanresources.employeedepartmenthistory
	FOR DELETE
	AS
	BEGIN
		PRINT 'You cannot delete employee from employeedepartmenthistory'
		ROLLBACK TRANSACTION
	END

-- f. Now try to drop BusinessEntityID 18. Also, run the query in part a to look at the trigger that was just created.
DELETE FROM humanresources.EmployeeDepartmentHistory
WHERE businessentityid = 18;


-- g. Drop the dEmployeeDepartmentHistory trigger

DROP TRIGGER humanresources.demployeedepartmenthistory;






-- QUESTION 100


-- a. Find the insert trigger on Production.WorkOrder. What is the  name of this trigger?

SELECT
	trigger_name,
	trigger_schema,
	event_object_table,
	*
FROM information_schema.triggers
-- Answer: Production.iWorkOrder

-- b. What is this trigger doing?
-- Answer: Inserting Values into Production.TransactionHistory


/* c. Run the insert statement below:

	INSERT INTO Production.WorkOrder
           (ProductID,OrderQty,ScrappedQty
           ,StartDate,EndDate,DueDate
           ,ScrapReasonID,ModifiedDate)
		VALUES
           (680,1,0,'2014-06-03'
           ,'2014-06-13','2014-06-14'
           ,Null,'2014-06-15') 
		   
 d. We have now inserted a row of data into the WorkOrder table, which also fired/triggered 
	the trigger on Production.WorkOrder. Based on the trigger defintion the newly insert data was 
	also inserted into another table. Find the data that was insert into the other table. */

SELECT
	*
FROM Production.TransactionHistory
ORDER BY 1 DESC

-- e. Delete the rows of data insert into both tables.

SELECT *
FROM Production.WorkOrder
WHERE StartDate = '2014-06-03 00:00:00.000';

DELETE FROM Production.WorkOrder
WHERE StartDate = '2014-06-03 00:00:00.000';

SELECT * 
FROM Production.TransactionHistory	
WHERE CONVERT(char(8),TransactionDate,112) = CONVERT(char(8),GETDATE(),112);

DELETE FROM Production.TransactionHistory	
WHERE CONVERT(char(8),TransactionDate,112) = CONVERT(char(8),GETDATE(),112);

-- **If you accidently delete more rows then necessary then drop the AdventureWorks database and restore it again.





-- QUESTION 101

/*
a. Run this statement:

    Select * 
    From HumanResources.Employee 
    Where CurrentFlag = False
	
You will notice that every employee in the database is considered a current employee.
We are going to create a Trigger that will update a departure date when the employee 
current flag is updated to "1". */


-- b. Write a statement that will add a column to the HumanResources.Employee table. 
--		Call the column "DepartureDate." Make it a date datatype.

ALTER TABLE HumanResources.Employee
ADD COLUMN DepartureDate date CONSTRAINT;

-- c. Create a Trigger called HumanResources.uEmployee on the HumanResources.Employee table.
-- 		Have the trigger set the DepartureDate = GetDate() when the current flag is updated to "0".
CREATE TRIGGER HumanResources.uEmployee
ON HumanResources.Employee
AFTER UPDATE AS
BEGIN
	SET NoCount ON
		UPDATE humanresources.employee
		SET departuredate = GetDate()
		FROM humanresources.employee
			INNER JOIN inserted ON inserted.businessentityid = employee.businessentityid AND inserted.currentflag = False
		
		UPDATE humanresources.employee
		SET departuredate = NULL
		FROM humanresources.employee
			INNER JOIN inserted ON inserted.businessentityid = employee.businessentityid AND inserted.currentflag = True
END


-- d. Now set the current flag = 0 for BusinessEntityID 2. And check the DepartureDate in HumanResources.Employee
UPDATE humanresources.employee
SET currentflag = True
WHERE businessentityid = 2

-- e. Write a statement that will drop the trigger if it exists.
DROP TRIGGER IF EXISTS humanresources.uEmployee


-- f. Add another step in the trigger that will set the DepartureDate to NULL if the current 
--		flag is updated back to "1"

UPDATE humanresources.employee
SET currentflag = 1
WHERE businessentityid = 2

-- g. Drop the trigger

DROP TRIGGER humanresources.uemployee


-- h. Delete the DepartureDate column

ALTER TABLE humanresources.employee
DROP COLUMN departuredate


































































