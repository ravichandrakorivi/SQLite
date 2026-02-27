-- sqlite3 mfa.db
.schema

.read 4_schema.sql

.mode box
SELECT * FROM "collections";

INSERT INTO "collections" ("id", "title", "accession_number", "acquired")
VALUES (1, 'Profusion of flowers', '56.257', '1956-04-12');

INSERT INTO "collections" ("id", "title", "accession_number", "acquired")
VALUES (2, 'Farmers working in dawn', '11.6152', '1911-08-03');

-- sqlite will automatically increment the primary key for us
INSERT INTO "collections" ("title", "accession_number", "acquired")
VALUES ('Spring outing', '14.76', '1914-01-08');

