-------------- TOP 20% of customers based on max income ------------
WITH cust_income(customerid, tot, ord) AS (
SELECT customerid, SUM(total_price) as tot, CUME_DIST() OVER(ORDER BY SUM(total_price) DESC) *100 AS ord
	FROM online_retail
	GROUP BY customerid
)

SELECT customerid, tot, ord
FROM cust_income 
WHERE ord < 20;
	 
------------------------------- Last time the customer made a purchase to his total orders in dates-------------------
SELECT customerid, invoiceno,CAST(invoicedate as date), FIRST_VALUE(CAST(invoicedate as date)) OVER(PARTITION BY customerid ORDER BY CAST(invoicedate as date)  DESC)
FROM online_retail
GROUP BY customerid, invoiceno, invoicedate;


------------------------------- Max item as quantity for each customer -------------------------------
SELECT customerid, country, stockcode, description, COUNT(quantity), 
DENSE_RANK() OVER(PARTITION BY customerid ORDER BY COUNT(quantity) DESC)
FROM online_retail
GROUP BY customerid, country, stockcode, description;

------------------------------ Most selling item for each customer -----------------
SELECT customerid, stockcode, description, COUNT(stockcode), DENSE_RANK() OVER(PARTITION BY customerid ORDER BY COUNT(stockcode) DESC) 
FROM online_retail
GROUP BY customerid, stockcode, description;

------------------------------ Most selling 5 items in each country -------------------------

WITH most_prod(country, stockcode, description, coun, most_selling) AS (
SELECT country, stockcode, description, COUNT(stockcode) AS coun, 
DENSE_RANK() OVER(PARTITION BY country ORDER BY COUNT(stockcode) DESC) AS most_selling
FROM online_retail
GROUP BY country, stockcode, description
)

SELECT country, stockcode, description, coun, most_selling
FROM most_prod
WHERE most_selling <=5;

-------------------------- most profitable 5 items in each country -----------------------

WITH max_profit( country, stockcode, description, total, mx) AS (
SELECT country, stockcode, description, SUM(total_price) AS total,
DENSE_RANK() OVER(PARTITION BY country ORDER BY SUM(total_price) DESC) AS mx
FROM online_retail
GROUP BY country, stockcode, description)

SELECT country, stockcode, description, total, mx
FROM max_profit
WHERE mx <= 5;
