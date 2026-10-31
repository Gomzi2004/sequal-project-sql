--Q1-> All books in the Fiction genre
USE SEQUAL_PROJECT;

SELECT * FROM Books
WHERE Genre = 'Fiction';

--Q2-> Books published after 1950

SELECT * FROM Books
WHERE Published_Year > 1950;

--Q3->. All customers from Canada
SELECT * FROM Customers
WHERE Country = 'Canada';

--Q4->Orders placed in November 2023

SELECT * FROM Orders
WHERE Order_Date >= '2023-11-01'
  AND Order_Date < '2023-12-01';

 --Q5->. Total stock of books available
 SELECT SUM(Stock) AS TotalStock FROM Books;
