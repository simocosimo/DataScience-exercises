SELECT p.phoneratetype, t.dateyear, 
    SUM(f.price) AS yearly_rate_income,   --TOTAL PRICE FOR EACH RATE AND YEAR
    SUM(SUM(f.price)) OVER (PARTITION BY p.phoneratetype) AS rate_income,   --TOTAL INCOME PER RATE
    SUM(SUM(f.price)) OVER (PARTITION BY t.dateyear) AS yearly_income,   --TOTAL INCOME PER YEAR
    SUM(SUM(f.price)) OVER () AS total_income   --TOTAL INCOME
FROM FACTS F, TIMEDIM T, PHONERATE P
WHERE F.ID_time = T.ID_time AND F.ID_phoneRate = P.ID_phoneRate
GROUP BY p.phoneratetype, t.dateyear
ORDER BY p.phoneratetype;