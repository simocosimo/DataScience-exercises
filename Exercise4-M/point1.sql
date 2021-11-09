-- Filling the schemda designed mat view VM1 by using a SELECT statement to get data from existing tables
INSERT INTO VM1 (ServiceType, GeographicalAreaBranch, Semester, TotIncome, TotNumConsultancies)
    (SELECT Type, GeographicalArea, Semester, SUM(Income), SUM(#Consultancies)
    FROM INCOME I, SERVICE S, TIME T, CONSULTANS_BRANCH SC
    WHERE S.ServiceID = I.ServiceID AND SC.BranchID = I.BranchID AND T.TimeID = I.TimeID
    GROUP BY Type, GeographicalArea, Semester);