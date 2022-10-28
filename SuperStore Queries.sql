# Look at our three divided data sets

SELECT *
FROM customers
LIMIT 5;

SELECT *
FROM orders
LIMIT 5;

SELECT *
FROM products
LIMIT 5;

# Determine the distinct number of orders

SELECT
	COUNT(DISTINCT Order_ID) as Orders
FROM orders;

# Determine the number of items purchased per order

SELECT
    Order_ID,
    COUNT(*) as Items_Purchased
FROM orders
GROUP BY Order_ID;

# Total Sales per order

SELECT
    DISTINCT Order_ID,
    SUM(Sales_in_USD) OVER(PARTITION BY Order_ID) AS Sales
FROM orders;

# Combine the previous two togeter... Show the order, the total sales, and items ordered
# Getting the sales as only 2 decimal places

SELECT
    DISTINCT Order_ID,
    COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
    ROUND(SUM(Sales_in_USD) OVER(PARTITION BY Order_ID), 2) AS Sales
FROM orders;

# Let's add some other key info for the orders

SELECT
    DISTINCT Order_ID,
    Order_Date,
    COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
    ROUND(SUM(Sales_in_USD) OVER(PARTITION BY Order_ID), 2) AS Sales,
    Region,
    Customer_ID
FROM orders
ORDER BY Order_Date;

# Sales per month

SELECT
    DISTINCT Order_ID,
    MONTH(Order_Date) AS Order_Month,
    COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
    ROUND(SUM(Sales_in_USD) OVER(PARTITION BY Order_ID), 2) AS Sales,
    Region
FROM orders;

WITH OrderInfo AS(
SELECT
    DISTINCT Order_ID,
    MONTH(Order_Date) AS Order_Month,
    COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
    ROUND(SUM(Sales_in_USD) OVER(PARTITION BY Order_ID), 2) AS Sales,
    Region
FROM orders)
SELECT 
	Order_Month,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM OrderInfo
GROUP BY Order_Month
ORDER BY Order_Month;

# To have it display month names, need to adjust CTE so that table has month numbers, then order by that

WITH OrderInfo AS(
SELECT
    DISTINCT Order_ID,
    MONTHNAME(Order_Date) AS Order_Month,
    MONTH(Order_Date) AS Month_Num,
    COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
    ROUND(SUM(Sales_in_USD) OVER(PARTITION BY Order_ID), 2) AS Sales,
    Region
FROM orders)
SELECT 
	Order_Month,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM OrderInfo
GROUP BY Order_Month, Month_Num
ORDER BY Month_Num;
    
#Show number of orders per month

WITH OrderInfo AS(
SELECT
    DISTINCT Order_ID,
    MONTHNAME(Order_Date) AS Order_Month,
    MONTH(Order_Date) AS Month_Num,
    COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
    ROUND(SUM(Sales_in_USD) OVER(PARTITION BY Order_ID), 2) AS Sales,
    Region
FROM orders)
SELECT 
	Order_Month,
    COUNT(Order_ID)
FROM OrderInfo
GROUP BY Order_Month, Month_Num
ORDER BY Month_Num;

# Sales per year

SELECT
    DISTINCT Order_ID,
    YEAR (Order_Date) AS Order_Year,
    COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
    ROUND(SUM(Sales_in_USD) OVER(PARTITION BY Order_ID), 2) AS Sales
FROM orders;

WITH OrderInfo AS(
SELECT
    DISTINCT Order_ID,
    YEAR (Order_Date) AS Order_Year,
    COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
    ROUND(SUM(Sales_in_USD) OVER(PARTITION BY Order_ID), 2) AS Sales
FROM orders)
SELECT
	Order_Year,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM OrderInfo
GROUP BY Order_Year
ORDER BY Order_Year;

# Sales per year ordered by sales
#Shows that there was a dip in 2016, but then sales went up the next two years

WITH OrderInfo AS(
SELECT
    DISTINCT Order_ID,
    YEAR (Order_Date) AS Order_Year,
    COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
    ROUND(SUM(Sales_in_USD) OVER(PARTITION BY Order_ID), 2) AS Sales,
    Region
FROM orders)
SELECT
	Order_Year,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM OrderInfo
