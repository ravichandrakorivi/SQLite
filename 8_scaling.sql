
/****************************** MySQL ***********************************/
# mysql -u root -h 127.0.0.1 -P 3306 -p
-- mysql -u root -h localhost -P 3306 -p

# -u : user

# -h : host server
-- 127.0.0.1 host uses TCP/IP type of connection 
-- localhost host uses Unix socket / named pipe type of connection

# -P : port number
# -p : passowrd

SHOW DATABASES;				-- There is no equivalent command for this in sqlite3
DROP DATABASE IF EXISTS `bmrc`;		# There is no equivalent command for this in sqlite3

SHOW DATABASES;

CREATE DATABASE `bmrc`;			# There is no equivalent command for this in sqlite3
SHOW DATABASES;

USE `bmrc`;				# Similar to .open in sqlite3
SHOW TABLES;				# Similar to .tables in sqlite3


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

SHOW CREATE TABLE `cards`;		# Similar to .schema "cards" in sqlite3

SHOW TABLES;
DESCRIBE `cards`;

/*

+-------+--------------+------+-----+---------+----------------+
| Field | Type         | Null | Key | Default | Extra          |
+-------+--------------+------+-----+---------+----------------+
| id    | int unsigned | NO   | PRI | NULL    | auto_increment |
+-------+--------------+------+-----+---------+----------------+

“Default = NULL” does NOT mean MySQL will insert NULL.

 As explicit default value is not defined for the `id` column,
 while creating the `cards` table, MySQL uses NULL in 
 the Default column of DESCRIBE to mean:
“No default value is specified”

*/



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

/*
+------------+--------------------------------+------+-----+-------------------+-------------------+
| Field      | Type                           | Null | Key | Default           | Extra             |
+------------+--------------------------------+------+-----+-------------------+-------------------+
| id         | int unsigned                   | NO   | PRI | NULL              | auto_increment    |
| card_id    | int unsigned                   | YES  | MUL | NULL              |                   |
| station_id | int unsigned                   | YES  | MUL | NULL              |                   |
| type       | enum('enter','exit','deposit') | NO   |     | NULL              |                   |
| datetime   | datetime                       | NO   |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| amount     | decimal(5,2)                   | NO   |     | NULL              |                   |
+------------+--------------------------------+------+-----+-------------------+-------------------+

MySQL automatically creates indexes on foreign key columns. 
That’s why you see MUL on `card_id` and `station_id`. 

MUL means:
  -- Column is indexed
  -- But not unique
  -- So multiple rows can have the same value
  -- Column can appear multiple times in the index
  -- Hence, lookup will be faster when searched using foreign key defined columns
*/

system cls
\! cls


/******************************** Alter Tables *********************************/
SHOW CREATE TABLE `stations`;

ALTER TABLE `stations` MODIFY `line` ENUM('blue', 'green', 'orange', 'red', 'silver') NOT NULL;

# There is no equivalent command for this in SQLite.

SHOW CREATE TABLE `stations`;
DESCRIBE `stations`;


/****************************************************************************************/

CREATE DATABASE `collections`;
SHOW DATABASES;

USE `collections`;
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

SELECT * FROM `collections`;
SELECT `id`, `title`, `acquired` FROM `collections`;
SELECT `id`, `title`, `acquired` FROM `collections` WHERE `acquired` < '1947-08-15';
SELECT `id`, `title`, `acquired` FROM `collections` WHERE `accession_number` LIKE '56%';
SELECT `id`, `title`, `acquired` FROM `collections` WHERE `accession_number` LIKE '56%' AND `acquired` IS NOT NULL;
SELECT `id`, `title`, `acquired` FROM `collections` WHERE `accession_number` LIKE '56%' AND `acquired` IS NULL;
SELECT `id`, `title`, `acquired` FROM `collections` WHERE (`accession_number` LIKE '56%' AND `acquired` IS NULL) OR (`title` LIKE '%work%');




/******************************* Stored Procedures *****************************/

/*
mysql> CREATE PROCEDURE `current_collection`() BEGIN
    -> SELECT `title`, `accession_number`, `acquired`
    -> FROM `collections` WHERE `deleted`=0;
ERROR 1064 (42000): You have an error in your SQL syntax; 
check the manual that corresponds to your MySQL server version
for the right syntax to use near '' at line 3
*/


delimiter //

CREATE PROCEDURE `current_collection`()
BEGIN
SELECT `title`, `accession_number`, `acquired`
FROM `collections` WHERE `deleted` = 0;
END//

delimiter ;


SHOW CREATE PROCEDURE `current_collection`;		# Similar to .schema `current_collection` in sqlite3

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

CREATE PROCEDURE `sell` (IN `sold_id` INT) BEGIN
    UPDATE `collections` SET `deleted` = 1 WHERE `id` = `sold_id`;
    INSERT INTO `transactions` (`title`, `action`) VALUES ((SELECT `title` FROM `collections` WHERE `id` = `sold_id`), 'sold');
END//

delimiter ;

SELECT * FROM `collections`;

CALL `sell`(2);

SELECT * FROM `collections`;
SELECT * FROM `transactions`;



---- Simple procedure that returns rows
delimiter //

CREATE PROCEDURE `get_active_collections`()
BEGIN
    SELECT `id`, `title`, `accession_number`, `acquired`
    FROM `collections`
    WHERE `deleted` = 0;
END //

delimiter ;

CALL `get_active_collections`();



---- Procedure with input parameter
delimiter //

CREATE PROCEDURE `get_by_accession_prefix`(IN `prefix` VARCHAR(10))
BEGIN
    SELECT `id`, `title`, `accession_number`, `acquired`
    FROM `collections`
    WHERE `accession_number` LIKE CONCAT(`prefix`, '%')
      AND `deleted` = 0;
END //

delimiter ;

CALL get_by_accession_prefix('56');


---- Procedure returning a single value (using OUT parameter)
delimiter //

CREATE PROCEDURE `count_active`(OUT `total` INT)
BEGIN
    SELECT COUNT(*) INTO `total`
    FROM `collections`
    WHERE `deleted` = 0;
END //
delimiter ;

SHOW PROCEDURE STATUS WHERE Db = DATABASE();



---- IF condition
delimiter //

CREATE PROCEDURE `check_collection`(IN `cid` INT)
BEGIN
    DECLARE `status_msg` VARCHAR(50);

    IF (SELECT `deleted` FROM `collections` WHERE `id` = cid) = 0 THEN
        SET `status_msg` = 'Active';
    ELSE
        SET `status_msg` = 'Deleted';
    END IF;

    SELECT `status_msg`;
END //

delimiter ;

CALL check_collection(3);



---- IF…ELSEIF…ELSE
delimiter //

CREATE PROCEDURE `check_year`(IN `cid` INT)
BEGIN
    DECLARE `y` INT;

    SELECT YEAR(`acquired`) INTO `y` FROM `collections` WHERE `id` = cid;

    IF `y` < 1920 THEN
        SELECT 'Very Old';
    ELSEIF `y` < 2000 THEN
        SELECT 'Old';
    ELSE
        SELECT 'Modern';
    END IF;
END //

delimiter ;

CALL `check_year`(3);


---- WHILE loop
delimiter //

CREATE PROCEDURE `print_numbers`(IN `n` INT)
BEGIN
    DECLARE `i` INT DEFAULT 1;

    WHILE i <= n DO
        SELECT i;
        SET i = i + 1;
    END WHILE;
END //

delimiter ;


/*********************************** PostgreSQL ***************************************/

