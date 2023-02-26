USE IBANK
GO

/***************************************************************************
SPName: PreviousMonthBankStatement
Author: Pavan Puppala
Date  : Feb 24th, 2023
Purpose: It will get previous month transaction done by the given customer.

History:
--------------------------------------------------------------------------
SL No	 Done By	Date of Change		Remarks
--------------------------------------------------------------------------
1.		 Pavan		Feb 24th 2023		New SP
2.		 Sharadha	Mar 22nd 2023		Modified and added tax Col in the SP
3.		 Charan		Aug 6th  2023		Modified and added.....
****************************************************************************/

alter proc sp_previousMonthBankStatement
(
	@acid int = 101
)
as
begin
	declare @CustName varchar(40)
	declare @pid char(2)
	declare @brid char(3)
	declare @balance money

	print '-----------------------------------'
	print '		INDIAN BANK		'
	print 'List of Transactions Report'
	print '-----------------------------------'

	--customer info
	SELECT @CustName=Name, @brid=brid, @pid=pid, @balance=cbal 
	FROM AMASTER WHERE ACID=@acid

	--Print the variables
	print 'Product Name :'+@pid
	print 'Account Number :'+cast(@acid as varchar)+space(15)+   'Branch :'+@brid
	print 'Customer Name :'+@CustName	+space(10)+    'Cleared Balance : INR '+cast(@balance as varchar)
	print '---------------------------------------------------------------------'
	print 'SL.No	DOT		TXN TYPE	CHEQUE No	AMOUNT		RUNNING BALANCE'
	print '---------------------------------------------------------------------'

	--get the previous transactions done by the customer
	SELECT * FROM TMASTER WHERE DATEDIFF(MM, DOT, GETDATE())=1 AND ACID=@acid
	
end
go

--call SP
exec sp_previousMonthBankStatement


SELECT *, ROW_NUMBER() over (order by DOT asc) as RNo 
FROM TMASTER WHERE DATEDIFF(MM, DOT, GETDATE())=1 AND ACID=101


