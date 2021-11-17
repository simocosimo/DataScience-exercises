--define the query needed to complete the definition of materialized view VM1
(SELECT Type As ServiceType, GeographicArea AS GeographicAreaBranch, Semester,
SUM(Income) AS TotIncome, SUM(#Consultancies) AS TotNumConsultancies
FROM INCOME I, SERVICE S, TIME T, CONSULTANTS_BRANCH SC
WHERE S.ServiceID = I.ServiceID AND SC.BranchID = I.BranchID AND T.TimeID = I.TimeID
GROUP BY Type, GeographicArea, Semester);