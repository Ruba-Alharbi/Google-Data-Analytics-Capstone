USE bike_share;

-- Total ride for each user type
SELECT
	member_casual,
    COUNT(ride_id) AS total_rides
FROM
	cyclistic
GROUP BY member_casual ;  

-- Average ride duration for each user type
 SELECT
	member_casual,
    TIME(AVG(ride_length)) average_ride_duration
FROM
	cyclistic
GROUP BY member_casual ; 

-- Investegate ride length
SELECT Count(ride_id) AS total_ride, ride_length
FROM cyclistic
GROUP BY 2
ORDER BY 2 ;
-- WHERE ride_length <= '00:01:00';

-- Most Active Months or Days
SELECT
    member_casual,
    month AS active_month,
    day_of_week AS active_day,
    COUNT(ride_id) AS total_rides
FROM
    cyclistic
GROUP BY
    member_casual,
    active_month,
    active_day
ORDER BY
    total_rides DESC;
    
-- Most Active Hour
SELECT
    member_casual,
    hour AS ride_hour,
    COUNT(ride_id) AS total_rides
FROM
    cyclistic
GROUP BY
    member_casual,
    ride_hour
ORDER BY
   total_rides DESC,
   member_casual,
   ride_hour;
   
-- Most popular start and end station for riders 
-- Start stations
SELECT
	start_station_name,
    COUNT(ride_id) total_rides
FROM
	cyclistic
WHERE 
	start_station_name <> 'Unknown'    
GROUP BY
	start_station_name
ORDER BY
	total_rides DESC
LIMIT
	5;
-- End stations
SELECT
	end_station_name,
    COUNT(ride_id) total_rides
FROM
	cyclistic
WHERE 
	end_station_name <> 'Unknown'    
GROUP BY
	end_station_name
ORDER BY
	total_rides DESC
LIMIT
	5;

-- Total rides on weekend VS. weekday
 SELECT
	CASE 
		WHEN day_of_week = 'Friday' OR day_of_week = 'Saturday' THEN 'Weekend'
        ELSE 'Weekday'
	END AS weekend_weekday,
    month,
    member_casual,
    COUNT(ride_id) total_rides
FROM
	cyclistic
GROUP BY
	weekend_weekday,
    month,
    member_casual;    

 -- Users' behavior on the weekend VS weekday
SELECT
	DISTINCT CASE 
		WHEN day_of_week = 'Friday' OR day_of_week = 'Saturday' THEN 'Weekend'
		ELSE 'Weekday'
	END AS weekend_weekday,
    member_casual,
    month,
    hour,
    rideable_type,
	ride_length,
    start_station_name,
    end_station_name,
    COUNT(ride_id) total_rides
FROM
	cyclistic
WHERE
    start_station_name <> 'Unknown' AND
    end_station_name <> 'Unknown' AND
    ride_length >= '00:01:00'
GROUP BY
	1,2,3,4,5,6,7,8
ORDER BY
	1,
    4 DESC;     
    
-- √ Special Holidays > Valentines's Day, Easter Sunday, Independence Day, Labor Day, Halloween, Thanksgiving, Christmas
SELECT
	COUNT(ride_id) AS total_ride,
	CASE
		WHEN ride_date  = '2023-02-14' THEN "Valentine's Day" 
		WHEN ride_date  = '2023-04-09' THEN 'Ester Sunday'
		WHEN ride_date  = '2023-07-04' THEN 'Independence Day'
		WHEN ride_date  = '2023-09-04' THEN 'Labor Day'
		WHEN ride_date  = '2023-10-31' THEN 'Halloween'
		WHEN ride_date  = '2023-11-23' THEN 'Thanksgiving'
		WHEN ride_date  = '2023-12-25' THEN 'Christmas'
	ELSE ''
	END AS special_days,
	member_casual,
	rideable_type,
	hour,
	ride_date,
	day_of_week,
	ride_length
FROM 
	cyclistic   
GROUP BY 
	2,3,4,5,6,7,8
HAVING 
	special_days != ''; 

-- √ Seasonal Activities in bike ride
SELECT
	member_casual,
    case 
		WHEN month IN (12, 1, 2) THEN 'Winter'
        WHEN month IN (3, 4, 5) THEN 'Spring'
        WHEN month IN (6, 7, 8) THEN 'Summer'
        ELSE 'Fall'
	END season,
    day_of_week,
    hour,
    count(ride_id) total_ride
FROM
	cyclistic
GROUP BY
	member_casual,
    season,
    day_of_week,
    hour
ORDER BY   
	member_casual,
    season,
    day_of_week,
    hour;
