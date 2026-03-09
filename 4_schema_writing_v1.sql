DROP TABLE IF EXISTS "created";
DROP TABLE IF EXISTS "artists";
DROP TABLE IF EXISTS "collections";

CREATE TABLE "collections" (
    "id" INTEGER,
    "title" TEXT NOT NULL,
    "accession_number" TEXT NOT NULL UNIQUE,
    "acquired" NUMERIC,
    PRIMARY KEY("id")
);

