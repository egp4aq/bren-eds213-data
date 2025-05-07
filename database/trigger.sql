-- to get in to sqlite:
-- sqlite3 database.sqlite

-- SQLite looks a lot like DuckDB
.schema
.tables
.nullvalue -NULL-

-- The problem we're going to try to fix:
INSERT INTO Species VALUES ('abcd','thing1','','Study species');
SELECT * FROM Species;

-- Time to create our trigger:
CREATE TRIGGER Fix_up_species
AFTER INSERT ON Species
FOR EACH ROW
BEGIN
    UPDATE Species
    SET Scientific_name = NULL
    WHERE Code = new.Code AND Scientific_name = '';
END;

-- Let's test it
INSERT INTO Species
    VALUES ('efgh','thing2','','Study species');