-------------------------------------------------------------------------------
-- DESIGNING
-------------------------------------------------------------------------------

-- sqlite3
.mode box

-- Open longlist.db
.open longlist.db
.schema
-- In SQLite, the .schema command is used to view the structure (schema) of database objects like tables, indexes, views, and triggers.
-- .schema is a SQLite shell command, not standard SQL. It works inside the sqlite3 command-line interface.

SELECT sql FROM sqlite_master WHERE sql IS NOT NULL ORDER BY type, name;
-- sqlite_master is a system table in SQLite that stores the schema of the database.
-- It contains one row for each: table, index, view & trigger
-- Structure: type (table, index, view, trigger), name, tbl_name, rootpage, sql (original CREATE statement)

-- Now open longlist_rel.db
.open longlist_rel.db
.schema

-- show the CREATE statement used to create the table named books
.schema "books"
.schema books

SELECT sql FROM sqlite_master WHERE name = 'books';


-- create a new database
.open mbta.db

.schema
-- It returns nothing as there are no objects yet in the database


CREATE TABLE "riders" (
    "id",
    "name"
);

CREATE TABLE "stations" (
    "id",
    "name",
    "line"
);

CREATE TABLE "visits" (
    "rider_id",
    "station_id"
);

.schema

SELECT * FROM "riders";
SELECT * FROM "stations";
SELECT * FROM "visits";

DROP TABLE "riders";
DROP TABLE "stations";
DROP TABLE "visits";

.read 3_schema_designing_v1.sql
.schema

-- Delete the tables
DROP TABLE "riders";
DROP TABLE "stations";
DROP TABLE "visits";

.read 3_schema_designing_v2.sql
.schema

-- Altering

ALTER TABLE "visits" RENAME TO "swipes";
.schema

ALTER TABLE "swipes" ADD COLUMN "ttpe" TEXT;
.schema

ALTER TABLE "swipes" RENAME COLUMN "ttpe" TO "type";
.schema

ALTER TABLE "swipes" DROP COLUMN "type";
.schema

-- Delete the tables
DROP TABLE "riders";
DROP TABLE "stations";
DROP TABLE "swipes";
.schema
SELECT sql FROM sqlite_master WHERE sql IS NOT NULL ORDER BY "type", "name";

.read 3_schema_designing_v3.sql
.schema

