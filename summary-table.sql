--Summary Table
SELECT 
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
WHERE date_part('month', rental.rental_date) = 5 AND date_part('year', rental.rental_date) = 2005
GROUP BY staff.store_id, category.name
ORDER BY store_id, potential_sales DESC; 
	
