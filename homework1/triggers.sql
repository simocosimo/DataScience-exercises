CREATE TRIGGER InsertNewSale
AFTER INSERT ON SALES
FOR EACH ROW
DECLARE
N number;
TicketTypeVar VARCHAR(20);
DateMonthVar VARCHAR(20);

BEGIN

SELECT TICKET_TYPE INTO TicketType
FROM SALES
WHERE TICKET_TYPE = :NEW.TICKET_TYPE;

SELECT DATEMONTH INTO DateMonth
FROM TIMEDIM
WHERE TIME_ID = :NEW.TIME_ID;

SELECT COUNT(*) INTO N
FROM VM1
WHERE TicketType = TicketTypeVar AND DateMonth = DateMonthVar;

IF(N > 0) THEN
--update the record
    UPDATE VM1
    SET TotPrice = TotPrice + :NEW.PRICE,
        TotTickets = TotTickets + :NEW.N_TICKET
    WHERE TicketType = TicketTypeVar
    AND DateMonth = DateMonthVar;

ELSE
--insert a new record
    INSERT INTO VM1(TicketType, DateMonth, TotPrice, TotTickets) 
    VALUES (TicketTypeVar, DateMonthVar, :NEW.PRICE, :NEW.N_TICKET);

END IF;
END;