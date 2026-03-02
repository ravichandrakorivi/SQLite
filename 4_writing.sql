.mode box

-- sqlite3 mfa.db
.schema

/*
.read 4_schema.sql

.mode box
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
*/


/*
-- sqlite3 mfa.db
.mode box

.schema
.read 4_schema.sql
.schema

SELECT * FROM "collections";

import --csv --skip 1 mfa.csv collections


DELETE FROM "collections";
SELECT * FROM "collections";


# Read to a temporary table
.import --csv 4_mfa_wo_id.csv temp
.schema

SELECT * FROM temp;

INSERT INTO "collections" ("title", "accession_number", "acquired")
SELECT "title", "accession_number", "acquired"  FROM "temp";

SELECT * FROM "collections";

.schema
DROP TABLE "temp";
.schema


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

*/


-- Foreign Key Constraints
PRAGMA foreign_keys;
PRAGMA foreign_keys = ON;
PRAGMA foreign_keys;

/*
.open mfa_updated.db
.mode box

.schema
.read 4_schema_updated.sql
.schema
.schema created

SELECT * FROM "artists";
SELECT * FROM "collections";
SELECT * FROM "created";

SELECT * FROM "artists";
SELECT * FROM "collections";
SELECT * FROM "created";

DELETE FROM "artists" WHERE "name" = 'Unidentified artist';
-- Runtime error: FOREIGN KEY constraint failed (19)

DELETE FROM "created" WHERE "artist_id" = (
    SELECT "id" FROM "artists" WHERE "name" = 'Unidentified artist'
);
DELETE FROM "artists" WHERE "name" = 'Unidentified artist';
-- Successful
*/

i/*
PRAGMA foreign_keys = ON;

DROP TABLE "collections";
DROP TABLE "artists";
DROP TABLE "created";

.read 4_schema_foreign_on_delete.sql
.schema

INSERT INTO "artists" ("id", "name")
VALUES
(1, 'Li Yin'),
(2, 'Qian Weicheng'),
(3, 'Unidentified artist'),
(4, 'Zhou Chen');

INSERT INTO "collections" ("id", "title", "accession_number", "acquired")
VALUES 
(1, 'Farmers working at dawn', '11.6152', '1911-08-03'),
(2, 'Imaginative landscape', '56.496', NULL),
(3, 'Profusion of flowers', '56.257' , '1956-04-12'),
(4, 'Peonies and butterfly', '06.1899', '1906-01-01');

INSERT INTO "created" ("artist_id", "collection_id")
VALUES 
(1, 2),
(2, 3),
(3, 1),
(4, 4);

DELETE FROM "artists" WHERE "name" = 'Unidentified artist';
SELECT * FROM "artists";
SELECT * FROM "created";
*/


-- Updating
PRAGMA foreign_keys = ON;

DROP TABLE "collections";
DROP TABLE "created";
DROP TABLE "artists";

.read 4_schema_foreign_on_delete.sql
.schema

INSERT INTO "artists" ("id", "name")
VALUES
(1, 'Li Yin'),
(2, 'Qian Weicheng'),
(3, 'Unidentified artist'),
(4, 'Zhou Chen');

INSERT INTO "collections" ("id", "title", "accession_number", "acquired")
VALUES 
(1, 'Farmers working at dawn', '11.6152', '1911-08-03'),
(2, 'Imaginative landscape', '56.496', NULL),
(3, 'Profusion of flowers', '56.257' , '1956-04-12'),
(4, 'Peonies and butterfly', '06.1899', '1906-01-01');

INSERT INTO "created" ("artist_id", "collection_id")
VALUES 
(1, 2),
(2, 3),
(3, 1),
(4, 4);

UPDATE "created" SET "artist_id" = (
    SELECT "id" FROM "artists" 
    WHERE "name" = 'Li Yin'
)
WHERE "collection_id" = (
    SELECT "id" FROM "collections" 
    WHERE "title" = 'Farmers working at dawn'
);

SELECT * FROM "created";



.open votes.db
.import --csv 4_votes.csv votes
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


-- Triggers
.schema
.open mfa_updated.db
.read 4_schema_triggers.sql

CREATE TABLE "transactions" (
    "id"  INTEGER, 
    "title" TEXT,
    "action" TEXT,
    PRIMARY KEY("id")
);

CREATE TRIGGER "sell" 
BEFORE DELETE ON "collections"
FOR EACH ROW
BEGIN
    INSERT INTO "transactions" ("title", "action")
    VALUES (OLD."title", 'sold');
END;

DELETE FROM "collections" WHERE "title"='Profusion of flowers';

SELECT * FROM "collections";
SELECT * FROM "transactions";

CREATE TRIGGER "buy"
AFTER INSERT ON "collections"
FOR EACH ROW
BEGIN
    INSERT INTO "transactions" ("title", "action")
    VALUES (NEW."title", 'bought');
END;

INSERT INTO "collections" ("title", "accession_number", "acquired")
VALUES ('Profusion of flowers', '56.247', '1956-04-12');

SELECT * FROM "collections";
SELECT * FROM "transactions";


-- Soft deletion
.schema collections
ALTER TABLE "collections" ADD COLUMN "deleted" INTEGER DEFAULT 0;
SELECT * FROM "collections";

UPDATE "collections" SET "deleted" = 1 WHERE "title" = 'Farmers working at dawn';
SELECT * FROM "collections";
SELECT * FROM "collections" WHERE "deleted" != 1;
SELECT * FROM "collections" WHERE "deleted" = 1;



