# Google Data Analytics Capstone
A case study for Google Data Analytics Professional Certificate. Track 1: Bike-Share

# Deliverables
- [x] A clear statement of the business task
- [x] A description of all data sources used
- [x] Documentation of any cleaning or manipulation of data
- [x] A summary of your analysis
- [x] Supporting visualizations and key findings
- [ ] Your top three recommendations based on your analysis

# Table of content
- [Overview](#Overview)
    - [Introduction](#Introduction)
    - [Goal](#Goal)
    - [My Job](#My-job)
- [Analysis Process](#Analysis-Process)
    - [Ask](#Ask)
       - [Business Statement](#Business-Statement)
       - [Stakeholders](#Stakeholders)
    - [Prepare](#Prepare)
    - [Process](#Process)
       - [Data Cleaning](#Data-Cleaning)
    - [Analyze](#Analyze)
    - [Share](#Share)
    - [Act](#Act)
 

  
# Overview 
### Introduction
Cyclists is a fictional company launched in 2016, it has: 
- 5824 bicycles geo-tracked and locked into a network of 692 docking stations across Chicago.
- The bikes can be unlocked from one station and returned to any other station in the system at any time.
- Bike types: 
    - Standard two-wheeled bikes
    - Reclining bikes
    - Hand tricycles
    - Cargo bikes
- 8% of riders use the assistive options, and 92% use the Standard two-wheeled bikes.
- Users are more likely to ride for leisure, but 30% use them to commute to work every day.
- Pricing planes: 
   - single-ride passes "Casual rider"
   - full-day passes "Casual rider"
   - annual memberships > More Profitable 

### Goal
Maximize the number of Annual Memberships.
### My job
Understanding how casual riders & annual members use Cylistic bikes differently, enhances the chance of converting casual riders into annual members. 

# Analysis Process
## Ask
### The problem I'm trying to solve
 Understanding how casual riders differ from annual members to sway them to become members to increase future growth.
### How can my insights drive business decisions?
The findings and insights gained from analyzing how annual members and casual riders use Cylistic differently will assist the team in coming up with recommendations for growing the annual membership and thus, the company's profit. 

### Business Statement
Understanding the different behaviors of casual riders and annual members, to encourage casual riders to be members of the Cylistic. 
### Stakeholders: 
- The Director of Marketing (Lily Moreno)
- Marketing Analytics team
- Executive team

## Prepare
### Description of the used datasets
Source | [Cyclistic trip data](https://divvy-tripdata.s3.amazonaws.com/index.html)
| :--- | :---
Publisher | Motivate International Inc.
Dataset  | 202301-divvy-tripdata to 202312-divvy-tripdata
Timespan | Year 2023

Attribute name | Attribute Description | Example
| :--- | :--- | :--- 
ride_id | A unique ID for each ride | 9CA8DA324B4C8DFC
rideable_type | This attribute shows the bike type (electric_bike, classic_bike, docked_bike) | classic_bike
started_at | This attribute shows the start date and time of the ride | 28/06/2023  16:25:27 
ended_at | This attribute shows the end date and time of the ride | 21/06/2023  16:31:55 
start_station_name | This attribute shows the name of the start station | Sedgwick St & Huron St
start_station_id | This attribute shows the ID of the start station | TA1307000062
end_station_name | This attribute shows the name of the end station | Canal St & Monroe St
end_station_id | This attribute shows the ID of the end station | 13056
start_lat | This attribute shows the start latitude of the ride | 41.894666
start_lng | This attribute shows the start longitude of the ride | -87.638437
end_lat | This attribute shows the end latitude of the ride | 41.88169
end_lng | This attribute shows the end longitude of the ride | -87.63953
member_casual |This attribute shows the Member or Casual rider | member

## Process
### Tool
I'm using MySQL for this phase; because the dataset is too big to handle with spreadsheet software.
##### After downloading the datasets I imported them to my machine in MySQL, and then I created a new table called **cyclistic** containing the months of the year.
```
USE bike_share;

# Create a new table with bike usage data for the year 2023
DROP TABLE IF EXISTS cyclistic;
CREATE TABLE cyclistic AS 
(SELECT DISTINCT *
FROM january) 
UNION ALL
(SELECT DISTINCT *
FROM february)
UNION ALL
(SELECT DISTINCT *
FROM march)
UNION ALL
(SELECT DISTINCT *
FROM april)
UNION ALL
(SELECT DISTINCT *
FROM may)
UNION ALL
(SELECT DISTINCT *
FROM june)
UNION ALL
(SELECT DISTINCT *
FROM july)
UNION ALL
(SELECT DISTINCT *
FROM august)
UNION ALL
(SELECT DISTINCT *
FROM september)
UNION ALL
(SELECT DISTINCT *
FROM october)
UNION ALL
(SELECT DISTINCT *
FROM november)
UNION ALL
(SELECT DISTINCT *
FROM december)
```
### Data Cleaning 
- Dataset size -> 5,523,188 rows
- Adding additional attributes -> 1. Month, 2. Date, 3. Day of the Week, 4. hour, 5. Ride Length
 ```
  -- Add new attributes
ALTER TABLE cyclistic
ADD COLUMN month INT,
ADD COLUMN ride_date DATE,
ADD COLUMN day_of_week VARCHAR(20),
ADD COLUMN hour INT,
ADD COLUMN ride_length TIME;

-- Set values
UPDATE cyclistic
SET
    month = MONTH(started_at),
    ride_date = DATE(started_at),
    day_of_week = DAYNAME(started_at),
    hour = HOUR(started_at),
    ride_length = TIMEDIFF(ended_at, started_at);
  ```
-  Missing values -> 1,290,437 rows.
  To prevent losing data I created a new category for missing data as "Unknown"
  ```
-- Check for missing values   
SELECT
	*
FROM 
	cyclistic
WHERE
    start_station_id = "" OR
    start_station_name = "" OR
    end_station_id = ""  OR
    end_station_name = ""   ;
    
-- Fixing missing values by adding a new category as Unknown
UPDATE cyclistic
SET start_station_id = "Unknown"
WHERE start_station_id = "" ; 

UPDATE cyclistic
SET start_station_name = "Unknown"
WHERE start_station_name = "" ; 

 UPDATE cyclistic
SET end_station_id = "Unknown"
WHERE end_station_id = "" ; 

UPDATE cyclistic
SET end_station_name = "Unknown"
WHERE end_station_name = "" ; 

```
-  Duplicate -> No duplicates
-  Incorrect data -> 
After verifying that there were no missing entries in the ride ID, I looked at the station names and discovered that one was incorrect—Streeter Dr./Grand Ave.—and fixed it. Next, I verified that the location entries were proper. Then I executed some queries to check for incorrect ride length values. The first query is to examine the values of start and end dates, ride time, and duration. I also looked for the minimum, average, and maximum duration, when I saw that there were several zeros and negative values, I decided to remove them.
  ```
-- Checking for incorrect data 
SELECT LENGTH(ride_id)
From cyclistic
GROUP BY 1;

SELECT
DISTINCT start_station_name
From cyclistic
GROUP BY 1;

SELECT
DISTINCT end_station_name
From cyclistic
GROUP BY 1;

UPDATE cyclistic
SET end_station_name = 'Street Dr & Grand Ave'
WHERE end_station_name = 'Streeter Dr/Grand Ave'; -- 182 rows affected  

UPDATE cyclistic
SET start_station_name = 'Street Dr & Grand Ave'
WHERE start_station_name = 'Streeter Dr/Grand Ave'; -- 180 rows affected 

UPDATE cyclistic
SET end_station_name = 'Street Dr & Grand Ave'
WHERE end_station_name = 'Streeter Dr & Grand Ave'; -- 64379 rows affected  

UPDATE cyclistic
SET start_station_name = 'Street Dr & Grand Ave'
WHERE start_station_name = 'Streeter Dr & Grand Ave'; -- 61584 rows affected

-- Check for (latitude, longitude)
SELECT DISTINCT 
	start_station_name ,
	CONCAT(ROUND(start_lat,2), ", ",ROUND(start_lng,2)) AS start_location,
    end_station_name,
    CONCAT(ROUND(end_lat,2), ", " ,ROUND(end_lng,2)) AS end_location
FROM cyclistic;

-- Checking ride length 
SELECT 
    started_at,
    ended_at,
    ride_length,
    member_casual
  FROM
	cyclistic
ORDER BY  3 DESC;  

SELECT 
    TIME(MIN(ride_length)),
    CAST(AVG(ride_length) AS TIME),
    TIME(MAX(ride_length))
  FROM
	cyclistic;  
    
-- Deleting negative and zero values
DELETE FROM cyclistic
WHERE ride_length <= '00:00:00' ; -- 1243 row(s) affected
```

## Analyze
Analysis was done using SQL. You can see the analysis result [here](RideData_analysis.sql)

## Share
### 1. Rider's Behavior on Weekdays vs Weekends:
[Viz link](https://public.tableau.com/views/UserBehavioronWeekendsandWeekdays/Dashboard2?:language=en-US&:sid=&:display_count=n&:origin=viz_share_link)
#### key findings:
**Weekdays**
- Member
	* The top start station form member is (Clark St & Elm St), where the end station (Kingsbury St & Kinzie St) represents 15,982 and 18,140 rides.
	* **Clark St & Elm St** and **Kingsbury St & Kinzie St** stations have the highest number of rides in September 2,704 and 3,008 whereas the lowest total rides are in February with 697 and 850, respectively.
	* Member favorite hours for a bike are between 4:00 pm / 5:00 pm.
- Casual 
	* The top start and end stations for casual are (Street Dr & Grand Ave) representing 25,145 and 28,482 rides.
	* **Street Dr & Grand Ave** station has the highest number of rides in **July** 5,073 and 5,553; the lowest total rides are in January by 226 and 256, respectively.
	* Casual favorite hours for a bike are between 1:00 pm / 5:00 pm.

* Favorite bike types for members are Classic and Electric bikes respectively whereas for casuals Electric, Classic, and Docked bikes respectively.
* Riders use bike share bikes on weekdays more than on weekends by approximately 171.81% for members and 83.60% for casuals.

### 2. Rider's Behavior on Special Holidays:
[Viz link](https://public.tableau.com/views/SpecialHolidaysAnalysis/Dashboard1?:language=en-US&:sid=&:display_count=n&:origin=viz_share_link)
#### key findings:
- Valentine's Day
	* The Total rides were 7,271 for members, where 53.33% was for Classic bikes, and
	* The peak hours were from 4 pm to 5 pm with 857 and 888 as total rides, there was a slight increase in the number of rides from 7 AM to 8 AM, whereas in the early morning, there was a significant drop reaching a low of 3 rides at 3 AM.
	* The Total rides were 1837 for casuals, where **Electric bikes** accounted for 61% of all bike usage, significantly higher than the traditional bikes.
 
## Act
