--write triggers to propagate to vm1 the changes due to the insertion of a new record in the INCOME fact table
CREATE TRIGGER InsertNewServiceType
AFTER INSERT ON INCOME
FOR EACH ROW
DECLARE
N number;
TypeServiceVar VARCHAR(20);
GeographicalAreaBranchVar VARCHAR(20);
SemesterVar VARCHAR(20);

BEGIN
--check if there is a record in vm1 to be updated. in this record the values of attributes ServiceType,
--GeographicalAreaBranch and Semester, are related to the values of NEW.ServiceIS, NEW.IdSede, NEW.TimeId in the 
--new record inserted in the INCOME table.

--read the corresponding values in the different dimensional tables
SELECT Type INTO ServiceTypeVar
FROM SERVICE
WHERE ServiceID = :NEW.ServiceID

SELECT GeographicalArea INTO GeographicalAreaBranchVar
FROM CONSULTANS_BRANCH
WHERE BranchID = :NEW.BranchID

SELECT Semester INTO SemesterVar
FROM TIME
WHERE TimeID = :NEW.TimeID

SELECT COUNT(*) INTO NEW
FROM VM1
WHERE ServiceType = ServiceTypeVar AND GeographicalAreaBranch = GeographicalAreaBranchVar
    AND Semester = SemesterVar

IF (N > 0) THEN
    UPDATE VM1
    SET TotIncome = TotIncome + :NEW.Income
        TotNumConsultancies = TotNumConsultancies + :NEW.#Consultancies
    WHERE ServiceType = ServiceTypeVar AND GeographicalAreaBranch = GeographicalAreaBranchVar
        AND Semester = SemesterVar
ELSE
    INSERT INTO VM1(ServiceType, GeographicalAreaBranch, Semester, TotIncome, TotNumConsultancies)
    VALUES(ServiceTypeVar, GeographicalAreaBranchVar, SemesterVar, :NEW.Income, :NEW.#Consultancies);

END IF;
END;