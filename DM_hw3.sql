-- Database Management SQL hw3
-- 2016/03/23
-- Jisoo Lee


-- Q1 Chapter6 Exercise1
-- Create 6 tables with primary and foreign keys.
/*SYNTAX: 
CREATE TABLE table_NAME 
        (attributes       datatype, 
CONSTRAINT constraint_NAME PRIMARY KEY (attributes), 
CONSTRAINT constraint_NAME FORIEGN KEY (attributes) REFERENCES table_NAME (attributes));*/

CREATE TABLE STUDENT_T
        (StudentID        NUMBER(5,0)       NOT NULL,
        StudentName       VARCHAR2(25),
CONSTRAINT STUDENT_PK     PRIMARY KEY (StudentID));

CREATE TABLE FACULTY_T
        (FacultyID        NUMBER(4,0)       NOT NULL,
        FacultyName       VARCHAR2(25),
CONSTRAINT FACULTY_PK     PRIMARY KEY (FacultyID));

CREATE TABLE COURSE_T
        (CourseID         CHAR(8)           NOT NULL,
        CourseName        VARCHAR2(15),
CONSTRAINT COURSE_PK      PRIMARY KEY (CourseID));

CREATE TABLE QUALIFIED_T
        (FacultyID        NUMBER(4,0)       NOT NULL,
        CourseID          CHAR(8)           NOT NULL,
        DateQualified     DATE,
CONSTRAINT QUALIFIED_PK   PRIMARY KEY (FacultyID, CourseID),
CONSTRAINT QUALIFIED_FK1  FOREIGN KEY (FacultyID) REFERENCES FACULTY_T (FacultyID),
CONSTRAINT QUALIFIED_FK2  FOREIGN KEY (CourseID)  REFERENCES COURSE_T (CourseID));

CREATE TABLE SECTION_T
        (SectionNo        NUMBER(4,0)       NOT NULL,
        Semester          CHAR(7)           NOT NULL,
        CourseID          CHAR(8),
CONSTRAINT SECTION_PK     PRIMARY KEY (SectionNo, Semester),
CONSTRAINT SECTION_FK     FOREIGN KEY (CourseID)  REFERENCES COURSE_T (CourseID));

CREATE TABLE REGISTRATION_T
        (StudentID        NUMBER(5,0)       NOT NULL,
        SectionNo         NUMBER(4,0)       NOT NULL,
        Semester          CHAR(7)           NOT NULL,
CONSTRAINT REGISTRATION_PK  PRIMARY KEY (StudentID, SectionNo, Semester),
CONSTRAINT REGISTRATION_FK1 FOREIGN KEY (StudentID) REFERENCES STUDENT_T (StudentID),
CONSTRAINT REGISTRATION_FK2 FOREIGN KEY (SectionNo, Semester) REFERENCES SECTION_T (SectionNo, Semester));


-- Q2 Chapter6 Exercise4
-- Q2 (a) Add an attribute "Class" to STUDENT_T
/*SYNTAX: 
ALTER TABLE table_NAME 
ADD attribute datatype;*/

ALTER TABLE STUDENT_T 
ADD         Class        VARCHAR2(10);

-- Q2 (b) Remove REGISTRATION_T
/*SYNTAX: 
DROP TABLE table_NAME CASCADE CONSTRAINTS;*/

-- In order to run the code for Q5 (a), which requires REGISTRATION_T, 
-- run the following code after Q5 (a).
-- DROP TABLE REGISTRATION_T CASCADE CONSTRAINTS;

-- Not an answer for hw but to check if all codes work correctly, 
-- run the below codes.
-- DROP TABLE STUDENT_T CASCADE CONSTRAINTS;
-- DROP TABLE FACULTY_T CASCADE CONSTRAINTS;
-- DROP TABLE COURSE_T CASCADE CONSTRAINTS;
-- DROP TABLE QUALIFIED_T CASCADE CONSTRAINTS;
-- DROP TABLE SECTION_T CASCADE CONSTRAINTS;

-- Q2 (c) Change the attribute "FacultyName"'s datatype
/*SYNTAX: 
ALTER TABLE table_Name MODIFY column_name newDatatype;*/

ALTER TABLE FACULTY_T MODIFY FacultyName VARCHAR2(40);


-- Q3 Chapter6 Exercise5
-- Q3 (a) Add values in STUDENT_T
/*SYNTAX: 
INSERT INTO table_NAME (attribute_NAME) 
VALUES (values);*/

-- Because a new column "Class" is added to STUDENT_T on Q2(a), this INSERT 
-- commend needs more values.
INSERT INTO STUDENT_T VALUES (65798, 'Lopez');

-- Alternative
INSERT INTO STUDENT_T (StudentID, StudentName)
VALUES                (65798, 'Lopez');

-- Q3 (b) Remove values added from (a)
/*SYNTAX: 
DELETE FROM table_NAME 
WHERE attribute = values;*/

DELETE FROM STUDENT_T
WHERE StudentName = 'Lopez';

-- Q3 (c) Modify values
/*SYNTAX: 
UPDATE table_NAME 
SET attribute = newValue 
WHERE identifier = Value;*/

INSERT INTO COURSE_T  (CourseID, CourseName)
VALUES                ('ISM 4212', 'Database');

-- Alternative
ALTER TABLE COURSE_T MODIFY CourseName VARCHAR2(40);

UPDATE COURSE_T 
SET CourseName = 'Introduction to Relational Databases' 
WHERE CourseID = 'ISM 4212';


-- Q4 Chapter6 Exercise6
-- Q4 (a) show data 
/*SYNTAX: 
SELECT attributes (* means all) 
FROM table_NAME
WHERE attributes condition;*/

SELECT StudentID, StudentName
FROM STUDENT_T
WHERE StudentID < 50000;

-- Q4 (b) show data
SELECT FacultyID, FacultyName
FROM FACULTY_T
WHERE FacultyID = 4756;

-- Q4 (c) show data
SELECT MIN(SectionNo)
FROM SECTION_T
WHERE Semester = 'I-2008';


-- Q5 Chapter6 Exercise7
-- Q5 (a) show data
SELECT COUNT(*)
FROM REGISTRATION_T
WHERE SectionNo = 2714 AND Semester = 'I-2008';

-- Q2 Chapter6 Exercise4
-- Q2 (b) Remove REGISTRATION_T
-- DROP TABLE REGISTRATION_T CASCADE CONSTRAINTS;

-- Q5 (b) show data
SELECT FacultyID, CourseID, DateQualified
FROM QUALIFIED_T
WHERE DateQualified >= '1/2008';


-- Q6 (1) Chapter6 Exercise8
-- Q6 (c) show data
SELECT CourseID
FROM SECTION_T
WHERE Semester = 'I-2008' 
AND CourseID NOT IN   (SELECT CourseID
                      FROM SECTION_T
                      WHERE Semester = 'II-2008');

-- Q6 (2) show data
SELECT COUNT(FacultyID), CourseID
FROM QUALIFIED_T
GROUP BY CourseID;


-- Q7 Chapter6 Exercise9
-- Q7 (a) show data
SELECT DISTINCT CourseID
FROM SECTION_T;

-- Q7 (b) show data
SELECT StudentName
FROM STUDENT_T
ORDER BY StudentName ASC;
