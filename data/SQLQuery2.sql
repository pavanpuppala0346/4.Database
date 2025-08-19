----------------1. intro to tsql--------------------
USE IBANK
GO

SELECT * FROM AMASTER WHERE ACID IN (
		SELECT DISTINCT ACID FROM TMASTER WHERE DATEDIFF (MM, DOT, GETDATE()) <=6)

SELECT * FROM AMASTER WHERE ACID NOT IN (
		SELECT DISTINCT ACID FROM TMASTER WHERE DATEDIFF (MM, DOT, GETDATE()) <=6)

UPDATE AMASTER SET STATUS='I' WHERE ACID IN ( 
		SELECT ACID FROM AMASTER WHERE ACID NOT IN (
			SELECT DISTINCT ACID FROM TMASTER WHERE DATEDIFF (MM, DOT, GETDATE()) <=6
		)
) 


---------------------2. creating a view--------------
USE IBANK
GO

CREATE VIEW vw_GetCustomers_BR1
as
	SELECT * FROM AMASTER WHERE BRID='BR1'

SELECT * FROM vw_GetCustomers_BR1


CREATE VIEW vw_DidNotMake_txn
as
	SELECT * FROM AMASTER WHERE ACID NOT IN (
		SELECT DISTINCT ACID FROM TMASTER WHERE DATEDIFF(MM, DOT, GETDATE()) <=6)

SELECT * FROM vw_DidNotMake_txn

sp_helptext 'vw_DidNotMake_txn'

ALTER VIEW vw_didnotmake_txn
As 
	SELECT ACID, NAME, CBAL FROM AMASTER WHERE ACID NOT IN (
		SELECT DISTINCT ACID FROM TMASTER WHERE DATEDIFF (MM, DOT, GETDATE()) <=6)

DROP VIEW vw_didnotmake_txn

SELECT * FROM SYS.TABLES 
SELECT * FROM SYS.VIEWS 
SELECT * FROM SYS.PROCEDURES
SELECT 'SELECT * FROM'+ NAME FROM SYS.VIEWS

CREATE VIEW vw_GetBranchWiseCustomers_count
As
  SELECT BRID, COUNT(*) AS CNT FROM AMASTER GROUP BY BRID

SELECT * FROM vw_GetBranchWiseCustomers_count WHERE CNT = 
		(SELECT MAX(CNT) FROM vw_GetBranchWiseCustomers_count)


SELECT *  FROM AMASTER
INSERT INTO AMASTER VALUES(163, 'PAWAN','BHIMAVARAM', 'BR1', 'SB', GETDATE(), 1000,2000,'O')

SELECT * FROM vw_GetCustomers_BR1
INSERT INTO vw_GetCustomers_BR1 
VALUES(164, 'KUMAR','BHIMAVARAM', 'BR1', 'SB', GETDATE(), 2000,4000,'O')

INSERT INTO vw_GetCustomers_BR1 
VALUES(165, 'KALYAN','BHIMAVARAM', 'BR3', 'SB', GETDATE(), 4000,5000,'O')

UPDATE vw_GetCustomers_BR1
SET CBAL=12000, UBAL=12000 WHERE ACID=164

DELETE FROM vw_GetCustomers_BR1 WHERE ACID=162

------------4. views part3---------------


CREATE VIEW vw_CurrentYearTxns
	AS
	SELECT DOT, ACID, BRID, TXNTYPE, TXNAMT FROM TMASTER WHERE DATEDIFF(YY, DOT, GETDATE())=11

SELECT * FROM vw_CurrentYearTxns
SELECT * FROM AMASTER



SELECT A.ACID, NAME, DOT, A.BRID, TXNTYPE, TXNAMT, CBAL
FROM vw_CurrentYearTxns AS A JOIN AMASTER AS B ON A.ACID=B.ACID

CREATE VIEW vw_GetCustNameandTxns
As
	SELECT A.ACID, NAME, DOT, A.BRID, TXNTYPE, TXNAMT, CBAL
	FROM vw_CurrentYearTxns AS A JOIN AMASTER AS B ON A.ACID=B.ACID


SELECT * FROM vw_GetCustNameandTxns WHERE TXNTYPE='CD'

SELECT BRID, SUM(TXNAMT) AS TOTALTXNAMT
FROM vw_GetCustNameandTxns WHERE TXNTYPE='CD' GROUP BY  BRID


CREATE VIEW vw_GetFDCustomers
As
	Select * from AMASTER where PID = 'FD'

CREATE VIEW vw_GetBR1FDCustomers
As
	SELECT * FROM VW_GETFDCUSTOMERS WHERE BRID = 'BR1'


SELECT * FROM vw_GetFDCustomers
SELECT * FROM vw_GetBR1FDCustomers


-----------Views part4: Schemas and Indexed -------------
USE IBANK
GO

CREATE SCHEMA SALES
GO

DROP SCHEMA SALES
GO

