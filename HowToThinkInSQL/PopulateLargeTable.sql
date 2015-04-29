use AdventureWorks2014
go

SET NOCOUNT ON
insert BigStrings (value) SELECT value FROM BigStrings
DECLARE @count int
SELECT @count=count(*) from bigstrings
DECLARE @countmsg nvarchar(1024)
SET @countmsg = N'Inserted ' + convert(nvarchar,@count) + ' records'
RAISERROR(@countmsg,10,1) WITH NOWAIT
go 


--Load 500 million rows in BigStrings

DECLARE @S varchar(6000);
SET @S = '6000-character-long string here';

-- nasty, slow table scan:
SELECT * FROM BigStrings WHERE Value = @S

-- super fast nonclustered seek followed by very fast clustered index range seek:
SELECT * FROM BigStrings WHERE Value = @S AND Chk = CHECKSUM(@S)