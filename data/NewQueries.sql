SELECT DATEDIFF(YY, '1994/12/09', GETDATE()) as Age

select *,datename(dw, OrderDate) as daynme 
from Orders 
where datename(dw, OrderDate)='Monday'

select * , DATEPART(yy, OrderDate) as yearNo, DATEPART(QQ, OrderDate) as quarterNo
from Orders