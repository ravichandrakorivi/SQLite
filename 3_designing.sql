-- sqlite3
.mode box

-- Open longlist.db
.open longlist.db

-- Check how the longlist.db database has been created
.schema

/*
CREATE TABLE IF NOT EXISTS "longlist" ("isbn" TEXT, "title" TEXT, "author" TEXT, "format" TEXT, "pages" INTEGER, "publisher" TEXT, "published" TEXT, "year" INTEGER "votes" INTEGER "rating" REAL);
*/


-- Now open longlist_rel.db
.open longlist_rel.db

-- Check how the longlist_rel.db has been created
.schema

/*
CREATE TABLE IF NOT EXISTS "authors" (
    "id" INTEGER,
    "name" TEXT,
    "country" TEXT,
    "birth" INTEGER,
    PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "authored" (
    "author_id" INTEGER,
    "book_id" INTEGER,
    FOREIGN KEY("author_id") REFERENCES "authors"("id"),
    FOREIGN KEY("book_id") REFERENCES "books"("id")
);
CREATE TABLE IF NOT EXISTS "books" (
    "id" INTEGER,
    "isbn" TEXT,
    "title" TEXT,
    "publisher_id" INTEGER,
    "format" TEXT,
    "pages" INTEGER,
    "published" TEXT,
    "year" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("publisher_id") REFERENCES "publishers"("id")
);
CREATE TABLE IF NOT EXISTS "publishers" (
    "id" INTEGER,
    "publisher" TEXT,
    PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "ratings" (
    "book_id" INTEGER,
    "rating" INTEGER,
    FOREIGN KEY("book_id") REFERENCES "books"("id")
);
CREATE TABLE IF NOT EXISTS "translators" (
    "id" INTEGER,
    "name" TEXT,
    PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "translated" (
    "translator_id" INTEGER,
    "book_id" INTEGER,
    FOREIGN KEY("translator_id") REFERENCES "translators"("id"),
    FOREIGN KEY("book_id") REFERENCES "books"("id")
);
*/

-- Schema of just the books tables
.schema "books"

/*
CREATE TABLE IF NOT EXISTS "books" (
    "id" INTEGER,
    "isbn" TEXT,
    "title" TEXT,
    "publisher_id" INTEGER,
    "format" TEXT,
    "pages" INTEGER,
    "published" TEXT,
    "year" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("publisher_id") REFERENCES "publishers"("id")
);
*/


/****************** DESIGNING *********************/
-- create a brand new database
.open mbta.db

.schema
-- It will give nothing as there are no tables yet in the database


CREATE TABLE "riders" (
	"id",
	"name"
);

.schema

CREATE TABLE "stations" (
	"id",
	"name",
	"line"
);
.schema

CREATE TABLE "visits" (
	"rider_id",
	"station_id"
);
.schema


-- Delete the tables
DROP TABLE "riders";
DROP TABLE "stations";
DROP TABLE "visits"
.schema


.read schema.sql
.schema


