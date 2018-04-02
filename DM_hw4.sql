-- Database Management SQL/APEX hw4 
-- 2016/04/13
-- Jisoo Lee

-- Q1 Ch7 Ex1(b)
-- Display all courses for which Professor Berndt has been qualified

SELECT C.CourseID, C.CourseName
FROM Course_T C, Qualified_T Q, Faculty_T F
WHERE F.FacultyName = 'Berndt'
AND F.FacultyID = Q.FacultyID
AND Q.CourseID = C.CourseID;

/* Alternative: inner join command
SELECT C.CourseID, C.CourseName
FROM (Course_T C inner join Qualified_T Q on C.CourseID = Q.CourseID) 
inner join Faculty_T F on Q.FacultyID = F.FacultyID
WHERE F.FacultyName = 'Berndt';
*/

-- Q2 Ch7 Ex1(c)
-- Display the class roster, including student name, for all students enrolled 
-- in section 2714 of ISM 4212

SELECT C.CourseID, C.CourseName, ST.StudentID, ST.StudentName, SE.SectionNo,
SE.Semester
FROM Course_T C, Student_T ST, Section_T SE, Registration_T R
WHERE SE.SectionNo = R.SectionNo
AND R.StudentID = ST.StudentID
AND SE.CourseID = C.CourseID
AND R.SectionNo = 2714
AND SE.CourseID = 'ISM 4212';

/* Alternative: inner join command
SELECT C.CourseID, C.CourseName, ST.StudentID, ST.StudentName, SE.SectionNo,
SE.Semester
FROM ((Student_T ST inner join Registration_T R on ST.StudentID = R.StudentID) 
inner join Section_T SE on R.SectionNo = SE.SectionNo) 
inner join Course_T C on SE.CourseID = C.CourseID
WHERE R.SectionNo = 2714
AND SE.CourseID = 'ISM 4212'; 
*/

-- Q3 Ch7 Ex2
-- Which instructors are qualified to teach ISM 3113?

SELECT FacultyName
FROM Qualified_T Q, Faculty_T F
WHERE Q.FacultyID = F.FacultyID
AND CourseID = 'ISM 3113';

/* Alternative: inner join command
SELECT FacultyName
FROM Qualified_T Q inner join Faculty_T F on Q.FacultyID = F.FacultyID
AND CourseID = 'ISM 3113';
*/

-- Q4 Ch7 Ex4(a)
-- How many students were enrolled in section 2714 during semester I-2008?

SELECT COUNT( StudentID )
FROM Registration_T
WHERE SectionNo = 2714
AND Semester = 'I-2008';

-- Q5 Ch7 Ex4(b)
-- How many students were enrolled in ISM 3113 during semester I-2008?

SELECT COUNT( StudentID )
FROM Section_T S, Registration_T R
WHERE S.SectionNo = R.SectionNo
AND S.Semester = R.Semester
AND CourseID = 'ISM 3113'
AND S.Semester = 'I-2008';

/* Alternative: inner join command
SELECT COUNT( StudentID )
FROM Section_T S inner join Registration_T R on S.SectionNo = R.SectionNo 
AND S.Semester = R.Semester
WHERE CourseID = 'ISM 3113'
AND S.Semester = 'I-2008';
*/

-- Q6 Ch7 Ex5
-- Which students were not enrolled in any courses during semester I-2008?

SELECT StudentID, StudentName
FROM Student_T
WHERE StudentID NOT IN (SELECT StudentID
                        FROM Registration_T
                        WHERE Semester = 'I-2008');

-- Q7 Find customers who have not placed any orders

SELECT CustomerID, CustomerName
FROM Customer_T
WHERE CustomerID NOT IN (SELECT DISTINCT(CustomerID)
                         FROM Order_T);
                         
-- Q8 List the names and number of employees supervised for all the supervisors 
-- who supervise more than two employees. No need to re-label any column.

SELECT S.EmployeeName, COUNT( E.EmployeeID )
FROM Employee_T S, Employee_T E
WHERE S.EmployeeID = E.EmployeeSupervisor
GROUP BY S.EmployeeName
HAVING COUNT( E.EmployeeID ) > 2;

/* Alternative: inner join command
SELECT S.EmployeeName, COUNT( E.EmployeeID )
FROM Employee_T S inner join Employee_T E on S.EmployeeID = E.EmployeeSupervisor
GROUP BY S.EmployeeName
HAVING COUNT( E.EmployeeID ) > 2;
*/

-- Q9 Display each item ordered for order #1, its standard price, and total 
-- price for each item ordered

SELECT P.ProductID, ProductDescription, ProductStandardPrice, 
Sum( OrderedQuantity * ProductStandardPrice ) AS TotalPrice
FROM Product_T P, OrderLine_T OL
WHERE P.ProductID = OL.ProductID
GROUP BY P.ProductID, ProductDescription, ProductStandardPrice, OrderID
HAVING OrderID = 1;

/* Alternative: inner join command
SELECT P.ProductID, ProductDescription, ProductStandardPrice, 
Sum( OrderedQuantity * ProductStandardPrice ) AS TotalPrice
FROM Product_T P inner join OrderLine_T OL on P.ProductID = OL.ProductID
GROUP BY P.ProductID, ProductDescription, ProductStandardPrice, OrderID
HAVING OrderID = 1;
*/
