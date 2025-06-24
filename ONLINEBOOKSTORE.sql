CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Orders;
SELECT * FROM Customers;


-- DATA HAS BEEN ADDED TO THE TABLES RESPECTIVELY 

-- BASIC QUERIES 

-- 1) RETRIEVE ALL BOOKS IN THE "FICTION" GENRE:
SELECT * FROM Books 
WHERE Genre='Fiction';

--2) FIND THE BOOKS PUBLISHED AFTER THE YEAR 1950;
SELECT * FROM Books
WHERE Published_year>1950
ORDER BY Published_year ASC;

--3) list all customers from canada
SELECT * FROM Customers
WHERE country='Canada'
ORDER BY customer_id DESC;

--4) Show orders placed in november 2023 
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30'
ORDER BY order_date ASC; 
 
-- 5) retrieve the total stock of books available 
SELECT SUM(b.stock)- SUM(o.quantity) AS Total_STOCK
FROM Books b 
JOIN 
Orders o 
ON b.book_id=o.book_id;

SELECT SUM(stock) AS Total_STOCK
FROM Books;

--6) Find the details of most expensive book 
SELECT * FROM Books 
ORDER BY price DESC
LIMIT 1;

--7) SHOW ALL CUSTOMERS WHO ORDERED MORE THN 1 QTY OF A BOOK;
SELECT DISTINCT o.customer_id,c1.name,o.quantity FROM Customers c1
JOIN 
Orders o 
ON o.customer_id=c1.customer_id
WHERE o.quantity>1
ORDER BY o.customer_id ASC;

--8) RETRIEVE ALL ORDERS WHERE TOTAL AMOUNT EXCEEDS $20
SELECT * FROM Orders
WHERE total_amount>20;

-- 9) list all genres available in the books table
SELECT DISTINCT genre FROM Books;

--10) FIND THE BOOK WITH LOWEST STOCK
SELECT * FROM Books 
ORDER BY stock ASC
LIMIT 	1;

--11) calc the total revenue generated from all orders 
SELECT SUM(total_amount) AS Revenue FROM Orders;

-- ADVANCED QUERIES 

-- 1) retieve the number of books sold for each genre
SELECT b.genre, SUM(o.quantity) 
FROM Orders o
JOIN Books b 
ON o.book_id=b.book_id
 GROUP BY b.genre;
 
 --2) Find the avg price of books in the 'Fantasy' genre
 SELECT AVG(price) AS Average_price
 FROM books
 WHERE Genre='Fantasy';
 
 --3) List customers who have placed at least 2 orders
 SELECT o.customer_id, c.name, COUNT(o.Order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id , c.name
HAVING COUNT(Order_id) >=2;
 
-- 4) Find the most frequently ordered book 
SELECT o.book_id , b.title , COUNT(o.order_id) AS ORDER_COUNT
FROM orders o 
JOIN Books b 
ON o.book_id=b.book_id
GROUP BY o.book_id , b.title 
ORDER BY  ORDER_COUNT DESC 
LIMIT 1;

--5) SHOW THE TOP 3 MOST EXPENSIVE BOOKS OF 'FANTASY' GENRE 
SELECT book_id , title,genre,price FROM books
WHERE genre ='Fantasy'
ORDER BY price DESC
LIMIT 3;

--6)Retreive the total quantity of books sold by each author 
SELECT b.book_id,b.author , SUM(o.quantity) AS Total_Quantity
FROM Orders o 
JOIN Books b
ON b.book_id = o.book_id
GROUP BY b.book_id ,b.author
ORDER BY Total_Quantity DESC;
 
--7) List the cities where customers who spent over $30 are located 
SELECT c.name,c.city , o.total_amount 
FROM Customers c
JOIN Orders o 
ON o.customer_id=c.customer_id
WHERE total_amount>30
ORDER BY total_amount ASC;

--8) Find the customer who spent the most on orders 
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent Desc LIMIT 1;

--9) CALCULATE THE STOCK REMAINING AFTER THE ORDER 
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
 LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id,b.title
ORDER BY b.book_id ASC;


