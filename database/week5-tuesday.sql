-- exploring why grouping by Scientific_name is not quite correct
SELECT * FROM Species LIMIT 3;

-- are there duplicate scientific names? (yes)
SELECT COUNT(*) FROM Species;
SELECT COUNT(DISTINCT Scientific_name) FROM Species;
SELECT Scientific_name, COUNT(*) AS Num_name_occurrences
    FROM Species
    GROUP BY Scientific_name
    HAVING Num_name_occurrences > 1;

CREATE TEMP TABLE t AS (
    SELECT Scientific_name, COUNT(*) AS Num_name_occurrences
        FROM Species
        GROUP BY Scientific_name
        HAVING Num_name_occurrences > 1
);

SELECT * FROM t;

SELECT * FROM Species s JOIN t
    ON s.Scientific_name = t.Scientific_name;
    OR (s.Scientific_name IS NULL AND t.Scientific_name IS NULL);

-- inserting data
-- this way of doing it assumes that the order of the columns is code, common name, scientific name, relevance 
INSERT INTO Species VALUES ('abcd', 'thing', 'scientific_name', NULL);
SELECT * FROM Species;
-- you can explicitly label columns: this is less fragile than the first way of doing it because it explicitly tells you which names should go where
INSERT INTO Species
    (Common_name, Scientific_name, Code, Relevance)
    VALUES
    ('thing 2', 'another scientific name', 'efgh', NULL);
SELECT * FROM Species;

-- can take advantage of default values
INSERT INTO Species
    VALUES
    ('thing 3', 'ijkl');
SELECT * FROM Species;

-- UPDATES and DELETES will demolish the entire table unless limited by WHERE
DELETE FROM Bird_eggs WHERE Nest_ID

-- Strategies to save yourself?
-- Doing a SELECT first
SELECT * FROM Bird_eggs WHERE Nest_ID LIKE 'z%';
SELECT * FROM Bird_nests;

-- try the create a copy of the table method
CREATE TABLE nest_temp AS (SELECT * FROM Bird_nests);
DELETE FROM nest_temp WHERE Site = 'chur';
-- check that it worked
SELECT * FROM nest_temp;