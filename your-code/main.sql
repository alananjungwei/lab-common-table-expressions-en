--- 1. Write a CTE that lists the names and quantities of products with a unit price greater than $50. ----

SELECT p.ProductName, p.QuantityPerUnit AS 'Unit'
FROM Products as p
WHERE p.UnitPrice > 50;

---- CTE ------

WITH ExpensiveProducts AS (
    SELECT ProductName, QuantityPerUnit
    FROM Products
    WHERE UnitPrice > 50
)

SELECT ProductName, QuantityPerUnit AS 'Unit'
FROM ExpensiveProducts;


--- 2. What are the top 5 most profitable products? ---

SELECT od.ProductID, p.ProductName, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS 'TotalRevenue'
FROM [Order Details] AS od
JOIN Products As p ON od.ProductID = p.ProductID
GROUP BY od.ProductID, p.ProductName
ORDER BY TotalRevenue DESC
LIMIT 5;
 
--- CTE ---

WITH ProductRevenue AS (
    SELECT 
        od.ProductID,
        p.ProductName,
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue
    FROM [Order Details] AS od
    JOIN Products AS p ON od.ProductID = p.ProductID
    GROUP BY od.ProductID, p.ProductName
)

SELECT *
FROM ProductRevenue
ORDER BY TotalRevenue DESC
LIMIT 5;


--- 3. Write a CTE that lists the top 5 categories by the number of products they have. ---

SELECT c.CategoryName, COUNT(p.ProductName) AS 'ProductCount'
FROM Categories AS c
JOIN Products AS p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName
ORDER BY ProductCount DESC
LIMIT 5;

--- CTE -----

WITH CategoryProductCounts AS (
    SELECT 
        c.CategoryName,
        COUNT(p.ProductName) AS ProductCount
    FROM Categories AS c
    JOIN Products AS p ON c.CategoryID = p.CategoryID
    GROUP BY c.CategoryName
)

SELECT *
FROM CategoryProductCounts
ORDER BY ProductCount DESC
LIMIT 5;

--- 4. Write a CTE that shows the average order quantity for each product category. ---

SELECT c.CategoryName, AVG(od.Quantity) AS 'AvgOrderQuantity'
FROM Categories AS c
JOIN Products AS p ON c.CategoryID = p.CategoryID
JOIN [Order Details] AS od ON p.ProductID = od.ProductID
GROUP BY c.CategoryName
ORDER BY AvgOrderQuantity DESC;

--- CTE ----

WITH CategoryAverages AS (
    SELECT 
        c.CategoryName,
        AVG(od.Quantity) AS AvgOrderQuantity
    FROM Categories AS c
    JOIN Products AS p ON c.CategoryID = p.CategoryID
    JOIN [Order Details] AS od ON p.ProductID = od.ProductID
    GROUP BY c.CategoryName
)

SELECT *
FROM CategoryAverages
ORDER BY AvgOrderQuantity DESC;

--- 5. Create a CTE to calculate the average order amount for each customer. ---
SELECT c.CompanyName AS 'CustomerName', AVG(od.Quantity * od.UnitPrice * (1-od.Discount)) AS 'AvgOrderAmount' 
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
JOIN [Order Details] AS od ON o.OrderID = od.OrderID
GROUP BY c.CompanyName
ORDER BY AvgOrderAmount DESC;

--- CTE ---

WITH CustomerAverages AS (
    SELECT 
        c.CustomerID,
        c.CompanyName AS CustomerName,
        AVG(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS AvgOrderAmount
    FROM Customers AS c
    JOIN Orders AS o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] AS od ON o.OrderID = od.OrderID
    GROUP BY c.CustomerID, c.CompanyName
)

SELECT *
FROM CustomerAverages
ORDER BY AvgOrderAmount DESC;


--- 6. Sales Analysis with CTEs ---
SELECT p.ProductName, COUNT(od.OrderID) AS 'TotalSales'
FROM Products AS p
JOIN [Order Details] AS od ON p.ProductID = od.ProductID
JOIN Orders AS o ON od.OrderID = o.OrderID
WHERE OrderDate >= '1997-01-01' AND OrderDate < '1998-01-01'
GROUP BY p.ProductName
ORDER BY TotalSales DESC

--- CTE ----

WITH ProductSales AS (
    SELECT 
        p.ProductName,
        SUM(od.Quantity) AS TotalSales
    FROM Products AS p
    JOIN [Order Details] AS od ON p.ProductID = od.ProductID
    JOIN Orders AS o ON od.OrderID = o.OrderID
    WHERE o.OrderDate >= '1997-01-01'
      AND o.OrderDate < '1998-01-01'
    GROUP BY p.ProductName
)

SELECT ProductName, TotalSales
FROM ProductSales
ORDER BY TotalSales DESC;