--6. Details of the most expensive book

SELECT TOP 1 * FROM Books
ORDER BY Price DESC;


--7. All customers who ordered more than 1 quantity of a booK
SELECT DISTINCT Customers.*
FROM Customers
JOIN Orders ON Customers.Customer_ID = Orders.Customer_ID
WHERE Orders.Quantity > 1;

--8. All orders where the total amount exceeds $20
SELECT * FROM Orders
WHERE Total_Amount > 20;

--9. All genres available in the Books table
SELECT DISTINCT Genre FROM Books;

--10. The book with the lowest stock
SELECT * FROM Books
WHERE Stock = (SELECT MIN(Stock) FROM Books);

--11->Total revenue, 
SELECT ROUND(SUM(Total_Amount), 2) AS TotalRevenue FROM Orders;
