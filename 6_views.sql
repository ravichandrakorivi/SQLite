-------------------------------------------------------------------------------------
-- VIEWS : Virtual table defined by a query
      -- VIEW
      -- TEMPORARY VIEW
      -- CTE
-------------------------------------------------------------------------------------

-- sqlite3
.open longlist_rel.db
.schema

-- books written by Fernanda Melchor
SELECT "title" FROM "books"  WHERE "id" IN (
    SELECT "book_id" FROM "authored" WHERE "author_id" = (
        SELECT "id" FROM "authors" WHERE "name" = 'Fernanda Melchor'
    )
);

SELECT "name", "title" FROM "authors" 
JOIN "authored" ON "authors"."id" = "authored"."author_id"
JOIN "books" ON "authored"."book_id" = "books"."id";

CREATE VIEW "author_title" AS 
SELECT "name", "title" FROM "authors"
JOIN "authored" ON "authors"."id" = "authored"."author_id"
JOIN "books" ON "authored"."book_id" = "books"."id";

.schema

SELECT * FROM "author_title";
SELECT "name", "title" FROM "author_title" ORDER BY "name", "title";

-- books written by Fernanda Melchor
SELECT "title" FROM "author_title" WHERE "name" = 'Fernanda Melchor';


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

-- View exists permanently in the database
-- Temporary View exists only for the duration of the connection with the database

SELECT "year", ROUND(AVG("rating"), 2) AS "rating" FROM "average_book_ratings" GROUP BY "year";

CREATE TEMPORARY VIEW "average_ratings_by_year" AS 
SELECT "year", ROUND(AVG("rating"), 2) AS "rating" FROM "average_book_ratings" GROUP BY "year";

SELECT * FROM "average_ratings_by_year";

.quit
-- sqlite3
.open longlist_rel.db
.schema 

--------------------------------------------------------------------------------
-- CTE : Commom Table Expression
-- CTE is simply a view which exists for the duration of a single query
--------------------------------------------------------------------------------
DROP VIEW "average_book_ratings";

WITH "average_book_ratings" AS (
    SELECT "book_id", "title", "year", ROUND(AVG("rating"), 2) AS "rating"
    FROM "ratings" JOIN "books" ON "ratings"."book_id" = "books"."id"
    GROUP BY "book_id"
) SELECT "year", ROUND(AVG("rating"), 2) AS "rating" FROM "average_book_ratings" GROUP BY "year";


------------------------------------------------------------------------------------
-- Partitioning
------------------------------------------------------------------------------------
CREATE VIEW "2022" AS
SELECT "id", "title" FROM "books"
WHERE "year" = 2022;

SELECT * FROM "2022";

CREATE VIEW "2021" AS
SELECT "id", "title" FROM "books"
WHERE "year" = 2021;

SELECT * FROM "2021";


-------------------------------------------------------------------------------------
-- Securing
-------------------------------------------------------------------------------------
.open rideshare.db
.schema
SELECT * FROM "rides";

SELECT "id", "origin", "destination" FROM "rides";

SELECT "id", "origin", "destination", 'Anonymous' AS "rider" FROM "rides";

CREATE VIEW "analysis" AS 
SELECT "id", "origin", "destination", 'Anonymous' AS "rider" FROM "rides";

SELECT * FROM "analysis";

