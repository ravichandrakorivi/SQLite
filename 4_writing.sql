----------------------------------------------------------------------------------------------
-- WRITING
----------------------------------------------------------------------------------------------


/********** Storage Types ***************/
-- INTEGER
-- REAL
-- TEXT
-- BLOB
-- NULL
-- NUMERIC
/*****************************************/

/********** Column Constraints **********/
-- CHECK
-- DEFAULT
-- NOT NULL
-- UNIQUE
/****************************************/

-- Primary key constraint will automatically impose column constriants like "NOT NULL", "UNIQUE" on the primary key column column


-- sqlite3 
.open collections.db
.mode box


--------------------------------------------------------------------------------------
--------------------------------------- Insert ---------------------------------------
--------------------------------------------------------------------------------------

.read 4_schema_writing_v1.sql

SELECT * FROM "collections";

INSERT INTO "collections" ("id", "title", "accession_number", "acquired")
VALUES (1, 'Profusion of flowers', '56.257', '1956-04-12');

INSERT INTO "collections" ("id", "title", "accession_number", "acquired")
VALUES (2, 'Farmers working in dawn', '11.6152', '1911-08-03');

-- sqlite will automatically increment the primary key for us
INSERT INTO "collections" ("title", "accession_number", "acquired")
VALUES ('Spring outing', '14.76', '1914-01-08');

INSERT INTO "collections" ("title", "accession_number", "acquired") 
VALUES ('Alchemist', '14.76', '1917-04-30');
-- Runtime error: UNIQUE constraint failed: collections.accession_number (19)

INSERT INTO "collections" ("title", "accession_number", "acquired") 
VALUES ('Spring outing', '14.76', '1914-01-08');
-- Runtime error: UNIQUE constraint failed: collections.accession_number (19)

INSERT INTO "collections" ("title", "accession_number", "acquired") 
VALUES (NULL, NULL, '1900-01-10');
-- Runtime error: NOT NULL constraint failed: collections.title (19)

INSERT INTO "collections" ("title", "accession_number", "acquired")
VALUES
('Imaginative landscape', '56.496', NULL),
('Peonies and butterfly', '86.1899', '1906-01-01');

DELETE FROM "collections" WHERE "acquired" IS NULL;

INSERT INTO "collections" ("title", "accession_number")
VALUES ('Imaginative landscape', '56.496');

SELECT * FROM "collections" WHERE "acquired" IS NULL;

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------




--------------------------------------------------------------------------------------
------------------------------- Importing data from csv file -------------------------
--------------------------------------------------------------------------------------
.read 4_schema_writing_v1.sql
.schema

SELECT * FROM "collections";

.import --csv --skip 1 4_collections.csv collections

SELECT * FROM "collections";
DELETE FROM "collections";



-- Importing data from csv file without primary keys
.import --csv 4_collections_wo_id.csv temp
.schema

SELECT * FROM temp;

INSERT INTO "collections" ("title", "accession_number", "acquired")
SELECT "title", "accession_number", "acquired"  FROM "temp";

SELECT * FROM "collections";

DROP TABLE "temp";
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------


INSERT INTO "collections" ("title", "accession_number", "acquired")
VALUES 
('Tile Lunette', '06.2437', '1906-11-08'),
('Statuette of a shrew', '01.105', '1901-02-11');


-- Deleting 
DELETE FROM "collections" WHERE "title" = 'Spring outing';
DELETE FROM "collections" WHERE "acquired" IS NULL;
SELECT * FROM "collections";

DELETE FROM "collections" WHERE "acquired"  < '1909-01-01';
SELECT * FROM "collections";

DROP TABLE "collections";



----------------------------------------------------------------------------------
----------------------------- Foreign Key Constraints ----------------------------
----------------------------------------------------------------------------------
.read 4_schema_writing_v2.sql
.schema
.schema created

SELECT * FROM "created";
SELECT * FROM "artists";
SELECT * FROM "collections";

