# DVD Rental Business Report

This is a database operation designed to provide a fictional DVD rental store with data regarding it's rental volume by category. 

## Overview
This documentation describes the SQL code used for generating detailed and summary reports in a rental sales database. The database consists of two main tables: detailed_report and summary_report, and several functions and a procedure to populate and manage these tables.

## Tables
1. **detailed_report**
This table stores detailed information about each rental. The columns are:

**rental_id**: The unique identifier for each rental (Primary Key).7
**rental_date**: The date of the rental.
**rental_rate**: The rate at which the item was rented (data type MONEY).
**rental_duration**: The duration of the rental in days.
**store_id**: Identifier for the store from which the rental was made.
**category_name**: Name of the category of the rented item.

2. **summary_report**
This table provides a summarized view of rentals. The columns are:

**month_number**: The month of the year.
**year_number**: The year.
**store_id**: Identifier for the store.
**category_name**: Category name of the rented items.
**potential_sales**: The projected sales based on rental rate and duration.
**total_rentals**: The total number of rentals in that category.
This table uses a composite primary key consisting of month_number, year_number, store_id, and category_name.

## Functions

1. **generate_summary_report**
This function is triggered after each insert operation on the detailed_report table. It aggregates data from the detailed_report table and inserts it into the summary_report table, providing a monthly and yearly summary of rentals by store and category.

2. **generate_detailed_report**
This function takes a date as input and inserts data into the detailed_report table based on the given month and year. It pulls data from various tables like rental, inventory, film_category, category, film, and staff.

## Procedure

1. **get_sales**
This procedure is the main entry point for generating reports. It takes a date in text format as input and performs the following actions:

Drops the **detailed_report** and **summary_report** tables if they exist.
Recreates these tables.
Sets up a trigger (**summary_trigger**) on the **detailed_report** table that calls **generate_summary_report** function.
Calls **generate_detailed_report** function with the provided date to populate the **detailed_report** table.

## Usage

To generate reports, call the **get_sales** procedure with the desired date as input.
The procedure will set up the environment and populate both **detailed_report** and **summary_report** tables.

## Notes

The **database.backup** file is a functional backup of a PostgreSQL database, and can be used to test the code in **main.sql**. 

## Authors

Andrew Steurer

linkedin.com/in/andrewsteurer
