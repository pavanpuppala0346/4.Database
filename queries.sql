SELECT * FROM customers;
SELECT CustomerName, City FROM Customers;
select distinct country from customers;
select count(distinct country)  from customers;
select count(city) from customers;
select * from customers where country='Mexico';

select * from products;
select * from products where price>30;
select * from products where price<30;
select * from products where price>=30;
select * from products where price<=30;
select * from products where price <> 18;
select * from products where price between 50 and 60;
select * from customers where city like 's%';
select * from customers where city in ('Paris','London');

select * from customers;
select * from customers where country='Germany' and city='Berlin';
select * from customers where city='Berlin' or city='Mannheim';
select * from customers where not country='Germany';
select * from customers where country='Germany' and (city='Berlin' or city='Mannheim');	
select * from Customers where not Country='Germany' and not Country='USA';

select * from customers order by country;
select * from customers order by country desc;
select * from customers order by country, customername;
select * from customers order by country asc, customername desc;

insert into Customers (CustomerName, contactname, address, City, postalcode, Country) VALUES ('pavan kumar','pavan puppala', 'west godavari bhimavaram', 'Bhimavaram',534202,'India');
select * from customers;


update customers set customername="pavan kumar puppala", contactname="pavan puppala01" where customerid=93;
delete from customers where country='India';	

SELECT * FROM Customers LIMIT 10;
SELECT * FROM Customers WHERE Country='Germany' LIMIT 3;

select max(Price) from products;
select min(Price) from products;

select count(productname) from products;
select avg(price) from products;
select sum(quantity) from orderdetails;