GROUP BY Order_Year
ORDER BY ROUND(SUM(Sales), 2);


# Show the Number of Orders per year

WITH OrderInfo AS(
SELECT
    DISTINCT Order_ID,
    YEAR (Order_Date) AS Order_Year,
    COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
    ROUND(SUM(Sales_in_USD) OVER(PARTITION BY Order_ID), 2) AS Sales,
    Region
FROM orders)
SELECT
	Order_Year,
    COUNT(Order_ID)
FROM OrderInfo
GROUP BY Order_Year
ORDER BY Order_Year;

# Show the number of orders per year and month

SELECT
    DISTINCT Order_ID,
    MONTH(Order_Date) AS Order_Month,
    YEAR(Order_Date) AS Order_Year,
    COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
    ROUND(SUM(Sales_in_USD) OVER(PARTITION BY Order_ID), 2) AS Sales
FROM orders;

WITH OrderInfo AS(
SELECT
    DISTINCT Order_ID,
    MONTH(Order_Date) AS Order_Month,
    YEAR(Order_Date) AS Order_Year,
    COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
    ROUND(SUM(Sales_in_USD) OVER(PARTITION BY Order_ID), 2) AS Sales
FROM orders)
SELECT
	CONCAT(Order_Year,"-", Order_Month) AS Order_Date,
    COUNT(Order_ID)
FROM OrderInfo
GROUP BY CONCAT(Order_Year,"-", Order_Month)
ORDER BY CONCAT(Order_Year,"-", Order_Month);

# Show the number of orders for each individual month, and put in order of month

WITH OrderInfo AS(
SELECT
    DISTINCT Order_ID,
    MONTH(Order_Date) AS Order_Month,
    YEAR(Order_Date) AS Order_Year,
    COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
    ROUND(SUM(Sales_in_USD) OVER(PARTITION BY Order_ID), 2) AS Sales
FROM orders)
SELECT
	CONCAT(Order_Year,"-", LPAD(Order_Month, 2, 0)) AS Order_Date,
    COUNT(Order_ID)
FROM OrderInfo
GROUP BY CONCAT(Order_Year,"-", LPAD(Order_Month, 2, 0))
ORDER BY CONCAT(Order_Year,"-", LPAD(Order_Month, 2, 0));


# See which region has the most orders per year

SELECT
    DISTINCT Order_ID,
    LPAD(MONTH(Order_Date), 2, 0) AS Order_Month,
    YEAR(Order_Date) AS Order_Year,
    COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
    ROUND(SUM(Sales_in_USD) OVER(PARTITION BY Order_ID), 2) AS Sales, 
    Region,
    Customer_ID
FROM orders;

WITH OrderInfo AS(
SELECT
    DISTINCT Order_ID,
    LPAD(MONTH(Order_Date), 2, 0) AS Order_Month,
    YEAR(Order_Date) AS Order_Year,
    COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
    ROUND(SUM(Sales_in_USD) OVER(PARTITION BY Order_ID), 2) AS Sales, 
    Region,
    Customer_ID
FROM orders)
SELECT
	Order_Year,
    Region, 
    COUNT(Order_ID) AS Orders
FROM OrderInfo
GROUP BY Region, Order_Year
ORDER BY Order_Year, Orders DESC;

# See which region has the most Sales per year

WITH OrderInfo AS(
SELECT
    DISTINCT Order_ID,
    LPAD(MONTH(Order_Date), 2, 0) AS Order_Month,
    YEAR(Order_Date) AS Order_Year,
    COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
    ROUND(SUM(Sales_in_USD) OVER(PARTITION BY Order_ID), 2) AS Sales, 
    Region,
    Customer_ID
FROM orders)
SELECT
	Order_Year,
    Region, 
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM OrderInfo
GROUP BY Region, Order_Year
ORDER BY Order_Year, ROUND(SUM(Sales), 2) DESC;

# Can just show the total sales and orders together

WITH OrderInfo AS(
SELECT
    DISTINCT Order_ID,
    LPAD(MONTH(Order_Date), 2, 0) AS Order_Month,
    YEAR(Order_Date) AS Order_Year,
    COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
    ROUND(SUM(Sales_in_USD) OVER(PARTITION BY Order_ID), 2) AS Sales, 
    Region,
    Customer_ID
FROM orders)
SELECT
	Order_Year,
    Region, 
    COUNT(Order_ID) AS Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM OrderInfo
