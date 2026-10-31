--21. Month-over-month revenue growth, using LAG()
USE SEQUAL_PROJECT;

WITH Monthly AS (
    SELECT
        YEAR(Order_Date) AS Yr,
        MONTH(Order_Date) AS Mn,
        SUM(Total_Amount) AS Revenue
    FROM Orders
    GROUP BY YEAR(Order_Date), MONTH(Order_Date)
),

Previous AS (
    SELECT
        Yr,
        Mn,
        Revenue,
        LAG(Revenue) OVER (ORDER BY Yr, Mn) AS Prev_Revenue
    FROM Monthly
)

SELECT
    Yr,
    Mn,
    Revenue,
    Prev_Revenue,
    CASE
        WHEN Prev_Revenue IS NULL THEN NULL
        ELSE ROUND(
            (Revenue - Prev_Revenue) * 100.0 / Prev_Revenue, 2
        )
    END AS Growth_Percent
FROM Previous
ORDER BY Yr, Mn;


--22. Top 10 customers by spend, with RANK() and share of total revenue

WITH CustomerSpend AS (
    SELECT Customers.Customer_ID, Customers.Name,
           ROUND(SUM(Orders.Total_Amount), 2) AS TotalSpent
    FROM Customers
    JOIN Orders ON Customers.Customer_ID = Orders.Customer_ID
    GROUP BY Customers.Customer_ID, Customers.Name
)
SELECT TOP 10 Customer_ID, Name, TotalSpent,
       RANK() OVER (ORDER BY TotalSpent DESC) AS SpendRank,
       ROUND(TotalSpent * 100.0 / (SELECT SUM(Total_Amount) FROM Orders), 2) AS RevenueSharePct
FROM CustomerSpend
ORDER BY TotalSpent DESC;


--23. Best genre by revenue, with revenue share

SELECT Books.Genre,
       ROUND(SUM(Orders.Total_Amount), 2) AS GenreRevenue,
       ROUND(SUM(Orders.Total_Amount) * 100.0 / (SELECT SUM(Total_Amount) FROM Orders), 2) AS RevenueSharePct
FROM Books
JOIN Orders ON Books.Book_ID = Orders.Book_ID
GROUP BY Books.Genre
ORDER BY GenreRevenue DESC;

--24. Customers who never placed an order

SELECT Customers.Customer_ID, Customers.Name, Customers.City, Customers.Country
FROM Customers
LEFT JOIN Orders ON Customers.Customer_ID = Orders.Customer_ID
WHERE Orders.Order_ID IS NULL
ORDER BY Customers.Customer_ID;

--25. Books never sold, plus per-book stock left after orders, with a low-stock alert
SELECT Books.Book_ID, Books.Title, Books.Stock,
       COALESCE(SUM(Orders.Quantity), 0) AS SoldQty,
       Books.Stock - COALESCE(SUM(Orders.Quantity), 0) AS RemainingStock,
       CASE WHEN Books.Stock - COALESCE(SUM(Orders.Quantity), 0) <= 0 THEN 'Out of stock / Oversold'
            WHEN Books.Stock - COALESCE(SUM(Orders.Quantity), 0) <= 10 THEN 'Low stock'
            ELSE 'OK'
       END AS StockStatus
FROM Books
LEFT JOIN Orders ON Books.Book_ID = Orders.Book_ID
GROUP BY Books.Book_ID, Books.Title, Books.Stock
ORDER BY RemainingStock ASC;
