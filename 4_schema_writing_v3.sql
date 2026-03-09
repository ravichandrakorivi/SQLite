DROP TABLE IF EXISTS "created";
DROP TABLE IF EXISTS "artists";
DROP TABLE IF EXISTS "collections";
DROP TABLE IF EXISTS "transactions";
DROP TRIGGER IF EXISTS "sell";
DROP TRIGGER IF EXISTS "buy";

CREATE TABLE IF NOT EXISTS "collections" (
    "id" INTEGER,
    "title" TEXT NOT NULL,
    "accession_number" TEXT NOT NULL UNIQUE,
    "acquired" NUMERIC,
    PRIMARY KEY("id")
);

CREATE TABLE IF NOT EXISTS "artists" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE IF NOT EXISTS "created" (
    "artist_id" INTEGER,
    "collection_id" INTEGER,
    PRIMARY KEY("artist_id", "collection_id"),
    FOREIGN KEY("artist_id") REFERENCES "artists"("id") ON DELETE CASCADE,
    FOREIGN KEY("collection_id") REFERENCES "collections"("id") ON DELETE CASCADE
);

-- Possible options for ON DELETE
-- ON DELETE RESTRICT
-- ON DELETE NO ACTION
-- ON DELETE SET NULL
-- ON DELETE SET DEFAULT
-- ON DELETE CASCADE

INSERT INTO "artists" ("id", "name")
VALUES
(1, 'Li Yin'),
(2, 'Qian Weicheng'),
(3, 'Unidentified artist'),
(4, 'Zhou Chen');

INSERT INTO "collections" ("id", "title", "accession_number", "acquired")
VALUES 
(1, 'Farmers working at dawn', '11.6152', '1911-08-03'),
(2, 'Imaginative landscape', '56.496', NULL),
(3, 'Profusion of flowers', '56.257' , '1956-04-12'),
(4, 'Peonies and butterfly', '06.1899', '1906-01-01');

INSERT INTO "created" ("artist_id", "collection_id")
VALUES 
(1, 2),
(2, 3),
(3, 1),
(4, 4);

