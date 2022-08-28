create database company
go
use company
go


create table Dept
(
DeptID int primary key,
DeptName varchar(100) not null
)
go

select * from Dept;

insert into Dept values(1,'sales')
insert into Dept values(2,'marketing')
insert into Dept values(3,'technical')
insert into Dept values(4,'accounts')
insert into Dept values(5,'loans')
insert into Dept values(6,'finance')

sp_helpdb 'company'

create table Employee(
empid	int		primary key,
Empname	varchar(100)	not null,
salary	money	not null check(salary>0),
gender char(1)	not null check(gender='M' or gender='F'),
dob	datetime not null,
phone char(10) null unique,
emailID varchar(50) null unique,
passport char(10) not null unique,
DeptID int null foreign key references Dept(DeptID)
)

select * from Employee

delete  from Employee

insert into Employee values(1,'pavan', 10000, 'M', '1993-12-09','814325','pkumar.datascience@gmail.com','R5255244',3)
insert into Employee values(2,'pavanpuppala', 210000, 'M', '1994/12/09','995161','pkumar@gmail.com','R5255252',2)

sp_help 'Employee'

--topic 13

use company
go

create table product(
PID	int primary key identity(1,1),
ProdName	varchar(100)	not null,
quantity	int	null default(0),
UnitPrice	money	not null
)

select * from product
sp_help 'product'

insert into product values('pen',1000,10)
insert into product values('pencil',1100,15)
insert into product values('eraser',1000,5)
insert into product values('sketches',1000,12)
insert into product values('cabduary',800,20)

select @@IDENTITY

delete from product   --delete all rows but creates gaps

truncate table product   --delete all rows with no gaps

--default
insert into product values('lux','',20)

--explicit insert
insert into product(ProdName, UnitPrice) values('Lenovo', 120)

alter table product
add Rating tinyint

update product set Rating=2 where PID>2