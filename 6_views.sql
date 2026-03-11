-------------------------------------------------------------------------------------
--------------------- VIEWS : Virtual table defined by a query ----------------------
-- VIEW
-- TEMPORARY VIEW
-- CTE (Comman Table Expression)
-------------------------------------------------------------------------------------

-- sqlite3
.open longlist_rel.db
.schema


--------------------------------------------------------------------------------
---------------------------------- VIEW ----------------------------------------
--------------------------------------------------------------------------------

-- View once created, exists permanently in the database unless deleted.

-
-- books written by Fernanda Melchor
SELECT "title" FROM "books"  WHERE "id" IN (
    SELECT "book_id" FROM "authored" WHERE "author_id" = (
        SELECT "id" FROM "authors" WHERE "name" = 'Fernanda Melchor'
    )
);

SELECT "name", "title" FROM "authors" 
JOIN "authored" ON "authors"."id" = "authored"."author_id"
JOIN "books" ON "authored"."book_id" = "books"."id";

CREATE VIEW "longlist" AS 
SELECT "name", "title" FROM "authors"
JOIN "authored" ON "authors"."id" = "authored"."author_id"
JOIN "books" ON "authored"."book_id" = "books"."id";

.schema

SELECT * FROM "longlist";
SELECT "name", "title" FROM "longlist" ORDER BY "name", "title";

-- books written by Fernanda Melchor
SELECT "title" FROM "longlist" WHERE "name" = 'Fernanda Melchor';


-- Average ratings of different books
SELECT "book_id", ROUND(AVG("rating"), 2) AS "rating" FROM "ratings" GROUP BY "book_id";

SELECT "book_id", "title", "year", ROUND(AVG("rating"), 2) AS "rating" 
FROM "ratings" JOIN "books" ON "ratings"."book_id" = "books"."id"
GROUP BY "book_id";


CREATE VIEW "average_book_ratings" AS 
SELECT "book_id", "title", "year", ROUND(AVG("rating"), 2) AS "rating"
FROM "ratings" JOIN "books" ON "ratings"."book_id" = "books"."id"
GROUP BY "book_id";

SELECT * FROM "average_book_ratings";


-----------------------------------------------------------------------------------------------
-------------------------------------- TEMPORARY VIEW -----------------------------------------
-----------------------------------------------------------------------------------------------

-- Temporary View exists only for the duration of the connection with the database


SELECT "year", ROUND(AVG("rating"), 2) AS "rating" FROM "average_book_ratings" GROUP BY "year";

CREATE TEMPORARY VIEW "average_ratings_by_year" AS 
SELECT "year", ROUND(AVG("rating"), 2) AS "rating" FROM "average_book_ratings" GROUP BY "year";

SELECT * FROM "average_ratings_by_year";

.quit
-- sqlite3
.open longlist_rel.db
.schema 



-----------------------------------------------------------------------------------------------
-------------------------------- CTE : Commom Table Expression --------------------------------
-----------------------------------------------------------------------------------------------

-- CTE is simply a view which exists for the duration of a single query

DROP VIEW "average_book_ratings";

WITH "average_book_ratings" AS (
    SELECT "book_id", "title", "year", ROUND(AVG("rating"), 2) AS "rating"
    FROM "ratings" JOIN "books" ON "ratings"."book_id" = "books"."id"
    GROUP BY "book_id"
) SELECT "year", ROUND(AVG("rating"), 2) AS "rating" FROM "average_book_ratings" GROUP BY "year";




-----------------------------------------------------------------------------------------------
--------------------------------------- Partitioning ------------------------------------------
-----------------------------------------------------------------------------------------------
CREATE VIEW "2022" AS
SELECT "id", "title" FROM "books"
WHERE "year" = 2022;

SELECT * FROM "2022";

CREATE VIEW "2021" AS
SELECT "id", "title" FROM "books"
WHERE "year" = 2021;

SELECT * FROM "2021";


DROP VIEW IF EXISTS "longlist";
DROP VIEW IF EXISTS "2022";
DROP VIEW IF EXISTS "2021";

----------------------------------------------------------------------------------------------
--------------------------------------- Securing ---------------------------------------------
----------------------------------------------------------------------------------------------
.open rideshare.db
.schema
SELECT * FROM "rides";

SELECT "id", "origin", "destination" FROM "rides";

SELECT "id", "origin", "destination", 'Anonymous' AS "rider" FROM "rides";

CREATE VIEW "analysis" AS 
SELECT "id", "origin", "destination", 'Anonymous' AS "rider" FROM "rides";

SELECT * FROM "analysis";

DROP VIEW "analysis";




---------------------------------------------------------------------------------------------
----------------------------------- Soft Deletion with View ---------------------------------
---------------------------------------------------------------------------------------------

.open collections.db
.read 4_schema_writing_v2.sql
.schema

ALTER TABLE "collections" ADD COLUMN "deleted" INTEGER DEFAULT 0;
SELECT * FROM "collections";

-- UPDATE "collections" SET "deleted" = 1 WHERE "title" LIKE 'Farmers%dawn';
UPDATE "collections" SET "deleted" = 1 WHERE "title" = 'Farmers working at dawn';
SELECT * FROM "collections";

SELECT * FROM "collections" WHERE "deleted" = 0;

CREATE VIEW "current_collections" AS
SELECT "id", "title", "accession_number", "acquired"
FROM "collections" WHERE "deleted" = 0;

SELECT * FROM "current_collections";

-- DELETE FROM "current_collections" WHERE "title" = 'Imaginative landscape';
-- Parse error: cannot modify current_collections because it is a view



---------------------------------------------------------------------------------------------
------------------------------------- Triggers with View ------------------------------------
---------------------------------------------------------------------------------------------


CREATE TRIGGER "delete" 
INSTEAD OF DELETE ON "current_collections"
FOR EACH ROW
BEGIN
    UPDATE "collections" SET "deleted" = 1 WHERE "id" = OLD."id";
END;

DELETE FROM "current_collections" WHERE "title" = 'Imaginative landscape';

SELECT * FROM "collections";
SELECT * FROM "current_collections";


-- Contional triggers
CREATE TRIGGER "insert_when_exists"
INSTEAD OF INSERT ON "current_collections"
FOR EACH ROW WHEN NEW."accession_number" IN (SELECT "accession_number" FROM "collections")
BEGIN
    UPDATE "collections" SET "deleted" = 0 WHERE "accession_number" = NEW."accession_number";
END;

INSERT INTO "current_collections" ("title", "accession_number", "acquired")
VALUES ('Imaginative landscape', '56.496', NULL);



CREATE TRIGGER "insert_when_not_exists"
INSTEAD OF INSERT ON "current_collections"
FOR EACH ROW WHEN NEW."accession_number" NOT IN (SELECT "accession_number" FROM "collections")
BEGIN
    INSERT INTO "collections" ("title", "accession_number", "acquired") 
    VALUES (NEW."title", NEW."accession_number", NEW."acquired");
END;

INSERT INTO "current_collections" ("title", "accession_number", "acquired")
VALUES ('Imaginativeee landscapeee', '56.496666', NULL);

SELECT * FROM "collections";
SELECT * FROM "current_collections";

