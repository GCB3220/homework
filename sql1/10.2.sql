-- create/delete database/table
CREATE DATABASE dst2;
use dst2;
show tables;
DROP DATABASE dst2;
CREATE TABLE stu (id INT, name VARCHAR(30));
-- add pairs/relation?
INSERT INTO stu (id, name) VALUES (1, "Jones");
INSERT INTO stu VALUES (2, "Anna");
INSERT INTO stu (id) VALUES(3);

CREATE TABLE test_char (id INT, nu CHAR(1));
INSERT INTO test_char VALUES (1, "A"), (2, "T"), (3, "C");

CREATE TABLE test_dt(id INT, dt DATETIME DEFAULT CURRENT_TIMESTAMP);
INSERT INTO test_dt(id) VALUES(2);

-- cast
SELECT name, CAST (id AS FLOAT)
FROM stu;
SELECT CAST (id AS DECIMAL(8, 2)) FROM stu;

-- FUNCTION
select LENGTH('very good');
select ABS(-3.141592);
select ROUND(3.141592);
select CEILING(3.141592);
SET @t="2021-11-28 20:23:51";
select EXTRACT(YEAR FROM @t);
select HOUR(@t), MINUTE(@t), SECOND(@t);
select DATE_ADD(@t, INTERVAL 1 DAY);
select DATE_SUB(@t, INTERVAL 1 DAY);
select DATEDIFF("2021-11-21", "2021-11-1");
use dvdrental;
select title, rating, IF(rating!="R", "good film", "x") 
from film limit 10;
select title, rating, IF(rating!="R", "good film", "x") AS good_movie 
from film limit 10;
select UPPER('very good');
select REVERSE('very good');

-- constraint
CREATE TABLE stu2 (stu_id int NOT NULL, stu_name varchar(30) DEFAULT "Not available", 
PRIMARY KEY(stu_id));
DROP TABLE stu2;

-- Task 1: Let’s create a table called dst2studentaccount with: student_id (serial, primary key), 
-- first_name (variable character less than 50 in length, must be unique), 
-- last_name (variable character less than 50 in length), 
-- email variable character less than 355 in length and must be unique, create_on (timestamp), 
-- last_login (timestamp). ok
CREATE TABLE student_account (
    student_id INT PRIMARY KEY, 
    first_name CHAR(50) UNIQUE,
    last_name CHAR(50),
    email TEXT NOT NULL,
    creat_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    UNIQUE (email(355))
);
DROP TABLE account;

-- Task 2: Insert another record into week3dst with the following information. 
-- Customer_name = ‘Smith’, customer_street = ‘First’, cusomter_city =‘Hangzhou’, 
-- Branch_name = ‘CITIHZ’, branch_city= ‘Hangzhou’, assests = 1000000.00 
-- Account_number=2, balance = 1000.00
CREATE DATABASE week3dst;
use week3dst;
CREATE TABLE customer (
    customer_name CHAR(20) PRIMARY KEY,
    customer_street CHAR(30),
    customer_city CHAR(30)
);
CREATE TABLE branch (
    branch_name char(15) PRIMARY KEY,
    branch_city char(30),
    assets numeric(12,2)
);
CREATE TABLE account (
    account_number CHAR(10) PRIMARY KEY,
    branch_name CHAR(15),
    balance INT,
    FOREIGN KEY (branch_name ) REFERENCES branch(branch_name)
);
CREATE TABLE depositor (
    customer_name char(20),
    account_number char(10),
    PRIMARY KEY (customer_name , account_number),
    FOREIGN KEY (account_number) REFERENCES account(account_number),
    FOREIGN KEY (customer_name) REFERENCES customer(customer_name)
);
INSERT INTO customer VALUES ("Smith", "First", "Hangzhou");
INSERT INTO branch VALUES ("CITIHZ", "Hangzhou", 1000000.0);
INSERT INTO account (account_number, branch_name, balance) VALUES ("2", "CITIHZ", 1000.00);
INSERT INTO depositor VALUES ("Smith", "2");

DROP DATABASE week3dst; 

-- Task 3: Create a database called ‘spjdst2’ contains the following table.
CREATE DATABASE spjdst2;
use spjdst2;
-- FOREIGN KEY: PRIMARY KEY in other relation schema.
DROP DATABASE spjdst2;
CREATE TABLE Supplier
(supplier_number int,
supplier_name varchar(30),
supplier_status boolean,
supplier_city varchar(30),
PRIMARY KEY(supplier_number));
CREATE TABLE Partner
(part_number int,
part_name varchar(20),
part_color varchar(30),
part_weight decimal(20,2),
part_city varchar(10),
PRIMARY KEY (part_number));
CREATE TABLE Project
(project_number int,
project_name varchar(15),
project_cit int,
PRIMARY KEY (project_number));
CREATE TABLE SPJ
(supplier_number int,
part_number int,
project_number int,
quantity int,
PRIMARY KEY (supplier_number,part_number,project_number),
FOREIGN KEY (supplier_number) REFERENCES
Supplier(supplier_number),
FOREIGN KEY (part_number) REFERENCES Partner(part_number),
FOREIGN KEY (project_number) REFERENCES Project(project_number)
);



-- FUNCTION/proceduer
DELIMITER ;
CREATE FUNCTION my_add(x INTEGER, y INTEGER) RETURNS INTEGER
DETERMINISTIC
BEGIN
    DECLARE result INTEGER;
    SET result = x + y;
    RETURN result;
END ;
DELIMITER ;
SELECT my_add(1, 2);
DROP FUNCTION my_add;

create    
    function myfun_getAvg(num1 int, num2 int)
    returns int    
    DETERMINISTIC
    return (num1+num2)/2
;
DROP FUNCTION myfun_getAvg;

-- Task 4: Write a function to convert RMB to USD. Let’s assume current currency is 1USD=7RMB. 
-- Then calculate how much is 100RMB in USD?
use dst2;
CREATE FUNCTION convert_RMB(RMB INT)
RETURNS INTEGER
DETERMINISTIC
BEGIN
RETURN RMB/7;
END
;
SELECT convert_RMB(100);
DROP FUNCTION convert_RMB;



-- Task 5: Write a procedure to for the film table, 
-- returns all films whose titles match a particular pattern using LIKE operator.
USE dvdrental;
CREATE PROCEDURE get_film_title(title_1 char(30))
DETERMINISTIC
BEGIN
    SELECT * FROM film
    WHERE title like title_1;
END;
CALL get_film_title ('%n');
DROP PROCEDURE get_film_title;


-- if/then
-- Task 6: Write a if-else statement to compare two date. 
-- (whether date1 is earlier, or the same date or later than date2.)
CREATE PROCEDURE compare_data(x date, y date)
DETERMINISTIC
begin
    IF x>y THEN select "date1 is later than date2" as result;
    ELSEIF x=y THEN select "date1 equals date2" as result;
    ELSE select "date1 is earlier than date2" as result;
    END IF;
END;
CALL compare_data("2021-9-20","2021-10-20");
DROP PROCEDURE compare_data;

-- Task 7: A function to calculate the cumulative product of n number (using simple LOOP).
CREATE FUNCTION plus_loop(x INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE a INT DEFAULT 1;
    DECLARE b INT DEFAULT 1;

    plus: LOOP
        SET a = a * b;
        SET b = b + 1;

        IF b > x THEN
            LEAVE plus;
        END IF;
    END LOOP;

    RETURN a;
END;


SELECT plus_loop(5);
DROP FUNCTION plus_loop;
