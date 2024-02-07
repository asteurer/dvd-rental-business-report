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
)