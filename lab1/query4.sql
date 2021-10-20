SELECT T.dayofweek,
    SUM(F.price) AS tot_income,
    AVG(SUM(F.price)) OVER (ORDER BY T.daydate
                            ROWS 2 PRECEDING) AS avg_3days_income
FROM FACTS F, TIMEDIM T
WHERE F.ID_time = T.ID_time AND T.datemonth LIKE '%JUL_03%'
GROUP BY T.dayofweek, T.daydate
ORDER BY T.daydate;