GROUP BY Region, Order_Year
ORDER BY Order_Year, ROUND(SUM(Sales), 2) DESC;

# Examine Customer Information

SELECT
	DISTINCT orders.Order_ID,
    CONCAT(customers.Last_Name, ", ", customers.First_Name) AS Customer,
	LPAD(MONTH(orders.Order_Date), 2, 0) AS Order_Month,
	YEAR(orders.Order_Date) AS Order_Year,
	COUNT(orders.Order_ID) OVER(PARTITION BY Order_ID) AS Items,
	ROUND(SUM(orders.Sales_in_USD) OVER(PARTITION BY Order_ID), 2) AS Sales
FROM customers
JOIN orders ON orders.Customer_ID = customers.Customer_ID;

#See the number of purchases for each customer, and total sales per customer
#Can order by Total Sales or by total purchases(below is total sales)

WITH CustomerOrders AS (
SELECT
	DISTINCT orders.Order_ID,
    CONCAT(customers.Last_Name, ", ", customers.First_Name) AS Customer,
	LPAD(MONTH(orders.Order_Date), 2, 0) AS Order_Month,
	YEAR(orders.Order_Date) AS Order_Year,
	COUNT(orders.Order_ID) OVER(PARTITION BY Order_ID) AS Items,
	ROUND(SUM(orders.Sales_in_USD) OVER(PARTITION BY Order_ID), 2) AS Sales
FROM customers
JOIN orders ON orders.Customer_ID = customers.Customer_ID)
SELECT
	DISTINCT Customer,
    COUNT(Order_ID) AS Purchases,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM CustomerOrders
GROUP BY Customer
ORDER BY ROUND(SUM(Sales), 2) DESC;

#Ranking most valuable customer as customer based on most purchases

WITH CustomerOrders AS (
SELECT
	DISTINCT orders.Order_ID,
    CONCAT(customers.Last_Name, ", ", customers.First_Name) AS Customer,
	LPAD(MONTH(orders.Order_Date), 2, 0) AS Order_Month,
	YEAR(orders.Order_Date) AS Order_Year,
	COUNT(orders.Order_ID) OVER(PARTITION BY Order_ID) AS Items,
	ROUND(SUM(orders.Sales_in_USD) OVER(PARTITION BY Order_ID), 2) AS Sales
FROM customers
JOIN orders ON orders.Customer_ID = customers.Customer_ID
)
SELECT
	DISTINCT Customer,
    COUNT(Order_ID) AS Purchases, 
    Order_Year,
    DENSE_RANK() OVER (
		PARTITION BY Order_Year 
        ORDER BY COUNT(Order_ID) DESC
        ) AS Consumer_Num
FROM CustomerOrders
GROUP BY Customer, Order_Year;

#Use a CTE WITHIN A CTE to limit return to top 3 per year: 

WITH CustomerRankings AS(
WITH CustomerOrders AS (
SELECT
	DISTINCT orders.Order_ID,
    CONCAT(customers.Last_Name, ", ", customers.First_Name) AS Customer,
	LPAD(MONTH(orders.Order_Date), 2, 0) AS Order_Month,
	YEAR(orders.Order_Date) AS Order_Year,
	COUNT(orders.Order_ID) OVER(PARTITION BY Order_ID) AS Items,
	ROUND(SUM(orders.Sales_in_USD) OVER(PARTITION BY Order_ID), 2) AS Sales
FROM customers
JOIN orders ON orders.Customer_ID = customers.Customer_ID
)
SELECT
	DISTINCT Customer,
    COUNT(Order_ID) AS Purchases, 
    Order_Year,
    DENSE_RANK() OVER (
		PARTITION BY Order_Year 
        ORDER BY COUNT(Order_ID) DESC
        ) AS Consumer_Num
FROM CustomerOrders
GROUP BY Customer, Order_Year
)
SELECT *
FROM CustomerRankings
WHERE Consumer_Num <=3;

#Get Top 3 all time: 

