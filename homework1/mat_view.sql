--common query 1
SELECT S.TICKET_TYPE, T.DATEMONTH,
    SUM(S.PRICE) / COUNT(DISTINCT T.DATE)
FROM SALES S, TIMEDIM T
WHERE S.TIME_ID = T.TIME_ID 
GROUP BY S.TICKET_TYPE, T.DATEMONTH;

--common query 2
SELECT S.TICKET_TYPE, T.DATEMONTH,
    SUM(SUM(S.PRICE)) OVER (PARTITION BY T.DATEYEAR)
FROM SALES S, TIMEDIM T
WHERE S.TIME_ID = T.TIME_ID 
GROUP BY S.TICKET_TYPE, T.DATEMONTH, T.DATEYEAR;

--common query 3
SELECT S.TICKET_TYPE, T.DATEMONTH,
    SUM(S.N_TICKET),
    SUM(S.PRICE),
    --TODO: doubts on below, to ask
    SUM(S.PRICE) / SUM(S.N_TICKET)
FROM SALES S, TIMEDIM T
WHERE S.TIME_ID = T.TIME_ID 
GROUP BY S.TICKET_TYPE, T.DATEMONTH;

--common query 4
SELECT S.TICKET_TYPE, T.DATEMONTH,
    SUM(S.N_TICKET),
    SUM(S.PRICE),
    --TODO: doubts on below, to ask
    SUM(S.PRICE) / SUM(S.N_TICKET)
FROM SALES S, TIMEDIM T
WHERE S.TIME_ID = T.TIME_ID AND T.DATEYEAR = 2021
GROUP BY S.TICKET_TYPE, T.DATEMONTH;

--common query 5
SELECT S.TICKET_TYPE, T.DATEMONTH,
    SUM(S.N_TICKET) / SUM(SUM((S.N_TICKET)) OVER (PARTITION BY T.DATEMONTH)
FROM SALES S, TIMEDIM T
WHERE S.TIME_ID = T.TIME_ID 
GROUP BY S.TICKET_TYPE, T.DATEMONTH;

--mat view
CREATE MATERIALIZED VIEW
BUILD IMMIDIATE
REFRESH FAST ON DEMAND
ENABLE QUERY REWRITE
AS (
    SELECT S.TICKET_TYPE, T.DATEMONTH, T.DATEYEAR
        SUM(S.PRICE),
        SUM(S.N_TICKET)
    FROM SALES S, TIMEDIM T
    WHERE S.TIME_ID = T.TIME_ID
    GROUP BY S.TICKET_TYPE, T.DATEMONTH, T.DATEYEAR
);

--logs
CREATE MATERIALIZED VIEW LOG ON SALES
WITH SEQUENCE, ROWID
(TIME_ID, TICKET_TYPE, PRICE, N_TICKET)
INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON TIMEDIM
WITH SEQUENCE, ROWID
(TIME_ID, DATEMONTH, DATEYEAR)
INCLUDING NEW VALUES;

--mat view by schema
CREATE TABLE VM1 (
    TicketType VARCHAR(20),
    DateMonth VARCHAR(20),
    DateYear INTEGER,
    TotPrice INTEGER CHECK (TotPrice IS NOT NULL AND TotPrice > 0),
    TotTickets INTEGER CHECK (TotTickets IS NOT NULL AND TotTickets > 0),
    PRIMARY KEY (TicketType, DateMonth)
);

--filling query example
INSERT INTO VM1 (TicketType, DateMonth, TotPrice, TotTickets) 
VALUES (
    SELECT S.TICKET_TYPE, T.DATEMONTH, T.DATEYEAR
        SUM(S.PRICE),
        SUM(S.N_TICKET)
    FROM SALES S, TIMEDIM T
    WHERE S.TIME_ID = T.TIME_ID
    GROUP BY S.TICKET_TYPE, T.DATEMONTH, T.DATEYEAR
)