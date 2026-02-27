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

/* Primary key constraint will automatically impose column constriants like "NOT NULL", "UNIQUE" on "id" column*/


/*
CREATE TABLE "riders" (
    "id" INTEGER,
    "name" TEXT,
    PRIMARY KEY("id")
);

CREATE TABLE "stations" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "line" TEXT NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE "visits" (
    "rider_id" INTEGER,
    "station_id" INTEGER,
    FOREIGN KEY("rider_id") REFERENCES "riders"("id"),
    FOREIGN KEY("station_id") REFERENCES "stations"("id")
);


ALTER TABLE "visits" RENAME TO "swipes";
.schema

ALTER TABLE "swipes" ADD COLUMN "ttpe" TEXT;
.schema

ALTER TABLE "swipes" RENAME COLUMN "ttpe" TO "type";
.schema

ALTER TABLE "swipes" DROP COLUMN "type";
.schema


DROP TABLE "riders";
DROP TABLE "stations";
DROP TABLE "swipes";
.schema
*/



/********* Revised Scheme ******************/

CREATE TABLE "cards" (
    "id" INTEGER,
    PRIMARY KEY("id")
);


CREATE TABLE "stations" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "line" TEXT NOT NULL
);

CREATE TABLE "swipes" (
    "id" INTEGER,
    "card_id" INTEGER,
    "station_id" INTEGER,
    "type" TEXT NOT NULL CHECK("type" IN ('enter', 'exit', 'deposit')),
    "datetime" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "amount" NUMERIC NOT NULL CHECK("amount" != 0),
    PRIMARY KEY("id"),
    FOREIGN KEY("card_id") REFERENCES "cards"("id"),
    FOREIGN KEY("station_id") REFERENCES "stations"("id")
);


