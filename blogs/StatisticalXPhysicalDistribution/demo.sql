USE tempdb
GO
----------------------------------------------------------------------
-- © Itzik Ben-Gan, SolidQ
-- For more, see 5-day Advanced T-SQL Course:
-- http://tsql.solidq.com/t-sql-courses/
----------------------------------------------------------------------

IF OBJECT_ID(N'dbo.GetNums', N'IF') IS NOT NULL DROP FUNCTION dbo.GetNums;
GO
CREATE FUNCTION dbo.GetNums(@low AS BIGINT, @high AS BIGINT) RETURNS TABLE
AS
RETURN
  WITH
    L0   AS (SELECT c FROM (SELECT 1 UNION ALL SELECT 1) AS D(c)),
    L1   AS (SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B),
    L2   AS (SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B),
    L3   AS (SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B),
    L4   AS (SELECT 1 AS c FROM L3 AS A CROSS JOIN L3 AS B),
    L5   AS (SELECT 1 AS c FROM L4 AS A CROSS JOIN L4 AS B),
    Nums AS (SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS rownum
             FROM L5)
  SELECT TOP(@high - @low + 1) @low + rownum - 1 AS n
  FROM Nums
  ORDER BY rownum;
GO
DROP TABLE IF EXISTS dbo.TableA
DROP TABLE IF EXISTS dbo.TableB
GO
CREATE TABLE dbo.TableA
(
    id INT IDENTITY(1,1),
	SomeOtherId NVARCHAR(50) NULL
)
CREATE TABLE dbo.TableB
(
    id INT IDENTITY(1,1),
	SomeOtherId NVARCHAR(50) NULL
)

INSERT dbo.TableA
(
    SomeOtherId
)
SELECT n FROM dbo.GetNums(1,500000)
GO
INSERT dbo.TableB
(
    SomeOtherId
)
SELECT n FROM dbo.GetNums(490001,500000)
GO
SELECT TOP 1 *
FROM dbo.TableA
    JOIN dbo.TableB
        ON TableB.SomeOtherId = TableA.SomeOtherId