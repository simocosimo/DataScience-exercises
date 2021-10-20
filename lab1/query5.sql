SELECT T.dateyear, T.datemonth,
    SUM(F.price) AS tot_monthly_income,
    SUM(SUM(F.price)) OVER (PARTITION BY T.dateyear
                            ORDER BY T.datemonth
                            ROWS UNBOUNDED PRECEDING) AS cumulative_monthly_income
FROM FACTS F, TIMEDIM T
WHERE F.ID_time = T.ID_time
GROUP BY T.dateyear, T.datemonth;