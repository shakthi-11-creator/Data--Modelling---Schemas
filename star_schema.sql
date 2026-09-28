CREATE DATABASE star_schema;
USE star_schema;

CREATE TABLE User_Dim (
    User_ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT,
    Country VARCHAR(30)
);

CREATE TABLE Movie_Dim (
    Movie_ID INT PRIMARY KEY,
    Movie_Name VARCHAR(50),
    Genre VARCHAR(25),
    Language VARCHAR(25)
);

CREATE TABLE Date_Dim (
    Date_ID INT PRIMARY KEY,
    Month VARCHAR(15),
    Year INT
);

CREATE TABLE Watch_Fact (
    Watch_ID INT PRIMARY KEY,
    User_ID INT,
    Movie_ID INT,
    Date_ID INT,
    Watch_Time INT,
    Rating INT,
    foreign key(User_ID) references User_Dim(User_ID),
    foreign key(Movie_ID) references Movie_Dim(Movie_ID),
    foreign key(Date_ID) references Date_Dim(Date_ID)
);

INSERT INTO User_Dim (User_ID, Name, Age, Country) VALUES
(1, 'Michael Jordan', 36, 'USA'),
(2, 'Anita Desai', 29, 'India'),
(3, 'Pedro Alvarez', 31, 'Spain'),
(4, 'Julia Santos', 27, 'Brazil'),
(5, 'Robert King', 44, 'UK'),
(6, 'Sanjana Rao', 25, 'India'),
(7, 'Kenji Nakamura', 38, 'Japan'),
(8, 'Emily Davis', 23, 'Canada'),
(9, 'David Clark', 41, 'USA'),
(10, 'Giulia Romano', 30, 'Italy'),
(11, 'Matthew Hall', 28, 'Australia'),
(12, 'Min Ji Park', 24, 'South Korea'),
(13, 'Alejandro Torres', 35, 'Mexico'),
(14, 'Elena Ruiz', 32, 'Spain'),
(15, 'George Wright', 48, 'UK'),
(16, 'Sara Ahmed', 26, 'UAE'),
(17, 'Christopher Young', 43, 'USA'),
(18, 'Sophie Turner', 22, 'Canada'),
(19, 'Daniel Lim', 34, 'Singapore'),
(20, 'Grace Wilson', 29, 'Australia');
-- 2. Insert Data into Movie_Dim
INSERT INTO Movie_Dim (Movie_ID, Movie_Name, Genre, Language) VALUES
(101, 'PK', 'Comedy', 'Hindi'),
(102, 'Zindagi Na Milegi Dobara', 'Drama', 'Hindi'),
(103, 'Shershaah', 'War', 'Hindi'),
(104, 'Black Panther', 'Action', 'English'),
(105, 'Doctor Strange', 'Fantasy', 'English'),
(106, 'The Matrix', 'Sci-Fi', 'English'),
(107, 'Avatar', 'Sci-Fi', 'English'),
(108, 'Mad Max: Fury Road', 'Action', 'English'),
(109, 'Finding Nemo', 'Animation', 'English'),
(110, 'Toy Story', 'Animation', 'English'),
(111, 'Kantara', 'Action', 'Kannada'),
(112, 'Vikram', 'Action', 'Tamil'),
(113, 'Master', 'Action', 'Tamil'),
(114, '96', 'Romance', 'Tamil'),
(115, 'Drishyam', 'Thriller', 'Malayalam'),
(116, 'Premam', 'Romance', 'Malayalam'),
(117, 'Geetha Govindam', 'Romance', 'Telugu'),
(118, 'Mahanati', 'Biography', 'Telugu'),
(119, 'A Wednesday', 'Thriller', 'Hindi'),
(120, 'Andhadhun', 'Crime', 'Hindi');

-- 3. Insert Data into Date_Dim
INSERT INTO Date_Dim (Date_ID, Month, Year) VALUES
(201, 'January', 2023),
(202, 'February', 2023),
(203, 'March', 2023),
(204, 'April', 2023),
(205, 'May', 2023),
(206, 'June', 2023),
(207, 'July', 2023),
(208, 'August', 2023),
(209, 'September', 2023),
(210, 'October', 2023),
(211, 'November', 2023),
(212, 'December', 2023),
(213, 'January', 2024),
(214, 'February', 2024),
(215, 'March', 2024),
(216, 'April', 2024),
(217, 'May', 2024),
(218, 'June', 2024),
(219, 'July', 2024),
(220, 'August', 2024);

INSERT INTO Watch_Fact (Watch_ID, User_ID, Movie_ID, Date_ID, Watch_Time, Rating) VALUES
(1001, 1, 101, 201, 120, 5),
(1002, 2, 106, 202, 90, 4),
(1003, 3, 102, 201, 150, 5),
(1004, 4, 102, 203, 60, 3),
(1005, 5, 104, 205, 180, 4),
(1006, 12, 103, 208, 200, 5),
(1007, 7, 115, 210, 110, 4),
(1008, 6, 111, 212, 95, 5),
(1009, 8, 108, 213, 140, 4),
(1010, 9, 116, 214, 170, 5),
(1011, 10, 109, 215, 100, 3),
(1012, 1, 113, 216, 80, 4),
(1013, 2, 117, 217, 130, 5),
(1014, 15, 114, 218, 160, 5),
(1015, 14, 107, 219, 125, 4),
(1016, 11, 110, 220, 145, 3),
(1017, 18, 118, 207, 190, 5),
(1018, 19, 103, 209, 210, 5),
(1019, 20, 101, 211, 115, 4),
(1020, 3, 112, 204, 85, 3);

SELECT * FROM Watch_Fact;
SELECT * FROM User_Dim;
SELECT * FROM Movie_Dim;
SELECT * FROM Date_Dim;

-- Tasks:
-- 1.	Identify Grain:
/*
	One Show Watched by an user on specific date
*/
-- 2.	Identify Measures:
/* Watch_Time
   Rating
*/
-- 3.	Draw Star Schema:
/*
				User_Dim
					|
					|
Movie_Dim -- -- Watch_Fact  -- -- Date_Dim
*/
-- 4.	Write SQL queries: 
-- Total watch time:

SELECT SUM(Watch_Time) as Total_Watch_Time
FROM Watch_Fact;
 
-- Top movies:

SELECT m.Movie_Name, SUM(w.Watch_Time) AS Total_Watch_Time, ROUND(AVG(w.Rating), 2) As Avg_Rating
FROM Movie_Dim as m
JOIN Watch_Fact as w ON m.Movie_ID = w.Movie_ID
GROUP BY m.Movie_Name
ORDER BY Avg_Rating DESC
LIMIT 1;
 
-- Monthly viewers: 

SELECT d.Year, d.Month, COUNT(DISTINCT w.User_ID) AS Unique_Monthly_Viewers
FROM Date_Dim as d JOIN Watch_Fact as w
ON d.Date_ID = w.Date_ID
GROUP BY d.Year, d.Month
ORDER BY d.Year, d.Month;