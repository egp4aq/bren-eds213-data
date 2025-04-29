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