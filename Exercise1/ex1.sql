-- Convention: using year in every field
-- WE USE THIS RIGHT HERE
-- TIME(1, 10/2021, 4/2021, 2/2021, 2021)

/* 
-- this is another example of memorizing time, coming out from the ETL process
TIME(TimeID, Month, M_O_Y)
(1, 10/2021, 'October') */

-- Query #1
SELECT CategoryName, 
    SUM(TotAmount),
    SUM(NumSoldItems),
    RANK() OVER (ORDER BY SUM(TotAmount) DESC) Rank_TotAmount,
    RANK() OVER (ORDER BY SUM(NumSoldItems) DESC) Rank_SoldItems,
FROM Sales S, Category C
WHERE S.ItemCategoryID = C.CategoryID -- joins = n-1 (where n number of tables)
-- filter conditions should go here (none in this example)
GROUP BY CategoryName, CategoryID
ORDER BY Rank_SoldItems
-- I can only use, in the select, attributes that are not present in the group by. I can 
-- only do that by using aggregation functions (SUM, AVG, RANK, etc...)


-- Query #2
SELECT Province, Region,
    SUM(TotAmount),
    -- The partition attribute NEEDS to be in the GROUP BY clause
    RANK() OVER (PARTITION BY Region
                    ORDER BY SUM(TotAmount) DESC)
FROM Sales S, Customer C
WHERE S.CustomerID = C.CustomerID
-- filter conditions should go here (none in this example)
GROUP BY Province, Region   
-- I need the Region clause, otherwise I can't put it in the select