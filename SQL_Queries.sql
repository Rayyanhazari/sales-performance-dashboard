/*====================================================
  Sales Performance Dashboard
  Author : Mohammed Rayyan Hazari
  Database : SuperstoreDB
  Description : SQL Queries used for Sales Analysis
====================================================*/

--Total Sales
SELECT
SUM(sales) AS Total_Sales
FROM Orders;

--Total Orders
SELECT
COUNT(Order_ID) AS Total_Orders
FROM Orders;

--Total Customers
SELECT
COUNT(DISTINCT Customer_ID) AS Total_Customers
FROM Orders;

--Average Orders Value
SELECT
ROUND(AVG(Sales),2) AS Average_Order_Value
FROM Orders;

--Sales by Category
SELECT
Category,
SUM(Sales) AS total_sales
FROM Orders
GROUP BY Category
ORDER BY total_sales DESC;

--Sales by Region
SELECT
Region,
SUM(Sales) AS total_sales
FROM Orders
GROUP BY Region
ORDER BY total_sales DESC;

--Sales by State
SELECT
State,
SUM(Sales) AS total_sales
FROM Orders
GROUP BY State
ORDER BY total_sales DESC;

--Monthly Sales Trend
SELECT
YEAR(Order_Date) AS Sales_Year,
MONTH(Order_Date) AS Sales_Month,
SUM(Sales) AS total_sales
FROM Orders
GROUP BY YEAR(Order_Date),
MONTH(Order_Date) 
ORDER BY Sales_Year,Sales_Month ;

--Top 10 Customers
SELECT TOP 10
Customer_Name,
SUM(Sales) AS total_sales
FROM Orders
GROUP BY Customer_Name
ORDER BY total_sales DESC;

--Top 10 Products
SELECT TOP 10
Product_Name,
SUM(Sales) AS total_sales
FROM Orders
GROUP BY Product_Name
ORDER BY total_sales DESC;

--Average Sales Per Customer
SELECT
Customer_Name,
ROUND(AVG(Sales),2) AS Avg_Sales
FROM Orders
GROUP BY Customer_Name
ORDER BY Avg_Sales DESC;

--Customer Ranking (Window Fucntions)
SELECT
Customer_Name,
SUM(Sales) AS total_sales,
RANK() OVER(ORDER BY SUM(Sales)  DESC) AS Customer_Rank
FROM Orders
GROUP BY Customer_Name;

--Running Total
SELECT
Order_Date,
Sales,
SUM(Sales) OVER(ORDER BY Order_Date) AS Running_Total
FROM Orders;

--Previous Order Sales
SELECT
Order_Date,
Sales,
LAG(Sales) OVER(ORDER BY Order_Date) AS Previous_Sales
FROM Orders;

--Sales Categoty (CASE)
SELECT
Order_ID,
Sales,
CASE
    WHEN Sales >= 500 THEN 'High'
    WHEN Sales >= 200 THEN 'Medium'
    ELSE 'Low'
    END AS Sales_Category
FROM Orders;

--common Table Expression (CTE)
WITH CategorySales AS
(
    SELECT
        Category,
        SUM(Sales) AS Total_Sales
    FROM Orders
    GROUP BY Category
)

SELECT *
FROM CategorySales
ORDER BY Total_Sales DESC;

--Top Customer from Each Region
WITH CustomerSales AS
(
SELECT
Region,
Customer_Name,
SUM(Sales) AS Total_Sales,
RANK() OVER(PARTITION BY Region ORDER BY SUM(Sales) DESC) AS Rank_No
FROM Orders
GROUP BY
Region,
Customer_Name
)
SELECT *
FROM CustomerSales
WHERE Rank_No = 1;

--Customers Above Average Sales (Subquery)
SELECT
    Customer_Name,
    SUM(Sales) AS Total_Sales
FROM Orders
GROUP BY Customer_Name
HAVING SUM(Sales) >
(
    SELECT AVG(Customer_Total)
    FROM
    (
        SELECT SUM(Sales) AS Customer_Total
        FROM Orders
        GROUP BY Customer_Name
    ) AS AvgSales
)
ORDER BY Total_Sales DESC;

