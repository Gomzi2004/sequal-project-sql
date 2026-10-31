
--Advanced 1. Total number of books sold for each genre

USE SEQUAL_PROJECT;

SELECT Books.Genre, SUM(Orders.Quantity) AS TotalSold
FROM Books
JOIN Orders ON Books.Book_ID = Orders.Book_ID
GROUP BY Books.Genre
ORDER BY TotalSold DESC;

--Advanced 2. Average price of books in the Fantasy genre
SELECT ROUND(AVG(Price), 2) AS AvgFantasyPrice
FROM Books
WHERE Genre = 'Fantasy';


--Advanced 3. Customers who have placed at least 2 orders

SELECT Customers.Customer_ID, Customers.Name,
       COUNT(Orders.Order_ID) AS OrderCount
FROM Customers
JOIN Orders ON Customers.Customer_ID = Orders.Customer_ID
GROUP BY Customers.Customer_ID, Customers.Name
HAVING COUNT(Orders.Order_ID) >= 2
ORDER BY OrderCount DESC;


--Advanced 4. Most frequently ordered book

SELECT Books.Book_ID, Books.Title,
       COUNT(Orders.Order_ID) AS OrderCount,
       SUM(Orders.Quantity) AS TotalQuantity
FROM Books
JOIN Orders ON Books.Book_ID = Orders.Book_ID
GROUP BY Books.Book_ID, Books.Title
ORDER BY OrderCount DESC, TotalQuantity DESC;


--Advanced 5. Top 3 most expensive books of the Fantasy genre

SELECT TOP 3 * FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC;

--Advanced 6. Total quantity of books sold by each author

USE SEQUAL_PROJECT;

SELECT Books.Author, SUM(Orders.Quantity) AS TotalSold
FROM Books
JOIN Orders ON Books.Book_ID = Orders.Book_ID
GROUP BY Books.Author
ORDER BY TotalSold DESC;

--Advanced 7. Cities where customers who spent over $30 are located
SELECT DISTINCT Customers.City
FROM Customers
JOIN Orders ON Customers.Customer_ID = Orders.Customer_ID
WHERE Orders.Total_Amount > 30;

--Advanced 8. The customer who spent the most on order

SELECT TOP 1 Customers.Customer_ID, Customers.Name,
       ROUND(SUM(Orders.Total_Amount), 2) AS TotalSpent
FROM Customers
JOIN Orders ON Customers.Customer_ID = Orders.Customer_ID
GROUP BY Customers.Customer_ID, Customers.Name
ORDER BY TotalSpent DESC;

--Advanced 9. Stock remaining after fulfilling all orders

SELECT
    (SELECT SUM(Stock) FROM Books)
    - (SELECT SUM(Quantity) FROM Orders) AS RemainingStock;

