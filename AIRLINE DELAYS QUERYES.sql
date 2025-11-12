USE [Airline Delay]
SELECT * FROM Cleaned_flights$

---MetaData--
/*
year: The year of the data.
month: The month of the data.
carrier: Carrier code.
carrier_name: Carrier name.
airport: Airport code.
airport_name: Airport name.
arr_flights: Number of arriving flights.
arr_del15: Number of flights delayed by 15 minutes or more.
carrier_ct: Carrier count (delay due to the carrier).
weather_ct: Weather count (delay due to weather).
nas_ct: NAS (National Airspace System) count (delay due to the NAS).
security_ct: Security count (delay due to security).
late_aircraft_ct: Late aircraft count (delay due to late aircraft arrival).
arr_cancelled: Number of flights canceled.
arr_diverted: Number of flights diverted.
arr_delay: Total arrival delay.
carrier_delay: Delay attributed to the carrier.
weather_delay: Delay attributed to weather.
nas_delay: Delay attributed to the NAS.
security_delay: Delay attributed to security.
late_aircraft_delay: Delay attributed to late aircraft arrival.
*/

---Basic aggregations and filtering 
--------QUESTIONS---------------------
--1. Why do certain carriers have more delayed flights than others?
SELECT TOP 5
	carrier_name,
	ROUND(SUM(carrier_ct),0) AS NumberOfCarrierDelays,
	ROUND(100 * SUM(carrier_ct)/SUM(SUM(carrier_ct)) OVER() ,0) AS PercentageOfTotalDelays
FROM Cleaned_flights$
	GROUP BY carrier_name
	ORDER BY NumberOfCarrierDelays DESC

--finding why ?
SELECT TOP 5 
		carrier_name,
		ROUND(AVG(carrier_delay),0) CarrDelay,
		ROUND(AVG(weather_delay),0) WeathDelay,
		ROUND(AVG(nas_delay),0) NasDelay,
		ROUND(AVG(security_delay),0) SecDelay,
		ROUND(AVG(late_aircraft_delay),0) LateAirDelay
FROM Cleaned_flights$
	GROUP BY carrier_name
ORDER BY  CarrDelay DESC

-----2. Why are certain airports experiencing higher delays?
SELECT TOP 5	airport_name,
		ROUND(AVG(arr_del15),0) FlightsDelayed15mins
FROM Cleaned_flights$
GROUP BY airport_name
ORDER BY FlightsDelayed15mins DESC
-- what is the cause ?
SELECT  TOP 5
		airport_name,
		ROUND(AVG(carrier_delay),0) CarrDelay,
		ROUND(AVG(weather_delay),0) WeathDelay,
		ROUND(AVG(nas_delay),0) NasDelay,
		ROUND(AVG(security_delay),0) SecDelay,
		ROUND(AVG(late_aircraft_delay),0) LateAirDelay
FROM Cleaned_flights$
GROUP BY airport_name
ORDER BY  CarrDelay DESC

--3. Why did weather delay spikes in certain months?
SELECT airport_name,
FORMAT(DATEFROMPARTS(1900, month, 1), 'MMMM', 'en-US') AS MonthName,
SUM(weather_ct) TotalWeatherDelays  
FROM Cleaned_flights$
GROUP BY airport_name,month
ORDER BY TotalWeatherDelays DESC

---The reason why july has more number of delays 
SELECT 
		SUM(carrier_delay) CarrDelay,
		SUM(weather_delay) WeathDelay,
		SUM(nas_delay) NasDelay,
		SUM(security_delay) SecDelay,
		SUM(late_aircraft_delay) LateAirDelay
FROM Cleaned_flights$
WHERE month = 7

---- comparing the delays with other years

WITH Delayed AS(
SELECT	year,
		SUM(carrier_delay) CarrDelay,
		SUM(weather_delay) WeathDelay,
		SUM(nas_delay) NasDelay,
		SUM(security_delay) SecDelay,
		SUM(late_aircraft_delay) LateAirDelay
FROM Cleaned_flights$
GROUP BY year
)
SELECT 
	Year,
	CarrDelay,
	WeathDelay,
	NasDelay,
	SecDelay,
	LateAirDelay
FROM Delayed
ORDER BY Year

---4. Why do certain careers have longer delay durations even with fever flights ?
SELECT	carrier_name,
		ROUND(AVG(carrier_delay),0) as delay_duration
FROM Cleaned_flights$
	GROUP BY carrier_name
	ORDER BY delay_duration DESC
---------------------------------------------
--==================================-----------
---------TIME SERIES ANLAYSIS ----------------
--==================================--------------
--5. what are the carriers that shows highest delays over time?
WITH RankedCarriers AS (
SELECT 
	year, 
	carrier_name,
	ROUND(AVG(carrier_delay),0) DelayCarrier,
	ROW_NUMBER() OVER (PARTITION BY year ORDER BY ROUND(AVG(carrier_delay),0)  DESC) RankedCarriersBasedOnDelay
FROM Cleaned_flights$
GROUP BY year,carrier_name
)
SELECT   year,
	   carrier_name,
	   DelayCarrier,
	   RankedCarriersBasedOnDelay
