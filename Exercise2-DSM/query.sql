--Query #1
SELECT T.year, E.Package,
    SUM(E.tot_income)/SUM(e.tot_liters),
    100*SUM(E.tot_liters)/SUM(SUM(E.tot_liters)) OVER (PARTITION BY E.Package),
    SUM(SUM(E.tot_liters)) OVER (PARTITION BY E.Package,
                            ORDER BY T.year
                            ROWS UNBOUNDED PRECEDING),
FROM EXPORT E, DESTINATION D, TIMEDIM T, WINETYPE W
WHERE E.DID = D.DID AND E.TID = T.TID AND E.WTID = W.WTID
    AND D.Continent = "Asia" AND W.DOC = True
GROUP BY T.year, E.Package;