------------------------------------------------------------------------------------------
-- Triggers
------------------------------------------------------------------------------------------

.open artwork.db
.mode box

DROP TABLE IF EXISTS "collections";
DROP TABLE IF EXISTS "created";
DROP TABLE IF EXISTS "artists";

.read 4_schema_triggers.sql
.schema

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

DROP TRIGGER "sell";
DROP TRIGGER "buy";
DROP TABLE "transactions";


