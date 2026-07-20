create table books (
	book_id serial primary key,
	title varchar(100),
	author varchar(100),
	genre varchar(50),
	published_year int,
	price NUMERIC(10,2),
	Stock int
);
select * from books;

CREATE TABLE customers (
	customer_id serial primary key,
	name varchar(100),
	email varchar(100),
	phone varchar(15),
	city varchar(50),
	country varchar(150)
);
select * from customers;

CREATE TABLE orders(
	order_id serial primary key,
	customer_id int references customers(customer_id),
	book_id int references books(book_id),
	order_date DATE,
	Quantity int,
	total_amount NUMERIC(10,2)
);
select * from orders;

--import Data into books table 
copy books(book_id, title, author, genre, published_year, price, stock)
from 'C:\Users\kulde\Downloads\ST - SQL ALL PRACTICE FILES SD61\ST - SQL ALL PRACTICE FILES-2\All Excel Practice Files\Books.csv'
DELIMITER ','
CSV HEADER;

--import data into costomers table
\COPY customers(customer_id, name, email, phone, city, country)
from'C:/Users/kulde/Downloads/Customers.csv'
DELIMITER ','
CSV HEADER;

-- import data into orders
COPY orders(order_id, customer_id, book_id, order_date, quantity, total_amount)
form''
delimiter','
CSV HEADER;

-- 1) Retrieve all books in the "fiction" genre:
SELECT * FROM Books
WHERE genre= 'Fiction';

-- 2) Find books published after the year 1950:
SELECT * FROM Books
WHERE Published_year > 1950;

--3) list all customers from the canada:
SELECT * FROM customers 
WHERE country= 'Canada';

--4) show orders placed in November 2023:
SELECT * FROM orders
WHERE order_date BETWEEN '2023-11-1' AND '2023-11-30';

--5) retrive the total stock of books abailable:
SELECT SUM(stock) as total_stock
from books;

--6) Find the details of the most expensive book:
SELECT MAX(PRICE) AS expensive_book
FROM books;

--7) show all customeres who ordered more than 1 quantity of a book;
Select * from orders
where quantity>1;

--8) Retrieve all orders where the total amount exceeds $20:
SELECT * from orders
where total_amount>20;

--9) list all genres available in the books table:
SELECT DISTINCT genre from BOOKS;

--10) find the book with the lowest stock:
SELECT MIN(STOCK) AS lowest_stock
FROM BOOKS;
 -- or --
SELECT * FROM BOOKS ORDER BY stock ASC LIMIT 1;

--11)Calculate the total revenue generated from all order:
SELECT SUM(total_amount) as total_revenue
from orders;

-- advance--
SELECT * FROM BOOKS;
SELECT * FROM ORDERS;
SELECT * FROM CUSTOMERS;

--12)Retrieve the total number of books sold for each genre:
SELECT b.GENRE,SUM(O.quantity) as Total_Books_sold
FROM books b
JOIN orders o ON o.book_id = b.book_id
GROUP BY b.genre;

--13) find the average price of books in the "Fantasy" genre:
SELECT  AVG(price) as average_price
FROM books 
WHERE genre = 'Fantasy'
group by genre;

--14) list customers who have placed at least 2 orders:
SELECT c.customer_id,C.name, COUNT(o.order_id)  as total_ordres
FROM customers c
JOIN ORDERS O ON c.customer_id = o.customer_id
group by c.customer_id , c.name
HAVING COUNT(o.order_id)>=2;

SELECT customer_id, count(order_id) as total_orders
from orders
group by customer_id
having count(order_id)>=2;

--15)--find the most frequently ordered books:
SELECT b.title, count(o.order_id) as most_frequently_order
from orders o
join books b on o.book_id = b.book_id
group by b.title
order by most_frequently_order DESC
limit 1;

--16) show the top 3 most expensive books of 'fantasy' genre
SELECT title,genre,price FROM Books
WHERE genre = 'Fantasy'
ORDER BY PRICE DESC
LIMIT 3;

--17) retrive the total quantity of books sold by each author
SELECT b.author, sum(o.quantity) as total_quantity
from books b
join orders o on b.book_id = o.book_id
group by b.author;

--18) list the cities where customers who spent over $30 are located;

SELECT DISTINCT c.city 
from orders o
join customers c on c.customer_id = o.customer_id
where o.total_amount >= 30;

--19) find the customer who spent the most on orders:
SELECT c.name, sum(o.total_amount)as spen_most_on_order 
from orders o
join customers c ON o.customer_id = c.customer_id
group by c.name
order by spen_most_on_order desc 
limit 1;

--20)calculate the stock remaining after fulfiling all orders:
SELECT b.book_id,b.title, b.stock ,COALESCE(sum(o.quantity),0) as total_ordered,
                            b.stock - COALESCE(sum(o.quantity),0) as remaining_stock
FROM books b 
join orders o on o.book_id = b.book_id
group by b.book_id,b.title, b.stock
ORDER BY b.book_id;

