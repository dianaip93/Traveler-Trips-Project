-- Data Cleaning 

-- Looking for Duplicate rows. No duplicatess found

WITH duplicates AS
(
SELECT *, 
	ROW_NUMBER() OVER(PARTITION BY destination, 
traveler_name, traveler_age, 
	traveler_gender, traveler_nationality) AS row_num
FROM traveler_trip
)

SELECT * 
FROM duplicates
WHERE row_num > 1;


-- Destination Column: 
-- Find spelling variations
SELECT destination, 
COUNT(destination)
FROM traveler_trip
GROUP BY destination
ORDER BY 1;

-- Using case statement to standardize destination, adding ‘Unknown’ when city is not given 
SELECT 
	CASE WHEN destination LIKE 'Amster%' THEN 'Amsterdam, Netherlands'
	WHEN destination LIKE 'Australia%' THEN 'Unknown, Australia'
	WHEN destination LIKE 'Bali%' THEN 'Bali, Indonesia'
	WHEN destination LIKE 'Bangkok%' THEN 'Bangkok, Thailand'
	WHEN destination LIKE 'Barcelona%' THEN 'Barcelona, Spain'
	WHEN destination LIKE 'Brazil%' THEN 'Unknown, Brazil'
	WHEN destination LIKE 'Canada%' THEN 'Unknown, Canada'
	WHEN destination LIKE 'Cape Town%' THEN 'Cape Town, South Africa'
	WHEN destination LIKE 'Dubai%' THEN 'Dubai, United Arab Emirates'
	WHEN destination LIKE 'Egypt%' THEN 'Unknown, Egypt'
	WHEN destination LIKE 'France%' THEN 'Unknown, France'
	WHEN destination LIKE 'Greece%' THEN 'Unknown, Greece'
	WHEN destination LIKE 'Hawaii%' THEN 'Unknown, Hawaii'
	WHEN destination LIKE 'Italy' THEN 'Unknown, Italy'
	WHEN destination LIKE 'London%' THEN 'London, UK'
	WHEN destination LIKE 'Mexico' THEN 'Unknown, Mexico'
	WHEN destination LIKE 'New York%' THEN 'New York, USA'
	WHEN destination LIKE 'Paris' THEN 'Paris, France'
	WHEN destination LIKE 'Phnom Penh' THEN 'Phnom Penh, Cambodia
	WHEN destination LIKE 'Phuket%' THEN 'Phuket, Thailand'
	WHEN destination LIKE 'Rio de Janeiro%' THEN 'Rio de Janeiro, Brazil'
	WHEN destination LIKE 'Rome%' THEN 'Rome, Italy''
	WHEN destination LIKE ‘Santorini%’ THEN ‘Santorini, Greece’
	WHEN destination LIKE 'Seoul%' THEN 'Seoul, South Korea'
	WHEN destination LIKE 'Spain' THEN 'Unknown, Spain'
	WHEN destination LIKE 'Sydney%' THEN 'Sydney, Australia'
	WHEN destination LIKE 'Thailand' THEN 'Unknown, Thailand'
	WHEN destination LIKE 'Tokyo%' THEN 'Tokyo, Japan'
	ELSE destination END ;
FROM traveler_trip
ORDER BY 1;

