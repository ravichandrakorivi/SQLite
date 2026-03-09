------------------------------------------------------------------------------------------------
------------------------------------------- Triggers -------------------------------------------
------------------------------------------------------------------------------------------------
.open collections.db
.mode box

.schema
.read 5_schema_triggers.sql
.schema

CREATE TABLE IF NOT EXISTS "transactions" (
    "id" INTEGER,
    "title" TEXT,
    "action" TEXT,
    PRIMARY KEY("id")
);

CREATE TRIGGER "sell"
BEFORE DELETE ON "collections"
FOR EACH ROW
BEGIN
    INSERT INTO "transactions" ("title", "action")
    VALUES (OLD."title", 'sold')
END;

.schema

SELECT * FROM "created";
SELECT * FROM "artists";
SELECT * FROM "collections";
SELECT * FROM "transactions";

DELETE FROM "collections" WHERE "title" = 'Profusion of flowers';

SELECT * FROM "collections";
SELECT * FROM "transactions";

CREATE TRIGGER "buy"
AFTER INSERT ON "collections"
FOR EACH ROW
BEGIN
    INSERT INTO "transactions" ("title", "action")
    VALUES (NEW."title", 'bought')
END;

INSERT INTO "collections" ("title", "accession_number", "acquired")
VALUES ('Profusion of flowers', '56.247', '1956-04-12');

SELECT * FROM "collections";
SELECT * FROM "transactions";

