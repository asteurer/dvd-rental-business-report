#!/bin/bash

# Database credentials
DB_NAME="project"
DB_USER="postgres"
DB_HOST="localhost"
DB_PORT="5432"  # Default is usually 5432

# Stored procedure name and parameters
PROCEDURE_NAME="get_sales"
PROCEDURE_PARAM="'2005-05-01'"  # Example date parameter

# Call the stored procedure
psql -h $DB_HOST -p $DB_PORT -d $DB_NAME -U $DB_USER -c "CALL $PROCEDURE_NAME($PROCEDURE_PARAM);"