-- Update Table
UPDATE traveler_trip
SET destination = CASE WHEN destination LIKE 'Amster%' THEN 'Amsterdam, Netherlands'
	WHEN destination LIKE 'Australia%' THEN 'Unknown, Australia'
	WHEN destination LIKE 'Bali%' THEN 'Bali, Indonesia'
	WHEN destination LIKE 'Bangkok%' THEN 'Bangkok, Thailand'
	WHEN destination LIKE 'Barcelona%' THEN 'Barcelona, Spain'
	WHEN destination LIKE 'Brazil%' THEN 'Unknown, Brazil'
	WHEN destination LIKE 'Canada%' THEN 'Unknown, Canada'
	WHEN destination LIKE 'Cape Town%' THEN 'Cape Town, South Africa'
	WHEN destination LIKE 'Dubai%' THEN 'Dubai, United Arab Emirates'
	WHEN destination LIKE 'Egypt%' THEN 'Unknown, Egypt'
	WHEN destination LIKE 'France%' THEN 'Unknown, France'
	WHEN destination LIKE 'Greece%' THEN 'Unknown, Greece'
	WHEN destination LIKE 'Hawaii%' THEN 'Unknown, Hawaii'
	WHEN destination LIKE 'Italy' THEN 'Unknown, Italy'
	WHEN destination LIKE 'Japan' THEN 'Unknown, Japan'
	WHEN destination LIKE 'London%' THEN 'London, UK'
	WHEN destination LIKE 'Mexico' THEN 'Unknown, Mexico'
	WHEN destination LIKE 'New York%' THEN 'New York, USA'
	WHEN destination LIKE 'Paris' THEN 'Paris, France'
	WHEN destination LIKE 'Phuket%' THEN 'Phuket, Thailand'
	WHEN destination LIKE 'Rio de Janeiro%' THEN 'Rio de Janeiro, Brazil'
	WHEN destination LIKE 'Rome%' THEN 'Rome, Italy'
	WHEN destination LIKE 'Santorini' THEN 'Santorini, Greece'
	WHEN destination LIKE 'Seoul%' THEN 'Seoul, South Korea'
	WHEN destination LIKE 'Spain' THEN 'Unknown, Spain'
	WHEN destination LIKE 'Sydney%' THEN 'Sydney, Australia'
	WHEN destination LIKE 'Thailand' THEN 'Unknown, Thailand'
	WHEN destination LIKE 'Tokyo%' THEN 'Tokyo, Japan'
	ELSE destination END ;


-- Separate City and Country into Individual Columns for future queries
SELECT destination, 
	SUBSTRING(destination FROM 0 FOR POSITION(','IN destination)) AS destination_city,
	SUBSTRING(destination FROM POSITION(','IN destination)+1 FOR   CHAR_LENGTH(destination)) AS destination_country
FROM traveler_trip;

-- Create Columns and insert data
ALTER TABLE traveler_trip
ADD destination_city VARCHAR(50);

UPDATE traveler_trip
SET destination_city = SUBSTRING(destination FROM 0 FOR POSITION(','IN destination));



ALTER TABLE traveler_trip
ADD destination_country VARCHAR (50);

UPDATE traveler_trip
SET destination_country = SUBSTRING(destination FROM POSITION(','IN destination)+1 FOR CHAR_LENGTH(destination))


-- Traveler Nationality Column: 
-- Find spelling variations
SELECT traveler_nationality, 
COUNT(traveler_nationality)
FROM traveler_trip
GROUP BY traveler_nationality
ORDER BY traveler_nationality;

-- Used Case Statement to adjust variations. Some records have nationality, and some country name. Changing country names to nationality 
	SELECT 
	CASE WHEN traveler_nationality = 'Brazil' THEN 'Brazilian'
	WHEN traveler_nationality = 'Cambodia' THEN 'Cambodian'
	WHEN traveler_nationality = 'Canada' THEN 'Canadian'
	WHEN traveler_nationality = 'China' THEN 'Chinese'
	WHEN traveler_nationality = 'Germany' THEN 'German'
	WHEN traveler_nationality = 'Greece' THEN 'Greek'
	WHEN traveler_nationality = 'Hong Kong' THEN 'Chinese'
	WHEN traveler_nationality = 'Italy' THEN 'Italian'
	WHEN traveler_nationality = 'Japan' THEN 'Japanese'
	WHEN traveler_nationality = 'Singapore' THEN 'Singaporean'
	WHEN traveler_nationality = 'South Korea' THEN 'South Korean'
	WHEN traveler_nationality = 'Spain' THEN 'Spanish'
	WHEN traveler_nationality = 'Taiwan' THEN 'Taiwanese'
	WHEN traveler_nationality = 'UK' THEN 'British'
	WHEN traveler_nationality = 'United Arab Emirates' THEN 'Emirati'
	WHEN traveler_nationality = 'United Kingdom' THEN 'British'
	WHEN traveler_nationality = 'USA' THEN 'American'
	ELSE traveler_nationality END
FROM traveler_trip;

