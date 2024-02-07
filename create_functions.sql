--TODO: Update the date comparisons in the WHERE clause to have CURRENT_DATE rather than 05/01/2005

CREATE OR REPLACE FUNCTION generate_summary_report() RETURNS void AS $$
BEGIN
	INSERT INTO summary_report (
		last_day_of_month,
		store_id,
		category_name,
		potential_sales,
		total_rentals
	)
	SELECT
		(DATE_TRUNC('MONTH', rental.rental_date) + INTERVAL '1 MONTH' - INTERVAL '1 day')::DATE as last_day_of_month,
		staff.store_id,
		category.name AS category_name,
		CONCAT('$', SUM(film.rental_rate * film.rental_duration)) AS potential_sales,
		COUNT(rental.rental_id) AS total_rentals
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
	WHERE date_part('month', rental.rental_date) = date_part('month', '05/01/2005'::DATE)
		AND date_part('year', rental.rental_date) = date_part('year',  '05/01/2005'::DATE)
	GROUP BY last_day_of_month, staff.store_id, category.name;
END; 
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generate_detailed_report() RETURNS void AS $$
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
	WHERE date_part('month', rental.rental_date) = date_part('month', '05/01/2005'::DATE)
		AND date_part('year', rental.rental_date) = date_part('year', '05/01/2005'::DATE); 
END; 
$$ LANGUAGE plpgsql;
