#!/bin/bash

# Database credentials
DB_NAME="project"
DB_USER="postgres"
DB_HOST="localhost"
DB_PORT="5432"  # Default is usually 5432

# Prompt user for year and month
echo "Please enter the year (YYYY):"
read YEAR
echo "Please enter the month (MM):"
read MONTH

# Validate input (basic validation, can be expanded)
if ! [[ $YEAR =~ ^[0-9]{4}$ ]]; then
    echo "Invalid year. Please enter a 4-digit year."
    exit 1
fi

if ! [[ $MONTH =~ ^[0-9]{2}$ ]] || [ $MONTH -lt 1 ] || [ $MONTH -gt 12 ]; then
    echo "Invalid month. Please enter a month in MM format (01-12)."
    exit 1
fi

# Construct PROCEDURE_PARAM
PROCEDURE_PARAM="'$YEAR-$MONTH-01'"

# Stored procedure name
PROCEDURE_NAME="get_sales"

# Call the stored procedure
psql -h $DB_HOST -p $DB_PORT -d $DB_NAME -U $DB_USER -c "CALL $PROCEDURE_NAME($PROCEDURE_PARAM);"