WITH CustomerRankings AS(
WITH CustomerOrders AS (
SELECT
	DISTINCT orders.Order_ID,
    CONCAT(customers.Last_Name, ", ", customers.First_Name) AS Customer,
	LPAD(MONTH(orders.Order_Date), 2, 0) AS Order_Month,
	YEAR(orders.Order_Date) AS Order_Year,
	COUNT(orders.Order_ID) OVER(PARTITION BY Order_ID) AS Items,
	ROUND(SUM(orders.Sales_in_USD) OVER(PARTITION BY Order_ID), 2) AS Sales
FROM customers
JOIN orders ON orders.Customer_ID = customers.Customer_ID
)
SELECT
	DISTINCT Customer,
    COUNT(Order_ID) AS Purchases, 
    Order_Year,
    DENSE_RANK() OVER (
		ORDER BY COUNT(Order_ID) DESC
        ) AS Consumer_Num
FROM CustomerOrders
GROUP BY Customer, Order_Year
)
SELECT *
FROM CustomerRankings
WHERE Consumer_Num <=3;

# Examine Product Information: 

#Show each product, how many times it was purchased, and the average sales for that item

SELECT
	DISTINCT orders.Product_ID,
    products.Product_Name,
    products.Category,
    products.SubCategory,
    COUNT(orders.ORDER_ID) AS Times_Purchased,
    ROUND(AVG(orders.Sales_in_USD), 2) AS Avg_Sales_USD
FROM orders
JOIN products ON orders.Product_ID = products.Product_ID
GROUP BY 
	orders.Product_ID, products.Product_Name, products.Category, products.SubCategory
ORDER BY ROUND(AVG(orders.Sales_in_USD), 2) DESC;

# Can use the previous query to count the number of items sold in each category and some aggregations

WITH ProductInfo AS(
SELECT
	DISTINCT orders.Product_ID,
    products.Product_Name,
    products.Category,
    products.SubCategory,
    COUNT(orders.ORDER_ID) AS Times_Purchased,
    ROUND(AVG(orders.Sales_in_USD), 2) AS Avg_Sales_USD
FROM orders
JOIN products ON orders.Product_ID = products.Product_ID
GROUP BY 
	orders.Product_ID, products.Product_Name, products.Category, products.SubCategory
ORDER BY ROUND(AVG(orders.Sales_in_USD), 2) DESC)
SELECT
	Category,
    COUNT(Category) AS Purchased,
    ROUND(AVG(Avg_Sales_USD), 2) AS Avg_Value,
    ROUND(MIN(Avg_Sales_USD), 2) AS Min_Value, 
    ROUND(MAX(Avg_Sales_USD), 2) AS Max_Value
FROM ProductInfo
GROUP BY Category
ORDER BY Purchased DESC;

#Can divide further into subcategories:

WITH ProductInfo AS(
SELECT
	DISTINCT orders.Product_ID,
    products.Product_Name,
    products.Category,
    products.SubCategory,
    COUNT(orders.ORDER_ID) AS Times_Purchased,
    ROUND(AVG(orders.Sales_in_USD), 2) AS Avg_Sales_USD
FROM orders
JOIN products ON orders.Product_ID = products.Product_ID
GROUP BY 
	orders.Product_ID, products.Product_Name, products.Category, products.SubCategory
ORDER BY ROUND(AVG(orders.Sales_in_USD), 2) DESC)
SELECT
	SubCategory,
    Category,
    COUNT(SubCategory) AS Purchased,
    ROUND(AVG(Avg_Sales_USD), 2) AS Avg_Value,
    ROUND(MIN(Avg_Sales_USD), 2) AS Min_Value, 
    ROUND(MAX(Avg_Sales_USD), 2) AS Max_Value
FROM ProductInfo
GROUP BY SubCategory, Category
ORDER BY Purchased DESC;

#Curious to see if the time of year impacts when items are purchased

SELECT
	orders.Order_ID,
    products.Product_Name,
    products.Category,
    products.SubCategory,
    MONTHNAME(orders.Order_Date) AS Order_Month,
    LPAD(MONTH(orders.Order_Date), 2, 0) AS Order_Month_Num,
    YEAR(orders.Order_Date) AS Order_Year,
    orders.Sales_in_USD
FROM orders
JOIN products ON orders.Product_ID = products.Product_ID;

