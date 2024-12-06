-- Creating Views for Visualization
-- Saving the queries that we'll be using for Tableau visualizations as Views

-- Most Visited City 
CREATE VIEW Most_Traveled_City AS
SELECT destination_city, 
	destination_country, 
COUNT(destination_city) AS num_visits
FROM traveler_trip
WHERE destination_city != 'Unknown'
GROUP BY destination_city, destination_country, destination
--ORDER BY num_visits DESC;


-- Top Cities per Season
CREATE VIEW Top_cities_per_season AS
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


-- Average Traveler Age per City
CREATE VIEW avg_age_per_city AS
SELECT destination_city,
	ROUND(AVG(traveler_age),2) AS avg_age
FROM traveler_trip
GROUP BY destination_city
-- ORDER BY avg_age DESC;


-- Average Duration per City
CREATE VIEW avg_duration_per_city AS
SELECT destination_city, 
ROUND(AVG (duration),2) AS avg_duration
FROM traveler_trip
WHERE destination_city != 'Unknown'
GROUP BY destination_city
--ORDER BY avg_duration DESC;


-- Most Popular Accommodation Type per City
CREATE VIEW popular_accommodation_per_city AS
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


-- Average Spending per City per Day (Accommodation + Transportation)
CREATE VIEW avg_spending_per_city_per_day AS
SELECT destination_city,
	ROUND(AVG(accommodation_cost/duration),2) AS avg_accommodation_per_day,
	ROUND(AVG(transportation_cost/duration),2) AS avg_transportation_per_day,
	ROUND(AVG((accommodation_cost+transportation_cost)/duration),2) AS avg_spending_per_day
FROM traveler_trip
GROUP BY destination_city



	

