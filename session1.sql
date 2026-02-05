 
#create database 
CREATE DATABASE company_db; -- creates a database
USE company_db;

#Create Table 

CREATE TABLE test_table (id INT,name VARCHAR(100));
INSERT INTO test_table (id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');
INSERT INTO test_table (id, name)
VALUES (5,5); -- allowed but bad practice/info
SELECT * FROM test_table;

#Alter table 
ALTER TABLE test_table
ADD email VARCHAR(255);

ALTER TABLE test_table
RENAME COLUMN email TO email_id;

# SQL constraints are used to specify rules for data in a table.

#not null and  unique constraints 
drop table if exists Persons;

CREATE TABLE Persons (
    ID int NOT NULL unique,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int
);

INSERT INTO Persons VALUES (1, 'Smith', 'John', 30);
INSERT INTO Persons VALUES (2, 'Doe', NULL, NULL);

INSERT INTO Persons VALUES (1, 'Brown', 'Charlie', 25); -- error duplicate

INSERT INTO Persons VALUES (3, NULL, 'Alice', 28); -- error null voilation

#PRIMARY KEY 
ALTER TABLE Persons ADD PRIMARY KEY (ID); -- primary key

SELECT CONSTRAINT_NAME
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'company_db'
AND TABLE_NAME = 'persons';


ALTER TABLE Persons
DROP  PRIMARY key ;

ALTER TABLE Persons
ADD CONSTRAINT PK_Person PRIMARY KEY (ID);


CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    PersonID INT,
    FOREIGN KEY (PersonID) REFERENCES Persons(ID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

INSERT INTO Orders (OrderID, OrderDate, PersonID)
VALUES (1001, '2024-06-10', 1);


SELECT * FROM Orders;
SeLECT * FROM persons;
INSERT INTO company_db.Orders (OrderID, OrderDate, PersonID)
VALUES (1002, '2024-06-11', 999);  -- invalid insert

DELETE FROM company_db.Persons WHERE ID = 1;-- error restrict

select * FROM persons; -- parent 
SELECT * FROM Orders; -- child 

UPDATE company_db.Persons SET ID = 4 WHERE ID = 1;-- cascade allowed
	
------------------------------------------------------------------------------------------------
#check and default 

CREATE TABLE employee (
    ID int NOT NULL ,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int  CHECK (Age>=18),
	city varchar(255) DEFAULT 'new york'
);

SELECT * FROM employee;

INSERT INTO employee (ID, LastName, FirstName, Age,city)
VALUES (4, 'joey', 'tribiani', 21, 'texas');

# Difference between drop and delete 
select * FROM test_table;

select * FROM test_table where id = 1;

SET SQL_SAFE_UPDATES = 0;

DELETE from test_table where id = 1;-- delete the row 

# Truncate
truncate TABLE test_table;
DROP TABLE test_table; -- drop

CREATE INDEX idx_lastname ON Persons(LastName); -- index

CREATE VIEW adult_persons AS -- view
SELECT ID, FirstName, LastName
FROM Persons
WHERE Age >= 18;
SELECT * FROM adult_persons;

SELECT p.FirstName, o.OrderID, o.OrderDate -- join
FROM Persons p
JOIN Orders o
ON p.ID = o.PersonID;

START TRANSACTION; -- transactions
INSERT INTO Persons VALUES (10, 'Test', 'User', 25);
ROLLBACK;  
COMMIT;    
 
DROP TABLE Orders;
DROP TABLE Persons;
DROP TABLE employee;
DROP DATABASE company_db;
