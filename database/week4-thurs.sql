CREATE TABLE Snow_cover(
    Site varchar NOT NULL,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1990 AND 2018),
    Date DATE NOT NULL,
    Plot varchar NOT NULL,
    Location varchar NOT NULL,
    Snow_cover REAL CHECK (Snow_cover BETWEEN 0 AND 130),
    Water_cover REAL CHECK (Snow_cover BETWEEN 0 AND 130),
    Land_cover REAL CHECK (Snow_cover BETWEEN 0 AND 130),
    Total_cover REAL CHECK (Snow_cover BETWEEN 0 AND 130),
    Observer varchar,
    Notes varchar,
    PRIMARY KEY (Site, Date, Plot, Location),
    FOREIGN KEY (Site) REFERENCES Site (Code)
);

COPY Snow_cover FROM '../ASDN_csv/snow_survey_fixed.csv' (header TRUE, nullstr "NA"); -- nullstr "NA" tells SQL that it should read NA's as NULL

SELECT * FROM Snow_cover LIMIT 10;

-- Ask 1: What is the average snow cover at each site?

SELECT Site, AVG(Snow_cover)
    FROM Snow_cover
    GROUP BY Site;

-- Ask 2: What is the top 5 most snowy sites?

SELECT Site, AVG(Snow_cover) AS Avg_snowcover FROM Snow_cover
    GROUP BY Site
    ORDER BY Avg_snowcover DESC
    LIMIT 5;

SELECT * FROM Site_avg_snowcover;

-- Ask 3: save this as a VIEW
CREATE VIEW Site_avg_snowcover AS (
    SELECT Site, AVG(Snow_cover) AS Avg_snowcover FROM Snow_cover
    GROUP BY Site
    ORDER BY Avg_snowcover DESC
    LIMIT 5
);

SELECT * FROM Site_avg_snowcover;

-- we want to update some of the data, so let's make a temporary copy of the table to work on and then once that works we can update the real table

CREATE TEMP TABLE Site_avg_snowcover_table AS (
    SELECT Site, AVG(Snow_cover) AS Avg_snowcover FROM Snow_cover
    GROUP BY Site
    ORDER BY Avg_snowcover DESC
    LIMIT 5
);

SELECT * FROM Site_avg_snowcover_table;

-- DANGER ZONE (AKA updating data)
-- we found that 0's at Plot = `brw0` with snow_cover == 0 are actually no data (NULL)
CREATE TEMP TABLE Snow_cover_backup AS (SELECT * FROM Snow_cover);
UPDATE Snow_cover_backup SET Snow_cover = NULL WHERE Plot = 'brw0' AND Snow_cover = 0;
-- now that we know this works, we'll rerun the query on the actual table
UPDATE Snow_cover SET Snow_cover = NULL WHERE Plot = 'brw0' AND Snow_cover = 0;
-- check that it worked
SELECT * FROM Snow_cover WHERE Plot='brw0';