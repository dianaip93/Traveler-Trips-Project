-- Exploratory Data Analysis
-- In this section I’ll add some of the queries used to explore data and come up with key findings

-- Date Ranges of Trips
SELECT MIN(start_date), 
MAX(end_date)
FROM traveler_trip;


-- Most traveled city overall 
SELECT destination_city, 
COUNT(destination_city) AS num_visits
FROM traveler_trip
WHERE destination_city != 'Unknown'
GROUP BY destination_city
ORDER BY num_visits DESC;


-- Most traveled country overall
SELECT destination_country, 
COUNT(destination_country) AS num_visits
FROM traveler_trip
GROUP BY destination_country
ORDER BY num_visits DESC;


-- Average trip duration per city
SELECT destination_city, 
ROUND(AVG(duration),2) AS avg_duration
FROM traveler_trip
WHERE destination_city NOT LIKE 'Unknown'
GROUP BY destination_city
ORDER BY avg_duration DESC;


-- Most traveled city per month per year
WITH year_month AS
(
SELECT destination_city, 
	to_char(start_date, 'YYYY-MM') AS year_month_visit,
	COUNT(to_char(start_date, 'YYYY-MM')) AS count_visit
FROM traveler_trip
WHERE destination_city NOT LIKE 'Unknown'
GROUP BY to_char(start_date, 'YYYY-MM'), destination_city
ORDER BY year_month_visit
)

SELECT destination_city, 
	year_month_visit, 
	count_visit,
	DENSE_RANK() OVER(ORDER BY count_visit DESC) AS rank
FROM year_month;


-- Most traveled city per month, combined year. 
WITH month AS
(
SELECT destination_city, 
	EXTRACT (MONTH FROM start_date) AS month_visit,
	COUNT(EXTRACT (MONTH FROM start_date)) AS count_visit
FROM traveler_trip
GROUP BY EXTRACT (MONTH FROM start_date), destination_city
ORDER BY month_visit
)

SELECT destination_city, 
	month_visit, 
	count_visit,
	DENSE_RANK() OVER(PARTITION BY month_visit ORDER BY count_visit DESC) AS rank
FROM month
WHERE destination_city NOT LIKE 'Unknown'
ORDER BY month_visit;


-- Number of trips per month
SELECT 
	EXTRACT (MONTH FROM start_date) AS month_visit,
	COUNT(EXTRACT (MONTH FROM start_date)) AS count_visit
FROM traveler_trip
GROUP BY EXTRACT (MONTH FROM start_date)
ORDER BY count_visit DESC;


-- Top  cities per year 
WITH year_count AS 
(
SELECT destination_city,
	EXTRACT (YEAR FROM start_date) AS year_visit,
	COUNT(EXTRACT (YEAR FROM start_date)) AS count_visit
FROM traveler_trip
WHERE destination_city NOT LIKE 'Unknown'
GROUP BY year_visit, destination_city
) ranking AS
(
SELECT destination_city,
	year_visit,
	count_visit,
	DENSE_RANK() OVER(PARTITION BY year_visit ORDER BY count_visit DESC) AS rank
FROM year_count
)
SELECT destination_city,
	year_visit,
	count_visit,
	rank
FROM ranking
WHERE rank = 1;


--Top cities per season: Seasons:
 -- Winter 12,1,2
 -- Spring 3,4,5
 -- Summer6,7,8
 -- Autumn 9,10,11

WITH seasons AS
(
SELECT destination_city,
	EXTRACT (MONTH FROM start_date) AS month_visit,
	COUNT(EXTRACT (YEAR FROM start_date)) AS count_visit,
	CASE WHEN (EXTRACT(MONTH FROM start_date)) IN (12,1,2) THEN 'Winter' 
		WHEN (EXTRACT(MONTH FROM start_date)) IN (3,4,5) THEN 'Spring'
		WHEN (EXTRACT(MONTH FROM start_date)) IN (6,7,8) THEN 'Summer' 
		ELSE 'Autumn' END AS season
FROM traveler_trip
GROUP BY month_visit, destination_city
ORDER BY month_visit
), ranking AS
(
SELECT destination_city, 
	month_visit,
	count_visit,
	season, 
	DENSE_RANK() OVER(PARTITION BY season ORDER BY count_visit DESC) AS rank
FROM seasons
)
SELECT destination_city, 
	month_visit,
	count_visit,
	season, 
	rank
FROM ranking
WHERE rank = 1;


-- Average trip duration per city
SELECT destination_city, 
ROUND(AVG (duration),2) AS avg_duration
FROM traveler_trip
WHERE destination_city != 'Unknown'
GROUP BY destination_city
ORDER BY avg_duration DESC;


-- Average trip duration per month
SELECT EXTRACT(MONTH FROM start_date) AS month,
ROUND(AVG(duration),2) AS avg_duration
FROM traveler_trip
GROUP BY month
ORDER BY avg_duration DESC;


-- Average trip duration overall
SELECT ROUND(AVG(duration),2) AS avg_duration
FROM traveler_trip


-- Average trip duration per season
WITH seasons AS
(
SELECT trip_id, duration,
	EXTRACT (MONTH FROM start_date) AS month_visit,
	CASE WHEN (EXTRACT(MONTH FROM start_date)) IN (12,1,2) THEN 'Winter' 
		WHEN (EXTRACT(MONTH FROM start_date)) IN (3,4,5) THEN 'Spring'
		WHEN (EXTRACT(MONTH FROM start_date)) IN (6,7,8) THEN 'Summer' 
		ELSE 'Autumn' END AS season
FROM traveler_trip
ORDER BY month_visit
)
SELECT season, ROUND(AVG(duration),2) AS avg_duration
FROM seasons
GROUP BY season
ORDER BY avg_duration DESC;


