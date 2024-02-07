DROP FUNCTION IF EXISTS generate_summary_report() CASCADE;
DROP TRIGGER IF EXISTS summary_trigger ON detailed_report; 
DROP TABLE IF EXISTS summary_report; 
DROP TABLE IF EXISTS detailed_report;

CREATE TABLE summary_report (
	last_day_of_month DATE,
	store_id SMALLINT,
	category_name VARCHAR(25), 
	potential_sales TEXT,
	total_rentals BIGINT,
	PRIMARY KEY (last_day_of_month, store_id, category_name)
);


CREATE TABLE detailed_report (
	rental_id INTEGER PRIMARY KEY,
	rental_date DATE,
	rental_rate NUMERIC(4,2),
	rental_duration SMALLINT,
	store_id SMALLINT,
	category_name VARCHAR(25)
);


CREATE OR REPLACE FUNCTION generate_summary_report() 
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
AS $$
BEGIN
	INSERT INTO summary_report (
		last_day_of_month,
		store_id,
		category_name,
		potential_sales,
		total_rentals
	)
	SELECT
		(DATE_TRUNC('MONTH', detailed_report.rental_date) + INTERVAL '1 MONTH' - INTERVAL '1 day')::DATE as last_day_of_month,
		detailed_report.store_id,
		detailed_report.category_name,
		CONCAT('$', SUM(detailed_report.rental_rate * detailed_report.rental_duration)) AS potential_sales,
		COUNT(detailed_report.rental_id) AS total_rentals
	FROM
		detailed_report
	WHERE date_part('month', detailed_report.rental_date) = date_part('month', '08/01/2005'::DATE)
		AND date_part('year', detailed_report.rental_date) = date_part('year',  '08/01/2005'::DATE)
	GROUP BY last_day_of_month, detailed_report.store_id, detailed_report.category_name;
	RETURN NEW; 
END; 
$$;


CREATE OR REPLACE FUNCTION generate_detailed_report() 
	RETURNS void
	LANGUAGE PLPGSQL
AS $$
BEGIN
	INSERT INTO detailed_report(
		rental_id,
		rental_date,
		rental_rate,
		rental_duration,
		store_id,
		category_name
	)
	SELECT 
		rental.rental_id, 
		rental.rental_date, 
		film.rental_rate,
		film.rental_duration,
		staff.store_id, 
		category.name AS category_name
	FROM
		rental
	LEFT JOIN inventory 
		ON rental.inventory_id = inventory.inventory_id
	LEFT JOIN film_category
		ON inventory.film_id = film_category.film_id
	LEFT JOIN category
		ON film_category.category_id = category.category_id
	LEFT JOIN film
		ON inventory.film_id = film.film_id
	LEFT JOIN staff
		ON rental.staff_id = staff.staff_id
	WHERE date_part('month', rental.rental_date) = date_part('month', '08/01/2005'::DATE)
		AND date_part('year', rental.rental_date) = date_part('year', '08/01/2005'::DATE);
END; 
$$;


CREATE TRIGGER summary_trigger
	AFTER INSERT
	ON detailed_report
	FOR EACH STATEMENT
	EXECUTE PROCEDURE generate_summary_report(); 
	

select generate_detailed_report(); 