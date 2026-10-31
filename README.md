# SEQUAL_PROJECT — SQL Resume Project

A first SQL portfolio project in SQL Server (SSMS, T-SQL) on a small bookstore dataset: Books, Customers, and Orders. All 25 queries below were run and verified in SSMS.

**Live working site — try every query in your browser, no SQL Server needed:**
https://gomzi2004.github.io/sequal-project-sql/

Open the link, see the top 5 rows of each table first, select any of the 25 queries, edit the SQL if you want, and click **Execute** to see the result table. You can also download any result as CSV.

**Repository:** https://github.com/Gomzi2004/sequal-project-sql

## Dataset

Dataset source: [SatishDhawale/SQL_Resume_Project](https://github.com/SatishDhawale/SQL_Resume_Project)

| Table | Rows | Columns |
| --- | --- | --- |
| Books | 500 | Book_ID, Title, Author, Genre, Published_Year, Price, Stock |
| Customers | 500 | Customer_ID, Name, Email, Phone, City, Country |
| Orders | 500 | Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount |

How they join: `Orders.Customer_ID → Customers.Customer_ID`, `Orders.Book_ID → Books.Book_ID`.

Verified load checks:

- Books: 500, Customers: 500, Orders: 500
- Total stock: `SUM(Books.Stock) = 25,056`
- Total revenue: `ROUND(SUM(Orders.Total_Amount), 2) = 75,628.66`
- Total ordered quantity: 2,697, so stock remaining: `25,056 − 2,697 = 22,359`
- Orders date range: 2022-12-09 to 2024-12-07
- Only 307 customers ever ordered, and only 317 books were ever sold — so 193 customers never ordered, and 183 books were never sold.

## How to run it in SSMS

1. Create a database called `SEQUAL_PROJECT`.
2. Import `Books.csv`, `Customers.csv`, and `Orders.csv` with SSMS Import Flat File.
3. Tick Primary Key only on `Books.Book_ID`, `Customers.Customer_ID`, and `Orders.Order_ID`. Do NOT tick it on `Orders.Customer_ID` or `Orders.Book_ID` — those values repeat.
4. Make Title and Country at least 100 characters (50 would truncate the longest values), Price and Total_Amount decimal, and Order_Date a date.
5. Run the queries in the `.sql` files below. The dialect is T-SQL only: "first N rows" is `TOP`, not `LIMIT`.

Note on the import: if SSMS imports `Total_Amount` as float, the raw sum shows as 75628.6601614952. The clean value is 75628.66 — use `ROUND(SUM(Total_Amount), 2)`. No reload is needed.

## Queries — 25 in total

### Basic (11) — `SEQUAL_PROJECT_Q1-Q5.sql`, `SEQUAL_PROJECT_Q6-Q11.sql`

| # | Query | Verified result |
| --- | --- | --- |
| 1 | Books in the Fiction genre | 60 rows |
| 2 | Books published after 1950 | 292 rows |
| 3 | Customers from Canada | 3 — Nicholas Harris, James Ramirez, David Hart |
| 4 | Orders in November 2023 | 25 orders |
| 5 | Total stock of all books | 25,056 |
| 6 | Most expensive book | Book 340, "Proactive system-worthy orchestration", Robert Scott, Mystery, $49.98 |
| 7 | Customers who ordered more than 1 quantity | 281 distinct customers |
| 8 | Orders where Total_Amount > $20 | 473 orders |
| 9 | All genres available | 7 — Biography, Fantasy, Fiction, Mystery, Non-Fiction, Romance, Science Fiction |
| 10 | Book(s) with the lowest stock | 5 books at Stock 0 — IDs 44, 60, 127, 163, 378 |
| 11 | Total revenue | $75,628.66 |

### Advanced (9) — `SEQUAL_PROJECT_ADVANCED_Q1-Q9.sql`

| # | Query | Verified result |
| --- | --- | --- |
| A1 | Total quantity sold by genre | Mystery 504 (top), then Science Fiction 447, Fantasy 446, Romance 439, Non-Fiction 351, Biography 285, Fiction 225 — total 2,697 |
| A2 | Average price of Fantasy books | $25.98 (71 Fantasy books) |
| A3 | Customers with 2 or more orders | 139 customers, out of 307 who ordered |
| A4 | Most frequently ordered book | 7-way tie at 4 orders — Book IDs 31, 73, 88, 120, 273, 333, 491. Book 73 leads on total quantity, 28 copies |
| A5 | Top 3 Fantasy books by price | 240 ($49.90), 462 ($49.23), 238 ($48.97) |
| A6 | Total quantity sold by author | 314 authors with sales. Top: Patrick Contreras 28, then Melissa Taylor 27 |
| A7 | Cities where a single order was over $30 | 283 cities (285 customers). This is single-order spend, not lifetime spend |
| A8 | Top spender | Kim Turner, Customer_ID 457, South Rachelview, Cambodia — $1,398.90 over 4 orders. Next: Jonathon Strickland $1,080.95 |
| A9 | Total stock remaining after all orders | 22,359. Use separate SUMs / a subquery — a JOIN SUM(Stock) double-counts stock for books ordered more than once |

### Super Advanced (5) — `SEQUAL_PROJECT_21-25.sql`

| # | Query | Verified result |
| --- | --- | --- |
| 21 | Month-over-month revenue growth, using LAG() | 25 months, Dec 2022 to Dec 2024. First month Dec 2022 $2,513.36, no previous month, so no growth. Peak month May 2023 $5,110.81. Last month Dec 2024 $865.58 on 7 orders is a partial month — data ends 2024-12-07, so its −75.2% is not a crash |
| 22 | Top 10 customers by spend, with RANK() and share of total revenue | Rank 1: Kim Turner $1,398.90, 1.85%. Then Jonathon Strickland $1,080.95, 1.43%, and Carrie Perez $1,052.27, 1.39% |
| 23 | Best genre by revenue, with revenue share | Romance $13,086.98, 17.30%, then Mystery $12,788.45, 16.91%. Contrast with A1: by copies sold, Mystery was top |
| 24 | Customers who never placed an order | 193 customers (500 − 307 who ordered) |
| 25 | Books never sold, plus per-book stock left after orders | 500 rows. 183 books never sold, 85 books with remaining stock ≤ 10, 36 books with remaining stock ≤ 0 (6 exactly 0, 30 negative — synthetic data oversold against recorded stock, not a query bug) |

## Files in this repo

```
index.html                              Working site — top 5 rows, 25-query selector, Execute
Books.csv                               500 rows
Customers.csv                           500 rows
Orders.csv                              500 rows
SEQUAL_PROJECT_Q1-Q5.sql                Basic queries 1–5
SEQUAL_PROJECT_Q6-Q11.sql               Basic queries 6–11 (Q6 corrected to TOP 1)
SEQUAL_PROJECT_ADVANCED_Q1-Q9.sql       Advanced queries 1–9
SEQUAL_PROJECT_21-25.sql                Super Advanced queries 21–25
README.md                               This file
```

## About the working site

`index.html` is a single file. The data is embedded in it, and it runs in the browser with an in-browser SQLite engine (sql.js from CDN). The code shown is T-SQL for SSMS, and the site translates it automatically for execution: `TOP` becomes `LIMIT`, and `YEAR()` / `MONTH()` become `strftime` calls. `LAG()` and `RANK()` work as normal. If the engine cannot load offline, Execute shows the verified precomputed result for the 25 listed queries instead, and says so on the page.

## Skills shown

T-SQL, SSMS, Import Flat File, primary keys, `JOIN`, `GROUP BY`, `HAVING`, aggregate functions, `DISTINCT`, subqueries, `TOP`, window functions (`LAG()`, `RANK()`), and turning a set of queries into a working, shareable demo.
