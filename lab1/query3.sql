SELECT T.DateMonth,
    SUM(F.numberofcalls) AS tot_monthly_calls,
    RANK() OVER (ORDER BY SUM(F.numberofcalls) DESC) AS month_income_rank
FROM FACTS F, TIMEDIM T
WHERE F.ID_time = T.ID_time AND T.dateyear = 2003
GROUP BY T.DateMonth;