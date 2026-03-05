---------------------------------------------------------------------------------
-- Soft deletion
---------------------------------------------------------------------------------
.open artwork.db
.mode box

DROP TABLE IF EXISTS "collections";
DROP TABLE IF EXISTS "created";
DROP TABLE IF EXISTS "artists";

.read 4_schema_triggers.sql

.schema collections
ALTER TABLE "collections" ADD COLUMN "deleted" INTEGER DEFAULT 0;
SELECT * FROM "collections";

UPDATE "collections" SET "deleted" = 1 WHERE "title" = 'Farmers working at dawn';
SELECT * FROM "collections";
SELECT * FROM "collections" WHERE "deleted" != 1;
SELECT * FROM "collections" WHERE "deleted" = 1;


