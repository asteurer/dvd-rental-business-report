CREATE TABLE detailed_report (
	rental_id INTEGER PRIMARY KEY,
	rental_date DATE,
	rental_rate NUMERIC(4,2),
	rental_duration SMALLINT,
	store_id SMALLINT,
	category_name VARCHAR(25)
);


CREATE TABLE summary_report (
	month_number SMALLINT,
	year_number SMALLINT,
	store_id SMALLINT,
	category_name VARCHAR(25), 
	potential_sales TEXT,
	total_rentals BIGINT,
	PRIMARY KEY (month_number, year_number, store_id, category_name)
);

CREATE OR REPLACE FUNCTION generate_summary_report() 
	RETURNS TRIGGER
	LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO summary_report (
		month_number,
		year_number,
		store_id,
		category_name,
		potential_sales,
		total_rentals
	)
	SELECT
		date_part('month', detailed_report.rental_date)::INT AS month_number,
		date_part('year', detailed_report.rental_date)::INT as year_number,
		detailed_report.store_id,
		detailed_report.category_name,
		SUM(detailed_report.rental_rate * detailed_report.rental_duration)::NUMERIC::MONEY AS potential_sales,
		COUNT(detailed_report.rental_id) AS total_rentals
	FROM
		detailed_report
	GROUP BY month_number, year_number, detailed_report.store_id, detailed_report.category_name;
	RETURN NULL; 
END; 
$$;


CREATE OR REPLACE FUNCTION generate_detailed_report(input_date DATE) 
	RETURNS void
	LANGUAGE plpgsql
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
	WHERE date_part('month', rental.rental_date) = date_part('month', input_date)
		AND date_part('year', rental.rental_date) = date_part('year', input_date);
END; 
$$;
	

CREATE OR REPLACE PROCEDURE get_sales(date_input TEXT)
	LANGUAGE plpgsql
	AS $$
	BEGIN
		DROP TABLE IF EXISTS detailed_report;
		DROP TABLE IF EXISTS summary_report; 

		CREATE TABLE detailed_report (
			rental_id INTEGER PRIMARY KEY,
			rental_date DATE,
			rental_rate NUMERIC(4,2),
			rental_duration SMALLINT,
			store_id SMALLINT,
			category_name VARCHAR(25)
		);


		CREATE TABLE summary_report (
			month_number SMALLINT,
			year_number SMALLINT,
			store_id SMALLINT,
			category_name VARCHAR(25), 
			potential_sales TEXT,
			total_rentals BIGINT,
			PRIMARY KEY (month_number, year_number, store_id, category_name)
		);


		CREATE OR REPLACE TRIGGER summary_trigger
			AFTER INSERT
			ON detailed_report
			FOR EACH STATEMENT
			EXECUTE PROCEDURE generate_summary_report(); 
	
		PERFORM generate_detailed_report(date_input::DATE); 
	RETURN; 
	END; 
	$$;