-- Update table
UPDATE traveler_trip
SET traveler_nationality = CASE WHEN traveler_nationality = 'Brazil' THEN 'Brazilian'
	WHEN traveler_nationality = 'Cambodia' THEN 'Cambodian'
	WHEN traveler_nationality = 'Canada' THEN 'Canadian'
	WHEN traveler_nationality = 'China' THEN 'Chinese'
	WHEN traveler_nationality = 'Germany' THEN 'German'
	WHEN traveler_nationality = 'Greece' THEN 'Greek'
	WHEN traveler_nationality = 'Hong Kong' THEN 'Chinese'
	WHEN traveler_nationality = 'Italy' THEN 'Italian'
	WHEN traveler_nationality = 'Japan' THEN 'Japanese'
	WHEN traveler_nationality = 'Singapore' THEN 'Singaporean'
	WHEN traveler_nationality = 'South Korea' THEN 'South Korean'
	WHEN traveler_nationality = 'Spain' THEN 'Spanish'
	WHEN traveler_nationality = 'Taiwan' THEN 'Taiwanese'
	WHEN traveler_nationality = 'UK' THEN 'British'
	WHEN traveler_nationality = 'United Arab Emirates' THEN 'Emirati'
	WHEN traveler_nationality = 'United Kingdom' THEN 'British'
	WHEN traveler_nationality = 'USA' THEN 'American'
	ELSE traveler_nationality END;


-- Accommodation Cost Column: 
-- Remove extra symbols and letters ( ‘$’ , ‘,’ ‘USD’ )
SELECT REPLACE(REPLACE(REPLACE(accommodation_cost, '$',''),' USD',''),',','')
FROM traveler_trip;
– Update table
UPDATE traveler_trip
SET accommodation_cost = REPLACE(REPLACE(REPLACE(accommodation_cost, '$',''),' USD',''),',','');

-- Change datatype to NUMERIC
ALTER TABLE traveler_trip
ALTER COLUMN transportation_cost 
	TYPE NUMERIC USING(transportation_cost::NUMERIC);

-- Transportation Type Column: 
-- Find spelling variations
SELECT transportation_type, 
COUNT (transportation_type)
FROM traveler_trip
GROUP BY transportation_type;

-- Using Case Statement to fix variations. Same transportation types are described differently, changing ‘Plane’ and ‘Flight’ to ‘Airplane’. Changing ‘Car Rental’ to ‘Car’ 
SELECT CASE WHEN transportation_type = 'Plane' THEN 'Airplane' 
		WHEN transportation_type = 'Flight' THEN 'Airplane'
		WHEN transportation_type = 'Car rental' THEN 'Car'
		ELSE transportation_type END AS transportation_type
FROM traveler_trip;

-- Update table
UPDATE traveler_trip
SET transportation_type = CASE WHEN transportation_type = 'Plane' THEN 'Airplane' 
		WHEN transportation_type = 'Flight' THEN 'Airplane'
		WHEN transportation_type = 'Car rental' THEN 'Car'
		ELSE transportation_type END;

-- Replacing null values for ‘Unknown’
SELECT COALESCE(transportation_type, 'Unknown')
FROM traveler_trip
GROUP BY transportation_type;

-- Update table
UPDATE traveler_trip
SET transportation_type = COALESCE(transportation_type, 'Unknown')

Transportation Cost Column

-- Remove “$” from the front, “USD” from  the end, and “,” from some quantities, convert data type to numeric 

SELECT REPLACE(REPLACE(REPLACE(transportation_cost, '$',''),' USD','')
FROM traveler_trip;

UPDATE traveler_trip
SET transportation_cost = REPLACE(REPLACE(REPLACE(transportation_cost, '$',''),' USD',''),',','');

-- Removing Extra spaces between numbers
SELECT REPLACE(transportation_cost, ' ','')::NUMERIC
FROM traveler_trip
ORDER BY transportation_cost DESC;

UPDATE traveler_trip
SET transportation_cost = REPLACE(transportation_cost, ' ','')

-- After the numbers are clean, change datatype to NUMERIC

ALTER TABLE traveler_trip
ALTER COLUMN transportation_cost 
	TYPE NUMERIC USING(transportation_cost::NUMERIC);

Remove blank rows

-- There are 2 rows where all the columns are empty. Separate the null rows
SELECT *
FROM traveler_trip
WHERE destination IS NOT NULL
AND start_date IS NULL
AND end_date IS NULL;

-- Delete null rows
DELETE
FROM traveler_trip
WHERE destination IS NULL
AND start_date IS NULL
AND end_date IS NULL;


-- Make trip_ID the primary key

ALTER TABLE IF EXISTS public.traveler_trip
    ALTER COLUMN trip_id SET NOT NULL;
ALTER TABLE IF EXISTS public.traveler_trip
    ADD PRIMARY KEY (trip_id);

