--Query #1
SELECT ServiceType, 6M,
    SUM(Income), SUM(#Consulting)
FROM INCOME I, SERVICE S, TIME T, LOCATION L
WHERE I.SID = S.SID AND I.TID = T.TID AND I.LID = L.LID
    AND REGION = "Lombardy"
GROUP BY ServiceType, 6M;

--Query #2
SELECT Region, Service, year,
    SUM(Income), SUM(#Consulting)
FROM INCOME I, SERVICE S, TIME T, LOCATION L, COMPANY C
WHERE I.SID = S.SID AND I.TID = T.TID AND I.LID = L.LID AND I.CID = C.CID
    AND (NATIONALITY = "Italian" OR NATIONALITY = "German")
GROUP BY Region, Service, year;

--Query #3
SELECT ServiceCategory, Nationality, 6M,
    SUM(Income),
    SUM(Income) / SUM(#Consulting)
FROM INCOME I, SERVICE S, TIME T, COMPANY C
WHERE I.SID = S.SID AND I.TID = T.TID AND I.CID = C.CID
    AND year >= 2017 AND year <= 2019
GROUP BY ServiceCategory, Nationality, 6M;


--Materialized view
SELECT 6M, year, Service, ServiceType, ServiceCategory, Region, Nationality,
SUM(Income),
SUM(#Consulting)
FROM INCOME I, SERVICE S, TIME T, COMPANY C, LOCATION L
WHERE I.SID = S.SID AND I.TID = T.TID AND I.LID = L.LID AND I.CID = C.CID
GROUP BY 6M, year, Service, ServiceType, ServiceCategory, Region, Nationality;

--Estimation of mat view size
-- 2 * 10 = 10year * 2 (cause we consider 6Ms)
MV      -> (2*10)*100*10*5 = 10^5
FACT    -> 90*100*200*365*10 = 657*10^7