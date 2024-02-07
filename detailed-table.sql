--Detailed Table
SELECT 
	staff.store_id, 
	category.name AS category_name,
	film.rental_rate,
	film.rental_duration,
	rental.rental_id
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
WHERE date_part('month', rental.rental_date) = 5 AND date_part('year', rental.rental_date) = 2005; 