CREATE TABLE SALES.EMP
(
	Eid		int		primary key,
	Empname	varchar(10)	not null,
	Sal		money		null
 )

SELECT * FROM SALES.EMP


















-----------------6. Create Variables-------------
DECLARE @X INT

SET @X = 10
PRINT @X

SET @X = 20
PRINT @X


DECLARE @Y SMALLINT

SET @Y = -1000
PRINT @Y

SET @Y = 2000
PRINT @Y


DECLARE @A INT
DECLARE @B INT
SET @A = 40
SET @B = 55
PRINT 'TOTAL VALUE = '+CAST(@A+@B AS VARCHAR)


USE IBANK
GO

CREATE PROC SP_ADDNUMBERS
AS 
BEGIN 
	DECLARE @X INT
	DECLARE @Y INT
	DECLARE @Z INT

	SET @X = 10
	SET @Y = 20
	SET @Z = @X+@Y

	PRINT @Z
END
GO

EXEC SP_ADDNUMBERS

CREATE PROC sp_getMyAccBal
(
	@ACID INT
)
AS 
BEGIN
	SELECT * FROM AMASTER WHERE ACID = @ACID
END

EXEC SP_GETMYACCBAL 134

---------8. Global Variables and SP--------------
--Ex.3 Add 500 to existing value
DECLARE @x Money
SET @x = 100
SET @x = @x+500
print @x

--Ex.4 swap two numbers
DECLARE @x int    --or--  DECLARE @x int = 10
SET @x = 10

DECLARE @y int    --or--  DECLARE @y int = 20
SET @y = 20

Print 'Before swapping'
Print @x
Print @y

Declare @z int
Set @z = @y
Set @y = @x
Set @x = @z
Set @z = null

Print 'After swapping'
Print @x
Print @y


--Here every time I have to provide the acid as a static value

DECLARE @ID INT
SET @ID = 107

SELECT * FROM AMASTER WHERE ACID = @ID
SELECT * FROM TMASTER WHERE DATEDIFF(YY, DOT, GETDATE()) = 11 AND ACID = @ID
SELECT COUNT(*) AS NoOfCDs FROM TMASTER 
WHERE DATEDIFF(YY, DOT, GETDATE()) = 11 AND TXNTYPE = 'CW' AND ACID = @ID

--------------------------------------------------

DECLARE @AID INT
SET @AID = 107

SELECT * FROM AMASTER WHERE ACID = @AID
SELECT * FROM TMASTER WHERE DATEDIFF(YY, DOT, GETDATE()) = 11 AND ACID = @AID
SELECT TXNTYPE, COUNT(*) AS NoOftxns FROM TMASTER 
WHERE DATEDIFF(YY, DOT, GETDATE()) = 11 AND ACID = @AID GROUP BY TXNTYPE

--------------------------------------------------------

CREATE PROC sp_GetTxns
(
     @AID INT	
)
AS 
BEGIN 

	SELECT * FROM AMASTER WHERE ACID = @AID
	SELECT * FROM TMASTER WHERE DATEDIFF(YY, DOT, GETDATE()) = 11 AND ACID = @AID
	SELECT TXNTYPE, COUNT(*) AS NoOftxns FROM TMASTER 
	WHERE DATEDIFF(YY, DOT, GETDATE()) = 11 AND ACID = @AID GROUP BY TXNTYPE

END

EXEC sp_GetTxns 107

--sp_helptext 'sp_GetTxns'
------------------------------------------------------------
CREATE PROC sp_GetTxnsYear
(
     @AID INT,
	 @TENURE TINYINT
)
AS 
BEGIN 

	SELECT * FROM AMASTER WHERE ACID = @AID
	SELECT * FROM TMASTER WHERE DATEDIFF(YY, DOT, GETDATE()) = @TENURE AND ACID = @AID
	SELECT TXNTYPE, COUNT(*) AS NoOftxns FROM TMASTER 
	WHERE DATEDIFF(YY, DOT, GETDATE()) = @TENURE AND ACID = @AID GROUP BY TXNTYPE

END

exec sp_GetTxnsYear  107,11

--------------------------------------------
Alter proc sp_GetTxnsYear
(
     @AID int,	
     @TENURE tinyint
)
As 
Begin 
      --check ACID
       If exists (select * from AMASTER where acid = @aid)
          Begin
			--print ‘customer number is valid’
			SELECT * FROM AMASTER WHERE ACID = @AID
			SELECT * FROM TMASTER WHERE DATEDIFF(YY, DOT, GETDATE()) = @TENURE AND ACID = @AID
			SELECT TXNTYPE, COUNT(*) AS NoOftxns FROM TMASTER 
			WHERE DATEDIFF(YY, DOT, GETDATE()) = @TENURE AND ACID = @AID GROUP BY TXNTYPE
          end
      else
		print 'customer number is invalid'
end

exec sp_GetTxnsYear  1001,11