-- Average traveler age
SELECT ROUND(AVG(traveler_age),2) AS avg_age
FROM traveler_trip;


-- Average traveler age per city
SELECT destination_city,
	ROUND(AVG(traveler_age),2) AS avg_age
FROM traveler_trip
GROUP BY destination_city
ORDER BY avg_age DESC;


-- Average traveler age per season
WITH seasons AS
(
SELECT trip_id, traveler_age,
	EXTRACT (MONTH FROM start_date) AS month_visit,
	CASE WHEN (EXTRACT(MONTH FROM start_date)) IN (12,1,2) THEN 'Winter' 
		WHEN (EXTRACT(MONTH FROM start_date)) IN (3,4,5) THEN 'Spring'
		WHEN (EXTRACT(MONTH FROM start_date)) IN (6,7,8) THEN 'Summer' 
		ELSE 'Autumn' END AS season
FROM traveler_trip
ORDER BY month_visit
)
SELECT season, ROUND(AVG(traveler_age),2) AS avg_age
FROM seasons
GROUP BY season
ORDER BY avg_age DESC;


-- Average spending per age range: The data is mostly 20s and 30s. Combining total spending in accommodation and transportation
-- Spending = (Accommodation Costs + Transportation Costs)
-- 20s (20-29)
-- 30s (30-39)
-- 40 + (40 - 60)
WITH age_ranges AS
(
SELECT traveler_age, 
	(accommodation_cost + transportation_cost) AS total_spending,
	CASE WHEN traveler_age BETWEEN 20 AND 29 THEN '20s'
	WHEN traveler_age BETWEEN 30 AND 39 THEN '30s'
	ELSE '40+'
	END AS age_range
FROM traveler_trip
)
SELECT age_range, 
	ROUND(AVG(total_spending),2) AS avg_total_spending
FROM age_ranges
GROUP BY age_range
ORDER BY avg_total_spending DESC;


-- Traveler Gender percentages
SELECT  
	ROUND(100.00 * SUM(CASE WHEN traveler_gender = 'Female' THEN 1
	ELSE 0 END)/COUNT(*),2) AS female_percentage,
	ROUND(100.00 * SUM(CASE WHEN traveler_gender = 'Male' THEN 1
	ELSE 0 END)/COUNT(*),2) AS male_percentage
FROM traveler_trip;


-- Top 10 traveler nationalities
SELECT traveler_nationality,
	COUNT(*) AS cnt_traveler_nationality
FROM traveler_trip
GROUP BY traveler_nationality
ORDER BY cnt_traveler_nationality DESC
LIMIT 10;


-- Top cities per nationality
SELECT destination_city, 
	traveler_nationality,
	DENSE_RANK() OVER(PARTITION BY destination_city ORDER BY COUNT(traveler_nationality) DESC) AS rank
FROM traveler_trip
GROUP BY destination_city, traveler_nationality;


-- Top accommodation type
SELECT accommodation_type, COUNT(*) AS cnt_accommodation_type
FROM traveler_trip
GROUP BY accommodation_type
ORDER BY cnt_accommodation_type DESC
LIMIT 3;


-- Most popular accommodation type per city
WITH rankings AS
(
SELECT destination_city, 
	accommodation_type,
	COUNT(accommodation_type) AS cnt_accommodation,
	DENSE_RANK() OVER(PARTITION BY destination_city ORDER BY COUNT(accommodation_type) DESC) AS rank
FROM traveler_trip
WHERE destination_city != 'Unknown'
GROUP BY destination_city, accommodation_type
ORDER BY destination_city
)
SELECT destination_city, accommodation_type, cnt_accommodation
FROM rankings
WHERE rank = 1;


-- Average accommodation cost per accommodation type per day
SELECT accommodation_type, 
	ROUND(AVG(accommodation_cost/duration),2) AS avg_accommodation_cost_per_day
FROM traveler_trip
GROUP BY accommodation_type
ORDER BY avg_accommodation_cost_per_day DESC;


-- Average accommodation cost per city per day
-- Using per day, because all trips have different durations
SELECT destination_city, 
	ROUND(AVG(accommodation_cost/duration),2) AS avg_accommodation_cost_per_day
FROM traveler_trip
GROUP BY destination_city
ORDER BY avg_accommodation_cost_per_day DESC;


-- Average accommodation cost per age range per day
-- 20s (20-29)
-- 30s (30-39)
-- 40 + (40 - 60)
SELECT 
	CASE WHEN traveler_age BETWEEN 20 AND 29 THEN '20s'
		WHEN traveler_age BETWEEN 30 AND 39 THEN '30s'
		ELSE '40+' END AS age_range,
	ROUND(AVG(accommodation_cost/duration),2) AS avg_accommodation_cost_per_day
FROM traveler_trip
GROUP BY age_range
ORDER BY avg_accommodation_cost_per_day DESC;


-- Top 3 transportation types
SELECT transportation_type, COUNT(transportation_type) AS cnt_transportation_type
FROM traveler_trip
GROUP BY transportation_type
ORDER BY cnt_transportation_type DESC
LIMIT 3;

-- Average Spending per City per Day (Accommodation + Transportation Costs)
SELECT destination_city,
	ROUND(AVG(accommodation_cost/duration),2) AS avg_accommodation_per_day,
	ROUND(AVG(transportation_cost/duration),2) AS avg_transportation_per_day,
	ROUND(AVG((accommodation_cost + transportation_cost)/duration),2) AS avg_spending_per_day
FROM traveler_trip
GROUP BY destination_city;
	

	

