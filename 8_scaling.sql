
/****************************** MySQL ***********************************/
# mysql -u root -h 127.0.0.1 -P 3306 -p
-- mysql -u root -h localhost -P 3306 -p

# -u : user

# -h : host server
-- 127.0.0.1 host uses TCP/IP type of connection 
-- localhost host uses Unix socket / named pipe type of connection

# -P : port number
# -p : passowrd

SHOW DATABASES;

CREATE DATABASE `mbta`;
SHOW DATABASES;

USE `mbta`;
SHOW TABLES;


/********************** Integer Data types **************************/
-- TINYINT    : 1 Byte
-- SMALLINT   : 2 Bytes 
-- MEDIUMINT  : 3 Bytes
-- INT        : 4 Bytes
-- BIGINT     : 8 Bytes


/*
CREATE TABLE `cards` (
    `id` INT SIGNED AUTO_INCREMENT,
    PRIMARY KEY(`id`)
);

CREATE TABLE `cards` (
    `id` INT AUTO_INCREMENT,
    PRIMARY KEY(`id`)
);

# INT is implicitely signed
*/

CREATE TABLE `cards` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    PRIMARY KEY(`id`)
);

SHOW TABLES;
DESCRIBE `cards`;


/************************************ String Data Types **************************/
-- CHAR(M)    : Fixed length string
-- VARCHAR(M) : Variable length string
-- TEXT       : For longer chunks of text
    -- TINY TEXT
    -- TEXT
    -- MEDIUMTEXT
    -- LONGTEXT
-- BLOB       : Binary large object : a string data type used to store binary data like images, audio/video, pdf etc. files
-- ENUM       : a string data type that allows a column to store one value from a predefined list of values
-- SET        : a string data type that allows a column to store zero, one, or multiple values from a predefined list

CREATE TABLE `stations` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `name` VARCHAR(32) NOT NULL UNIQUE,
    `line` ENUM('blue', 'green', 'orange', 'red') NOT NULL,
    PRIMARY KEY(`id`)
);

SHOW TABLES;
DESCRIBE `stations`;


/*********************** Date & Time Data Types ************************/
-- DATE
-- TIME(fsp)
-- DATETIME(fsp)
-- TIMESTAMP(fsp)
-- YEAR

# fsp : fractional seconds precision.
# It specifies how many digits of fractional seconds (microseconds) are stored.

/********************** Real Number Data Types ****************************/
-- FLOAT            : 4 bytes
-- DOUBLE PRECISION : 8 bytes
-- DECIMAL(M,D)     : Fixed precision real number data type

# Floating-point imprecision

# DECIMAL(5,2) : can represent data from -999.99 to +999.99
# DECIMAL(6,2) : can represent data from -9999.99 to +9999.99
# DECIMAL(7,4) : can represent data from -999.9999 to +999.9999


CREATE TABLE `swipes` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `card_id` INT UNSIGNED,
    `station_id` INT UNSIGNED,
    `type` ENUM('enter', 'exit', 'deposit') NOT NULL,
    `datetime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `amount` DECIMAL(5,2) NOT NULL CHECK(`amount` != 0),
    PRIMARY KEY(`id`),
    FOREIGN KEY(`card_id`) REFERENCES `cards`(`id`),
    FOREIGN KEY(`station_id`) REFERENCES `stations`(`id`)
);

SHOW TABLES;
DESCRIBE `swipes`;

system cls
\! cls


/******************************** Alter Tables *********************************/
ALTER TABLE `stations` MODIFY `line` ENUM('blue', 'green', 'orange', 'red', 'silver') NOT NULL;

DESCRIBE `stations`;


/******************************* Stored Procedures *****************************/

CREATE DATABASE `mfa`;
SHOW DATABASES;

USE `mfa`;
SHOW TABLES;

CREATE TABLE `collections` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(64) NOT NULL,
    `accession_number` VARCHAR(9) NOT NULL UNIQUE,
    `acquired` DATE,
    PRIMARY KEY(`id`)
);

ALTER TABLE `collections` ADD COLUMN `deleted` TINYINT DEFAULT 0;

DESCRIBE `collections`;

INSERT INTO `collections` (`title`, `accession_number`, `acquired`)
VALUES
('Farmers working at dawn', '11.6152', '1911-08-03'),
('Imaginative landscape', '56.496', NULL),
('Profusion of flowers', '56.257', '1956-04-12'),
('Spring outing', '14.76', '1914-01-08');

delimiter //

CREATE PROCEDURE `current_collection`()
BEGIN
SELECT `title`, `accession_number`, `acquired`
FROM `collections` WHERE `deleted` = 0;
END//

delimiter ;

SHOW CREATE PROCEDURE `current_collection`;

CALL `current_collection`();

UPDATE `collections` SET `deleted` = 1 WHERE `title` = 'Farmers working at dawn';

CALL `current_collection`();


CREATE TABLE `transactions` (
    `id` INT AUTO_INCREMENT,
    `title` VARCHAR(64) NOT NULL,
    `action` ENUM('bought', 'sold') NOT NULL,
    PRIMARY KEY(`id`)
);

SHOW TABLES;

delimiter //

CREATE PROCEDURE `sell` (IN `sold_id` INT)
BEGIN
UPDATE `collections` SET `deleted` = 1
WHERE `id` = `sold_id`;

INSERT INTO `transactions` (`title`, `action`)
VALUES ((SELECT `title` FROM `collections` WHERE `id` = `sold_id`), 'sold');
END//

delimiter ;

SELECT * FROM `collections`;

CALL `sell`(2);

SELECT * FROM `collections`;
SELECT * FROM `transactions`;


/*********************************** PostgreSQL ***************************************/

