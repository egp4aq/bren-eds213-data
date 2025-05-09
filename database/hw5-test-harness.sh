#!/bin/bash

## Part 1

# Assign command-line arguments to named variables
label=$1 # explanatory label that will be output
num_reps=$2 # number of repititions
query=$3 # SQL query to run
db_file=$4 # database file
csv_file=$5 # CSV file to create or append to

# Get current time and store it
start_time=$(date +"%s")

# Loop num_reps times duckdb db_file query
i=0
while [ $i -lt $num_reps ]; do
    duckdb $db_file "$query"
    i=$((i + 1))
done

# Get current time
end_time=$(date +"%s")

# Calculate elapsed time
elapsed_time=$((end_time - start_time))

# Divide elapsed time by num_reps
avg_time=$(python -c "print($elapsed_time / $num_reps)")

# Write output
echo $label,$avg_time >> $csv_file

## Part 2: Use test harness to time three queries

# NOT IN method
# bash hw5-test-harness.sh subquery 10 "SELECT Code FROM Species WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);" database.db results.csv

# RIGHT JOIN method
# bash hw5-test-harness.sh outer_join 10 "SELECT Code FROM Bird_nests RIGHT JOIN Species ON Species = Code WHERE Nest_ID IS NULL;" database.db results.csv

# EXCEPT method
# bash hw5-test-harness.sh except 10 "SELECT Code FROM Species EXCEPT SELECT DISTINCT Species FROM Bird_nests;" database.db results.csv