PRAGMA foreign_keys;
PRAGMA foreign_keys = ON;
PRAGMA foreign_keys;

DELETE FROM "artists" WHERE "name" = 'Unidentified artist';
-- Runtime error: FOREIGN KEY constraint failed (19)

DELETE FROM "created" WHERE "artist_id" = (
    SELECT "id" FROM "artists" WHERE "name" = 'Unidentified artist'
);
DELETE FROM "artists" WHERE "name" = 'Unidentified artist';
-- Successful



----------------------------------------------------------------------------------
--------------------- Foreign Key Constraints :  ON DELETE -----------------------
----------------------------------------------------------------------------------
.read 4_schema_writing_v3.sql
.schema

SELECT * FROM "created";
SELECT * FROM "artists";
SELECT * FROM "collections";

DELETE FROM "artists" WHERE "name" = 'Unidentified artist';
SELECT * FROM "artists";
SELECT * FROM "created";
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------




----------------------------------------------------------------------------------
--------------------------------- Updating ---------------------------------------
----------------------------------------------------------------------------------
.read 4_schema_writing_v3.sql
.schema

SELECT * FROM "created";
SELECT * FROM "artists";
SELECT * FROM "collections";

UPDATE "created" SET "artist_id" = (
    SELECT "id" FROM "artists" 
    WHERE "name" = 'Li Yin'
)
WHERE "collection_id" = (
    SELECT "id" FROM "collections" 
    WHERE "title" = 'Farmers working at dawn'
);

SELECT * FROM "created";
SELECT * FROM "artists";
SELECT * FROM "collections";
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------




----------------------------------------------------------------------------------
-------------------------------- Soft Deletion -----------------------------------
----------------------------------------------------------------------------------
.read 4_schema_writing_v3.sql
.schema

SELECT * FROM "collections";
SELECT * FROM "artists";
SELECT * FROM "created";

ALTER TABLE "collections" ADD COLUMN "deleted" INTEGER DEFAULT 0;

SELECT * FROM "collections";

UPDATE "collections" SET "deleted" = 1 WHERE "title" = 'Farmers working at dawn';

SELECT * FROM "collections";
SELECT * FROM "collections" WHERE "deleted" != 1;
SELECT * FROM "collections" WHERE "deleted" = 1;
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------




----------------------------------------------------------------------------------
--------------------------------- Functions --------------------------------------
----------------------------------------------------------------------------------
.open votes.db
.schema
DROP TABLE IF EXISTS "votes";
.schema

.import --csv 4_votes.csv votes
.schema
SELECT * FROM "votes";

SELECT "title" FROM "votes" GROUP BY "title";
SELECT "title", COUNT("title") FROM "votes" GROUP BY "title";

-- trim() : This function trims leading and trailing white spaces
UPDATE "votes" SET "title" = trim("title");
SELECT "title", COUNT("title") FROM "votes" GROUP BY "title";

-- Scalar functions : lower(), upper()

-- lower()
-- UPDATE "votes" SET "title" = lower("title");

-- upper() 
UPDATE "votes" SET "title" = upper("title");
SELECT "title", COUNT("title") FROM "votes" GROUP BY "title";

UPDATE "votes" SET "title" = 'FARMERS WORKING AT DAWN' WHERE "title" = 'FARMERS WORKING';
UPDATE "votes" SET "title" = 'FARMERS WORKING AT DAWN' WHERE "title" = 'FAMERS WORKING AT DAWN';

UPDATE "votes" SET "title" = 'FARMERS WORKING AT DAWN' WHERE "title" LIKE 'Fa%wo%';
UPDATE "votes" SET "title" = 'IMAGINATIVE LANDSCAPE' WHERE "title" LIKE 'imag%';
UPDATE "votes" SET "title" = 'PROFUSION OF FLOWERS' WHERE "title" LIKE 'Profusion%';

SELECT "title", COUNT("title") FROM "votes" GROUP BY "title";

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