WITH ProductDates AS(
SELECT
	orders.Order_ID,
    products.Product_Name,
    products.Category,
    products.SubCategory,
    MONTHNAME(orders.Order_Date) AS Order_Month,
    LPAD(MONTH(orders.Order_Date), 2, 0) AS Order_Month_Num,
    YEAR(orders.Order_Date) AS Order_Year,
    orders.Sales_in_USD
FROM orders
JOIN products ON orders.Product_ID = products.Product_ID)
SELECT
	Order_Month,
    SubCategory, 
    COUNT(SubCategory) AS Purchases
FROM ProductDates
GROUP BY Order_Month, SubCategory, Order_Month_Num
ORDER BY Order_Month_Num, COUNT(SubCategory) DESC;

#Add Rankings to Subcategories for Month
WITH ProductDates AS(
SELECT
	orders.Order_ID,
    products.Product_Name,
    products.Category,
    products.SubCategory,
    MONTHNAME(orders.Order_Date) AS Order_Month,
    LPAD(MONTH(orders.Order_Date), 2, 0) AS Order_Month_Num,
    YEAR(orders.Order_Date) AS Order_Year,
    orders.Sales_in_USD
FROM orders
JOIN products ON orders.Product_ID = products.Product_ID)
SELECT
	Order_Month,
    DENSE_RANK() OVER (
		PARTITION BY Order_Month
        ORDER BY COUNT(Subcategory) DESC
        ) AS Ranking,
    SubCategory, 
    COUNT(SubCategory) AS Purchases
FROM ProductDates
GROUP BY Order_Month, SubCategory, Order_Month_Num
ORDER BY Order_Month_Num, COUNT(SubCategory) DESC;


#Look at Categories instead of Subcategories: 

WITH ProductDates AS(
SELECT
	orders.Order_ID,
    products.Product_Name,
    products.Category,
    products.SubCategory,
    MONTHNAME(orders.Order_Date) AS Order_Month,
    LPAD(MONTH(orders.Order_Date), 2, 0) AS Order_Month_Num,
    YEAR(orders.Order_Date) AS Order_Year,
    orders.Sales_in_USD
FROM orders
JOIN products ON orders.Product_ID = products.Product_ID)
SELECT
	Order_Month,
    Category, 
    COUNT(Category) AS Purchases
FROM ProductDates
GROUP BY Order_Month, Category, Order_Month_Num
ORDER BY Order_Month_Num, COUNT(Category) DESC;

WITH ProductDates AS(
SELECT
	orders.Order_ID,
    products.Product_Name,
    products.Category,
    products.SubCategory,
    MONTHNAME(orders.Order_Date) AS Order_Month,
    LPAD(MONTH(orders.Order_Date), 2, 0) AS Order_Month_Num,
    YEAR(orders.Order_Date) AS Order_Year,
    orders.Sales_in_USD
FROM orders
JOIN products ON orders.Product_ID = products.Product_ID)
SELECT
	Order_Month,
    DENSE_RANK() OVER (
		PARTITION BY Order_Month
        ORDER BY COUNT(Category) DESC
        ) AS Ranking,
    Category, 
    COUNT(Category) AS Purchases
FROM ProductDates
GROUP BY Order_Month, Category, Order_Month_Num
ORDER BY Order_Month_Num, COUNT(Category) DESC;

# Look at Shipping Information: 

#TABLES FOR REFERENCE ONLY: 

	SELECT
		DISTINCT Order_ID AS Order_ID,
        COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
		Order_Date, 
        Ship_Date,
        Ship_Mode,
        LPAD(MONTH(Order_Date), 2, 0) AS Order_Month,
		YEAR(Order_Date) AS Order_Year,
        City,
        State,
		Region
	FROM orders;
	
    SELECT *
    FROM products
    LIMIT 5;
    
# Determine most frequently used Shipping Mode

WITH ShippingInfo AS (
SELECT
	DISTINCT Order_ID AS Order_ID,
	COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
	Order_Date, 
	Ship_Date,
	Ship_Mode,
	LPAD(MONTH(Order_Date), 2, 0) AS Order_Month,
	YEAR(Order_Date) AS Order_Year,
	City,
	State,
	Region
FROM orders)
SELECT
	Ship_Mode,
    COUNT(Order_ID) AS Count
