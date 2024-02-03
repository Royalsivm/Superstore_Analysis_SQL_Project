--1.List the top 10 orders with the highest sales from the EachOrderBreakdown table.

Select * from EachOrderBreakdown;
Select * from OrdersList;


select top 10 * from EachOrderBreakdown
order by Sales Desc;

--2.Show the number of orders for each product category in the EachOrderBreakdown table.
Select Category, Count(OrderId) AS Total_Orders From EachOrderBreakdown 
group by Category;

--3.Find the total profit for each sub-category in the EachOrderBreakdown table.

Select SubCategory, SUM(Profit) AS  Total_Profit From EachOrderBreakdown 
group by SubCategory;

--4.Identify the customer with the highest total sales across all orders.
Select Top 1 CustomerName , sum(sales) as TotalSale 
from EachOrderBreakdown 
join OrdersList ON OrdersList.OrderID = EachOrderBreakdown.OrderID
Group by CustomerName
Order by TotalSale Desc;

--5.Find the month with the highest average sales in the OrdersList table.
Select Top 1 MONTH(OrderDate) as Month , AVG(Sales) as AvgSales
from OrdersList
Join EachOrderBreakdown  ON OrdersList.OrderID = EachOrderBreakdown.OrderID
Group by MONTH(OrderDate)
Order by AvgSales DESC;

--6.Find out the average quantity ordered by customers whose first name starts with an alphabet 's'?
Select  Round(AVG(Quantity),2) as AvgQuantity
from OrdersList
Join EachOrderBreakdown  ON OrdersList.OrderID = EachOrderBreakdown.OrderID
Where LEFT(CustomerName,1) = 'S'

--7.Find out how many new customers were acquired in the year 2014?
Select Count (*) AS TotalNewMember From 
(SELECT CustomerName, Min(OrderDate) AS FirstOrderDate
From OrdersList 
Group By CustomerName
Having Year(MIN(OrderDate)) = '2014') AS CustomerWithFirstOrderIn2014


--8.Calculate the percentage of total profit contributed by each sub-category to the overall profit.

Select SubCategory , Sum(Profit) As Subcategory_Profit,
Sum(Profit)/(SELECT Sum(Profit) From EachOrderBreakdown)*100 AS  Percentage_Profit_contributed
From EachOrderBreakdown
Group By SubCategory

--9.Find the average sales per customer, considering only customers who have made more than one order.
With CustomerAvgSales As (
SELECT CustomerName , Count(Distinct OrdersList.OrderID) AS NumberOfOrders, AVG(Sales) as AvgSales 
From OrdersList
Join EachOrderBreakdown
on OrdersList.OrderID = EachOrderBreakdown.OrderID
Group by CustomerName 
)
SELECT CustomerName,AvgSales
FROM CustomerAvgSales
WHERE NumberOfOrders > 1

 /* 10 .Identify the top-performing subcategory in each category based on total sales.
        Include the sub-category name, total sales,
        and a ranking of sub-category within each category. */
WITH topsubcategory AS(
SELECT Category, SubCategory, SUM(sales) as TotalSales,
RANK() OVER(PARTITION BY Category ORDER BY SUM(sales) DESC) AS SubcategoryRank
FROM EachOrderBreakdown
Group By Category, SubCategory
)
SELECT *
FROM topsubcategory
WHERE SubcategoryRank = 1