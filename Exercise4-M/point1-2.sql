--write triggers to propagate the update of type of service into the mat view
CREATE TRIGGER UpdateTypeOfService
AFTER UPDATE OF Type ON SERVICE
FOR EACH ROW    --I want the trigger to run for every touple modified
DECLARE
N number;
BEGIN

--check if there is at least one record associated with the previous value of service type
SELECT COUNT(*) INTO N 
FROM VM1
WHERE ServiceType = :OLD.Type

IF(N > 0) THEN
--update the records associated with the previous value of service type
UPDATE VM1
SET ServiceType = :NEW.Type
WHERE ServiceType = :OLD.Type;