FROM ShippingInfo
GROUP BY
	Ship_Mode;
    
#Does the number of product influence the Shipping Mode?
#Seems to have little influence

WITH ShippingInfo AS(
SELECT
	DISTINCT Order_ID AS Order_ID,
	COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
	Order_Date, 
	Ship_Date,
	Ship_Mode,
	LPAD(MONTH(Order_Date), 2, 0) AS Order_Month,
	YEAR(Order_Date) AS Order_Year,
	City,
	State,
	Region
FROM orders)
SELECT
	Items AS Number_Items_Ordered, 
    Ship_Mode, 
    COUNT(Order_ID) AS Frequency
FROM ShippingInfo
GROUP BY Items, Ship_Mode
ORDER BY Items, COUNT(Order_ID) DESC;

#Does the time of the year influence the Ship Mode?

WITH ShippingInfo AS(
SELECT
	DISTINCT Order_ID AS Order_ID,
	COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
	Order_Date, 
	Ship_Date,
	Ship_Mode,
    MONTHNAME(Order_Date) AS Order_Month,
	LPAD(MONTH(Order_Date), 2, 0) AS Order_Month_Num,
	YEAR(Order_Date) AS Order_Year,
	City,
	State,
	Region
FROM orders)
SELECT 
	Order_Month,
    Ship_Mode,
    COUNT(Order_ID) AS Frequency
FROM ShippingInfo
GROUP BY Order_Month, Ship_Mode, Order_Month_Num
ORDER BY Order_Month_Num, COUNT(Order_ID) DESC;

# Times to Ship Out Orders

SELECT
	DISTINCT Order_ID AS Order_ID,
	COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
	CAST(Order_Date AS DATE) AS Order_Date, 
	CAST(Ship_Date AS DATE) AS Ship_Date,
    DATEDIFF(CAST(Ship_Date AS DATE), CAST(Order_Date AS DATE)) AS Days_Until_Shipped,
	Ship_Mode,
    MONTHNAME(Order_Date) AS Order_Month,
	LPAD(MONTH(Order_Date), 2, 0) AS Order_Month_Num,
	YEAR(Order_Date) AS Order_Year,
	City,
	State,
	Region
FROM orders;

WITH ShippingInfo AS(
SELECT
	DISTINCT Order_ID AS Order_ID,
	COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
	CAST(Order_Date AS DATE) AS Order_Date, 
	CAST(Ship_Date AS DATE) AS Ship_Date,
    DATEDIFF(CAST(Ship_Date AS DATE), CAST(Order_Date AS DATE)) AS Days_Until_Shipped,
	Ship_Mode,
    MONTHNAME(Order_Date) AS Order_Month,
	LPAD(MONTH(Order_Date), 2, 0) AS Order_Month_Num,
	YEAR(Order_Date) AS Order_Year,
	City,
	State,
	Region
FROM orders)
SELECT 
	ROUND(AVG(Days_Until_Shipped)) AS Avg_Days,
    MIN(Days_Until_Shipped) AS Min_Days,
    MAX(Days_Until_Shipped) AS Max_Days
FROM ShippingInfo;

#See Average Days to ship by Month
#Took off Rounding, to see greater clarification on difference

WITH ShippingInfo AS(
SELECT
	DISTINCT Order_ID AS Order_ID,
	COUNT(Order_ID) OVER(PARTITION BY Order_ID) AS Items,
	CAST(Order_Date AS DATE) AS Order_Date, 
	CAST(Ship_Date AS DATE) AS Ship_Date,
    DATEDIFF(CAST(Ship_Date AS DATE), CAST(Order_Date AS DATE)) AS Days_Until_Shipped,
	Ship_Mode,
    MONTHNAME(Order_Date) AS Order_Month,
	LPAD(MONTH(Order_Date), 2, 0) AS Order_Month_Num,
	YEAR(Order_Date) AS Order_Year,
	City,
	State,
	Region
FROM orders)
SELECT 
	Order_Month,
    AVG(Days_Until_Shipped)AS Avg_Days
FROM ShippingInfo
GROUP BY Order_Month, Order_Month_Num
ORDER BY Order_Month_Num;


