SELECT L.region, T.datemonth,
    SUM(F.numberofcalls) AS monthly_calls,
    SUM(SUM(F.numberofcalls)) OVER (PARTITION BY L.region, T.dateyear
                                    ORDER BY T.datemonth
                                    ROWS UNBOUNDED PRECEDING) AS cumulative_monthly_calls
FROM FACTS F, TIMEDIM T, LOCATION L
WHERE F.ID_time = T.ID_time AND F.ID_location_caller = L.ID_location
GROUP BY L.region, T.datemonth, T.dateyear;