FROM RankedCarriers
WHERE RankedCarriersBasedOnDelay IN (1,2,3,4,5)

---6. Which months consistently shows the highest delay percentages  over multiple years?
SELECT
    year,
	FORMAT(DATEFROMPARTS(1900, month, 1), 'MMMM', 'en-US') AS MonthName,
    ROUND(
        100.0 * SUM(arr_del15) / NULLIF(SUM(arr_flights), 0),
        2
    ) AS DelayPercentage
FROM Cleaned_flights$
GROUP BY year, FORMAT(DATEFROMPARTS(1900, month, 1), 'MMMM', 'en-US')
ORDER BY year, FORMAT(DATEFROMPARTS(1900, month, 1), 'MMMM', 'en-US');



---7. Identifying seasonality--------do certain months show consistent spikes in weather  delays?
SELECT 
	FORMAT(DATEFROMPARTS(1900, month, 1), 'MMMM', 'en-US') AS MonthName, 
	ROUND(SUM(weather_ct),0) as TotalWeatherDelayFlights
FROM Cleaned_flights$
	GROUP BY FORMAT(DATEFROMPARTS(1900, month, 1), 'MMMM', 'en-US')
	ORDER BY TotalWeatherDelayFlights DESC

--8. Which month and year have highest number of delayed flights?
SELECT year, 
	   FORMAT(DATEFROMPARTS(1900, month, 1), 'MMMM', 'en-US') MonthName, 
	   SUM(arr_del15) Highest_Number_Of_DelayedFlights
FROM Cleaned_flights$
GROUP BY year,FORMAT(DATEFROMPARTS(1900, month, 1), 'MMMM', 'en-US')
ORDER BY Highest_Number_Of_DelayedFlights DESC
---9. which airlines or carriers has most total flights and most delays?
SELECT carrier_name,
	   SUM(arr_flights) TotalFlights,
	   SUM(arr_del15) TotalDelays
FROM Cleaned_flights$
GROUP BY carrier_name
ORDER BY TotalDelays DESC
----10. How many flights are cancelled ?
SELECT 
	carrier_name,
	SUM(arr_cancelled) CancelledFlights
FROM Cleaned_flights$
GROUP BY carrier_name
ORDER BY CancelledFlights DESC
---11. How many flights were diverted?
SELECT 
	carrier_name,
	SUM(arr_diverted) Diverted_flights
FROM Cleaned_flights$
GROUP BY carrier_name
ORDER BY Diverted_flights DESC

--12. Find the top 10 (Carrier + airport) combinations with the worst on time performance
SELECT TOP 10
    carrier_name,
    airport_name,
    SUM(arr_flights) AS TotalFlights,
    SUM(arr_del15) AS DelayedFlights,
    ROUND(100.0 * SUM(arr_del15) / NULLIF(SUM(arr_flights), 0), 2) AS DelayPercentage
FROM Cleaned_flights$
GROUP BY carrier_name, airport_name
HAVING SUM(arr_flights) > 20
ORDER BY DelayPercentage DESC;




--13. what is the totoal economic impact of delays if each minute of delay costs 100$?
SELECT carrier_name,
	SUM(arr_delay)*100 AS EstimatedCost
FROM Cleaned_flights$
GROUP BY carrier_name
ORDER BY EstimatedCost DESC

---14. Finding dominanat delay causes per carrier
WITH DelayCause AS(
SELECT 
	carrier_name,
	CASE 
		WHEN SUM(weather_delay) = GREATEST(SUM(weather_delay), SUM(carrier_delay), SUM(nas_delay), SUM(late_aircraft_delay),SUM(security_delay))
		THEN 'Weather Delay'
		WHEN SUM(carrier_delay) = GREATEST(SUM(weather_delay), SUM(carrier_delay), SUM(nas_delay), SUM(late_aircraft_delay),SUM(security_delay))
		THEN 'Carrier Delay'
		WHEN SUM(late_aircraft_delay) = GREATEST(SUM(weather_delay), SUM(carrier_delay), SUM(nas_delay), SUM(late_aircraft_delay),SUM(security_delay))
		THEN 'Late Aircraft Delay'
		WHEN SUM(security_delay) = GREATEST(SUM(weather_delay), SUM(carrier_delay), SUM(nas_delay), SUM(late_aircraft_delay),SUM(security_delay))
		THEN 'Security Delay'
		ELSE 
			'NAS Delay'
	END AS DominantDelayCause
FROM Cleaned_flights$
GROUP BY carrier_name
) 
SELECT DominantDelayCause,
	COUNT(*) AS NumberOfCarriers
FROM DelayCause
GROUP BY DominantDelayCause
ORDER BY NumberOfCarriers DESC


----15. Total Flights 
SELECT  SUM(arr_flights)  TotalFlights FROM Cleaned_flights$
----16. Total Delay Flights
SELECT  SUM(arr_del15)  TotalDelayedFlights FROM Cleaned_flights$

----17.Delay Percentage
SELECT ROUND(100*SUM(arr_del15)/SUM(arr_flights),1)
DelayPercentage FROM Cleaned_flights$




