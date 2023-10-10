# Orders Table Cleaning 

# select * from orders;
update orders set comments  = coalesce(comments,"No Comments");  # replaced null comments into No Comments.
select * from orders;



# Creating Separate Table for OrderStatus Using Group By
CREATE TABLE orderStatus as 
SELECT status, COUNT(status),YEAR(orderDate) as orderYear
from orders
GROUP BY status , orderYear;
select * from orderStatus;

# Find total count of Orders
select count(orderNumber) from orders;

# office table cleaning 
SELECT * FROM classicmodels.offices;
select distinct territory from offices;
update offices set state=coalesce(state,"Not Available");


DELIMITER //
CREATE PROCEDURE get_top_n_products 
						(in_year int,
						in_top_n int)
BEGIN 
	SELECT 
		p.productname,
		SUM(s.sales) as total_sales_
	FROM total_sales s 
	JOIN products p 
	ON s.productcode=p.productcode
	where s.year=in_year
	GROUP BY p.productname 
	ORDER BY total_sales_ DESC
	LIMIT in_top_n;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_top_n_customers_by_sales (in_year INT,
                    in_top_n INT)
BEGIN
	SELECT 
		c.customerName,
		ROUND(SUM(s.sales)/1000000,2) AS total_sales_mln
	FROM total_sales s 
	JOIN orders o
	ON s.ordernumber=o.ordernumber
	JOIN customers c 
	ON c.customernumber=o.customernumber
	WHERE s.year=in_year
	GROUP BY c.customerName
	ORDER BY total_sales_mln DESC
	LIMIT in_top_n;

END //
DELIMITER ;
SELECT concat("$",FORMAT(sum(sales)/1000000,2)," Million") as total_sales 
FROM total_sales;

