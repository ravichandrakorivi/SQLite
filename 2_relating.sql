/************************* Relating ***************************/
-- sqlite3 longlist_rel.db

-- Get the list of tables in the database
.tables

/*** Have a quick look at the tables ***/
SELECT * FROM "authored" LIMIT 2;
SELECT * FROM "books" LIMIT 2;
SELECT * FROM "ratings" LIMIT 2;
SELECT * FROM "translators" LIMIT 2;
SELECT * FROM "authors" LIMIT 2;
SELECT * FROM "publishers" LIMIT 2;
SELECT * FROM "translated" LIMIT 2;
/***************************************/


/************************ Sub Queries **************************/

-- Books published by the publisher 'MecLehose Press'
SELECT "id" FROM "publishers" WHERE "publisher" = 'MacLehose Press';
SELECT "title" FROM "books" WHERE "publisher_id" = 12;
SELECT "title" FROM "books" WHERE "publisher_id" = (SELECT "id" FROM "publishers" WHERE "publisher" = 'MacLehose Press');

-- Ratings for the book 'In Memory of Memory'
SELECT "id" FROM "books" WHERE "title" = 'In Memory of Memory';
SELECT "rating" FROM "ratings" WHERE "book_id" = 33;
SELECT "rating" FROM "ratings" WHERE "book_id" = (SELECT "id" FROM "books" WHERE "title" = 'In Memory of Memory');

-- Find the average rating for the book 'In Memory of Memory'
SELECT ROUND(AVG("rating"), 2) FROM "ratings" WHERE "book_id" = (SELECT "id" FROM "books" WHERE "title" = 'In Memory of Memory');

-- Find the author name for the book 'The Birthday Party' 
SELECT "id" FROM "books" WHERE "title" = 'The Birthday Party
';
SELECT "author_id" FROM "authored" WHERE "book_id" = (
    SELECT "id" FROM "books" WHERE "title" = 'The Birthday Party'
);
SELECT "name" FROM "authors" WHERE "id" = (
    SELECT "author_id" FROM "authored" WHERE "book_id" = (
        SELECT "id" FROM "books" WHERE "title" = 'The Birthday Party'  
    )
);
/*******************************************************************/


/**************************** JOIN ********************************/
-- .quit
-- sqlite3 sea_lions.db

-- List of tables in the database
.tables

-- Quit look the tables
SELECT * FROM "sea_lions" ;
SELECT * FROM "migrations";

-- INNER JOIN
SELECT * FROM "sea_lions" JOIN "migrations" ON "migrations"."id"="sea_lions"."id";
SELECT * FROM "sea_lions" JOIN "migrations" ON "sea_lions"."id"="migrations"."id";
SELECT * FROM "sea_lions" INNER JOIN "migrations" ON "migrations"."id"="sea_lions"."id";


-- OUTER JOIN

-- LEFT JOIN
SELECT * FROM "sea_lions" LEFT JOIN "migrations" ON "migrations"."id"="sea_lions"."id";
SELECT * FROM "sea_lions" LEFT OUTER JOIN "migrations" ON "migrations"."id"="sea_lions"."id";

-- RIGHT JOIN
SELECT * FROM "sea_lions" RIGHT JOIN "migrations" ON "migrations"."id"="sea_lions"."id";

-- FULL JOIN
SELECT * FROM "sea_lions" FULL JOIN "migrations" ON "migrations"."id"="sea_lions"."id";

-- NATURAL JOIN
SELECT * FROM "sea_lions" NATURAL JOIN "migrations";
/*******************************************************/


/*************** SETS ******************/
-- sqlite3 longlist_rel.db
SELECT "name" FROM "authors";
SELECT "name" FROM "translators";

SELECT "name" FROM "translators" UNION SELECT "name" FROM "authors";

-- Keeps duplicates
SELECT "name" FROM "authors" UNION ALL SELECT "name" FROM "translators";

SELECT 'author' AS "profession", "name" FROM "authors";
SELECT 'translator' AS "profession", "name" FROM "translators";

SELECT 'author' AS "profession", "name" FROM "authors" 
UNION 
SELECT 'translator' AS "profession", "name" FROM "translators";

SELECT "name" FROM "authors" INTERSECT SELECT "name" FROM "translators";

SELECT "name" FROM "authors" EXCEPT SELECT "name" FROM "translators";


SELECT COUNT(*) FROM "authors";
-- n(A) = 72

SELECT COUNT(*) FROM "translators";
-- n(B) = 74

SELECT COUNT(*) FROM (SELECT "name" FROM "authors" INTERSECT SELECT "name" FROM "translators");
-- n(A AND B) = 1

SELECT COUNT(*) FROM (SELECT "name" FROM "authors" UNION SELECT "name" FROM "translators");
-- n(A OR B) = 145 = n(A) + n(B) - n(A AND B)

SELECT COUNT(*) FROM (SELECT "name" FROM "authors" UNION ALL SELECT "name" FROM "translators");
-- n(A)+n(B)

SELECT COUNT(*) FROM (SELECT "name" FROM "authors" EXCEPT SELECT "name" FROM "translators");
-- n(A NOT B) = 71

SELECT COUNT(*) FROM (SELECT "name" FROM "translators" EXCEPT SELECT "name" FROM "authors");
-- n(B NOT A) = 73


SELECT COUNT(*) FROM (
    SELECT "name" FROM (
        SELECT "name" FROM "authors"
        EXCEPT
        SELECT "name" FROM "translators"
    )
    UNION ALL
    SELECT "name" FROM (
        SELECT "name" FROM "translators"
        EXCEPT
        SELECT "name" FROM "authors"
    )
);
-- 144


SELECT "book_id" FROM "translated" WHERE "translator_id" = (
    SELECT "id" FROM "translators" WHERE "name" = 'Sophie Hughes'
);

SELECT "book_id" FROM "translated" WHERE "translator_id" = (
    SELECT "id" FROM "translators" WHERE "name" = 'Margaret Jull Costa'
);

-- Books collaborated by 'Sophie Hughes & Margeret Jull Costa'
SELECT "book_id" FROM "translated" WHERE "translator_id" = (
    SELECT "id" FROM "translators" WHERE "name" = 'Sophie Hughes') 
INTERSECT 
SELECT "book_id" FROM "translated" WHERE "translator_id" = (
    SELECT "id" FROM "translators" WHERE "name" = 'Margaret Jull Costa'
);
/***********************************************************************/



/**************** GROUP BY ************************************/
SELECT "book_id", COUNT("rating") FROM "ratings" 
GROUP BY "book_id";

SELECT "book_id", ROUND(AVG("rating"), 2) AS "average rating" 
FROM "ratings"
GROUP BY "book_id"
HAVING "average rating" > 4.0
ORDER BY "average rating" DESC;


