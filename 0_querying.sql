/********************* Querying ********************************/

-- .shell cls;
/*.shell clear*/;


/*** SELECT ***/
-- Get the list of tables in a database
.tables
SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;

SELECT * FROM "longlist";

/*Get the column names of a table from the database.
Returns in the following format
cid | name | type | notnull | default_value | pk*/
PRAGMA table_info(longlist);

SELECT "title" FROM "longlist";
SELECT "title", "author" FROM "longlist";
/*******************************************/


/*** LIMIT ***/
SELECT "title" FROM "longlist" LIMIT 10;
/**********************************/


/*** WHERE ***/
SELECT "title", "author" FROM "longlist" WHERE "year"=2023 LIMIT 5;

-- pretty look
.headers on
.mode box
SELECT "title", "author" FROM "longlist" WHERE "year"=2023 LIMIT 5;
SELECT "title", "format" FROM "longlist" WHERE "format"!='hardcover' LIMIT 10;
SELECT "title", "format" FROM "longlist" WHERE "format"<>'hardcover' LIMIT 10;
SELECT "title", "format" FROM "longlist" WHERE NOT "format"='hardcover' LIMIT 10;

SELECT "title", "author" FROM "longlist" WHERE "year"=2023 OR "year"=2022 LIMIT 10;
SELECT "title", "format" FROM "longlist" WHERE ("year"=2023 OR "year"=2022) AND (format!='hardcover') LIMIT 10;
/*******************************************/


/*** NULL ***/
SELECT "title", "translator" from "longlist" WHERE "translator" IS NULL;
SELECT "title", "translator" from "longlist" WHERE "translator" IS NOT NULL LIMIT 10;
/**********************************/


/*** LIKE - Matching ***/
-- % matches any number of characters
-- _ matches exactly one character
SELECT "title" FROM "longlist" WHERE "title" LIKE '%love%';
SELECT "title" FROM "longlist" WHERE "title" LIKE 'The %';
SELECT "title" FROM "longlist" WHERE "title" LIKE 'P_re';

-- LIKE is case insensitive
SELECT "title" FROM "longlist" WHERE "title" LIKE 'pyre';
SELECT "title" FROM "longlist" WHERE "title" LIKE 'Pyre';

-- = is case sensitive 
SELECT "title" FROM "longlist" WHERE "title" = 'pyre';
SELECT "title" FROM "longlist" WHERE "title" = 'Pyre';
/********************************/


/*** Ranges ***/
SELECT "title", "year" FROM "longlist" WHERE "year" >= 2019 AND "year" <= 2022;
SELECT "title", "year" FROM "longlist" WHERE "year" BETWEEN 2019 AND 2022;
SELECT "title", "rating" FROM "longlist" WHERE "rating" > 4.0;
SELECT "title", "rating", "votes" FROM "longlist" WHERE "rating" > 4.0 AND "votes" > 10000;
SELECT "title", "pages" FROM "longlist" WHERE "pages" < 300;
/************************************/


/*** ORDER BY ***/
SELECT "title", "rating" FROM "longlist" ORDER BY "rating" LIMIT 10;
SELECT "title", "rating" FROM "longlist" ORDER BY "rating" ASC LIMIT 10;
SELECT "title", "rating" FROM "longlist" ORDER BY "rating" DESC LIMIT 10;
SELECT "title", "rating", "votes" FROM "longlist" ORDER BY "rating" DESC, "votes" DESC LIMIT 10;
SELECT "title" FROM "longlist" ORDER BY "title" LIMIT 10;
SELECT "title" FROM "longlist" ORDER BY "title" DESC LIMIT 10;
/***************************/


/*** Aggregate Functions ***/
SELECT AVG("rating") FROM "longlist";
SELECT ROUND(AVG("rating")) FROM "longlist";
SELECT ROUND(AVG("rating"), 2) FROM "longlist";
SELECT ROUND(AVG("rating"), 2) AS "average rating" FROM "longlist";
SELECT MAX("rating") FROM "longlist";
SELECT MIN("rating") FROM "longlist";
SELECT MAX("title"), MIN("title") FROM "longlist";
SELECT SUM("votes") FROM "longlist";
SELECT COUNT(*) FROM "longlist";
SELECT COUNT("translator") FROM "longlist";
SELECT COUNT("publisher") FROM "longlist";
SELECT DISTINCT("publisher") FROM "longlist";
SELECT COUNT(DISTINCT("publisher")) FROM "longlist";
/**************************/

.quit
