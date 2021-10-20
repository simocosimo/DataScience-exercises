SELECT T.DateMonth,
    SUM(F.numberofcalls) AS calls_a_month,
    SUM(F.price) AS income_a_month,
    RANK() OVER (ORDER BY SUM(F.price) DESC) AS month_income_rank
FROM FACTS F, TIMEDIM T
WHERE F.ID_time = T.ID_time
GROUP BY T.DateMonth;