-- EXPORTING data from a database

-- The whole database
EXPORT database 'export_adsn';
-- this should export all database files to a folder called export_adsn into the current directory 

-- One file
COPY Species TO 'species_test.csv' (HEADER, DELIMETER ',');
-- when we then look at the files in database, we see a new file called species_test.csv

-- specific query 
COPY (SELECT COUNT(*) FROM Species) TO 'species_count.csv' (HEADER, DELIMETER ',');