CREATE DATABASE MyDb;
GO

USE MyDb;
GO

CREATE TABLE People (
    ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Surname VARCHAR(50),
    jsonCol NVARCHAR(MAX),
    STATUS VARCHAR(50)
);
GO

INSERT INTO People (ID, Name, Surname, jsonCol, STATUS)
VALUES (0, 'John', 'Doe', '{\"info\":{\"address\":{\"PostCode\":\"11000\",\"Address Line 1\":\"123 Main St.\",\"Address Line 2\":\"Apt. 4B\",\"Town\":\"Belgrade\"},\"skills\":[\"SQL\",\"Python\",\"Java\"]}}', 'Active');
GO

EXEC sp_defaultdb @loginame='SA', @defdb='MyDb' 
GO