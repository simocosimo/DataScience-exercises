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

--Query #2 (1)
SELECT T.year, DISTINCT W.Region,
    SUM(SUM(E.tot_income)) OVER (PARTITION BY W.Region, T.year)/
    SUM(SUM(E.tot_liters)) OVER (PARTITION BY W.Region, T.year),
    AVG(SUM(E.tot_liters)) OVER (PARTITION BY W.Region, T.year),
    --didn't quite get the one below, TODO: asks prof
    100 * SUM(SUM(E.tot_liters)) OVER (PARTITION BY W.Region, T.year)/
    SUM(SUM(E.tot_liters)) OVER (PARTITION BY W.Geo_area, T.year)
FROM EXPORT E, TIMEDIM T, WINERY W
WHERE E.WID = W.WID AND E.TID = T.TID
GROUP BY T.year, W.Region, W.Geo_area, W.Province;

--Query #2 (2)
SELECT T.year, W.Region,
    SUM(E.tot_income) / SUM(E.tot_liters),
    SUM(E.tot_liters) / COUNT(DISTINCT W.Province),
    100 * SUM(E.tot_liters) /
    SUM(SUM(E.tot_liters)) OVER (PARTITION BY W.Geo_area, T.year)
FROM EXPORT E, TIMEDIM T, WINERY W
WHERE E.WID = W.WID AND E.TID = T.TID
GROUP BY T.year, W.Region, W.Geo_area;