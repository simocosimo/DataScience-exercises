CREATE TRIGGER InsertNewSale
AFTER INSERT ON SALES
FOR EACH ROW
DECLARE
N number;
TicketTypeVar VARCHAR(20);
DateMonthVar VARCHAR(20);
DateYearVar INTEGER;

BEGIN

SELECT TICKET_TYPE INTO TicketTypeVar
FROM SALES
WHERE TIME_ID = :NEW.TIME_ID AND MUSEUM_ID = :NEW.MUSEUM_ID;

SELECT DATEMONTH, DATEYEAR INTO DateMonthVar, DateYearVar
FROM TIMEDIM
WHERE TIME_ID = :NEW.TIME_ID;

SELECT COUNT(*) INTO N
FROM VM1
WHERE TicketType = TicketTypeVar AND DateMonth = DateMonthVar AND DateYear = DateYearVar;

IF(N > 0) THEN
--update the record
    UPDATE VM1
    SET TotPrice = TotPrice + :NEW.PRICE,
        TotTickets = TotTickets + :NEW.N_TICKET
    WHERE TicketType = TicketTypeVar
    AND DateMonth = DateMonthVar
    AND DateYear = DateYearVar;

ELSE
--insert a new record
    INSERT INTO VM1(TicketType, DateMonth, DateYear, TotPrice, TotTickets) 
    VALUES (TicketTypeVar, DateMonthVar, DateYearVar, :NEW.PRICE, :NEW.N_TICKET);

END IF;
END;