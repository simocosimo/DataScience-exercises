--DIMENSIONS
TIMEDIM (_TID_, Month, 2M, 3M, 6M, year)
WINERY (_WID_, Province, Region, Geo_area)
DESTINATION(_DID_, Country, Continent)
WINE_TYPE(_WTID_, Wine, DOC, DOP, DOCG)

--JUNK DIMENSIONS (TO BE PUSHED DOWN)
-- PACKAGE(_PID_, Package)
-- SIZE(_SID_, Size)

--FACT TABLE
EXPORT(_TID_, _WID_, _DID_, _WTID_, _Package_, _Size_, tot_income, tot_liters)