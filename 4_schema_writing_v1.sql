DROP TABLE IF EXISTS "created";
DROP TABLE IF EXISTS "artists";
DROP TABLE IF EXISTS "collections";
DROP TABLE IF EXISTS "transactions";
DROP TRIGGER IF EXISTS "sell";
DROP TRIGGER IF EXISTS "buy";

CREATE TABLE "collections" (
    "id" INTEGER,
    "title" TEXT NOT NULL,
    "accession_number" TEXT NOT NULL UNIQUE,
    "acquired" NUMERIC,
    PRIMARY KEY("id")
);

