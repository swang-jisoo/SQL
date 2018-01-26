--Delphi Acct: AIPT2
--Delphi PW: TippiTech2
--Team codes: Tippie2

--PART 1
--logic
--Many Entity >> immediately insert FK!!!!!
--M:M attribute e.g. quantity
--recheck relationship & FK
--save as >> PDF

--PART 2
--ERD vs. create table code
--does create table/insert record code works? ***** 

--useful codes
SELECT 
FROM

TO_CHAR( , '$9,999.99')

(CASE attribute WHEN value THEN value
                      WHEN  THEN 
                      WHEN  THEN  END) AS

--WHERE >> GROUP BY >> HAVING


--Part 2: Create View
--2016
    --The management wants a view called PendingTripsView, 
    --which contains only those trips that have a status of ‘pending’.:
    --a. The customer’s first and last name
    --b. The credit card type and number used to pay for the trip
    --c. The start date and time, formatted as shown
    --d. And the tube type that was requested for the trip
    --ordered by Customer name, and then by Tube Requested, as shown below:
--view name: PendingTripsView
--limits: status = 'pending'
--columns: FName LName AS Customer; CC_type CC_Number AS CreditCard; 
--StartDateTime AS TripSTartDetails; TubeType AS Tube Requested
--order: customer name, tube requested
DROP VIEW PendingTripsView;

CREATE VIEW PendingTripsView AS 
SELECT C.FName || ' ' || C.LName AS "Customer", 
       CC.CC_Type || ' ' || CC.CC_Number AS "Credit Card",
       TO_CHAR(T.Trip_Start_Date_Time, 'MM/DD HH:MIa.m.') AS "Trip Start Details"
       TT.Tube_Name AS "Tube Requested"
FROM TRANSACTIONS T
JOIN CTA_CUSTOMER C    ON    T.CustomerCust_ID = C.Cust_ID
JOIN CREDIT_CARD CC    ON    T.CreditCardCC_ID = CC.CC_ID
JOIN Trip_Equip TE     ON    TE.TransactionTrac_ID = T.Trac_ID
JOIN Tube T            ON    T.Tube_ID = TE.Tube_Tube_ID
JOIN Tube_Type TT      ON    TT.Tube_Type_ID = T.Tube_TypeTube_Type_ID
WHERE T.Status = 'pending'
ORDER BY "Customer", "Tube Requested";

--2015
    --The management wants a new table (not a view but a table) called WoodProducts, 
    --which contains the same columns as the Products table, 
    --except that only furniture made from wood are included.  
    --This includes:  maple, birch, walnut, cherry, and mahogany.   
DROP TABLE WoodProducts
CREATE TABLE WoodProducts AS
(SELECT * FROM Products
WHERE Prod_Finish IN ('Maple', 'Birch', 'Walnut', 'Cherry', 'Mahogany'));
    --Create the SQL code needed to put the following facts into the database, 
    --that represent the raw materials needed to make a filing cabinet:
    --a.	16 panels of 18-guage steel
    --b.	2.5 gallons of epoxy paint steel
    --c.	14 feet of track suspensions
    --d.	4.7 meters of steel tubing
    --(Note:  the number of units used of each raw material will be in the format 99.9)
CREATE TABLE Product_Raw_Material
    (Prod_ID CHAR(4),
    Material_ID NUMBER(2),
    Unit_Used DECIMAL(3,1),
    CONSTRAINT Prod_Mat_id_PK PRIMARY KEY (Prod_ID, Material_ID),
    CONSTRAINT prod_Prod_Mat_id_FK FOREIGN KEY (Prod_Id) REFERENCES Products(Prod_ID),
    CONSTRAINT Mat_Prod_Mat_id_FK FOREIGN KEY (Material_ID) REFERENCES raw_material(Material_ID));

SELECT prod_id FROM Products 
WHERE UPPER(prod_description) LIKE UPPER('Filing Cabinet'); --82P2

SELECT * FROM raw_material
WHERE UPPER(material_description) LIKE UPPER('%steel%')
OR UPPER(material_description) LIKE UPPER('%track%'); --tubing 6; guage 7; epoxy 8; track 9

INSERT INTO product_raw_material VALUES ('82P2', 7, 16.0);
INSERT INTO product_raw_material VALUES ('82P2', 8, 2.5);
INSERT INTO product_raw_material VALUES ('82P2', 9, 14.0);
INSERT INTO product_raw_material VALUES ('82P2', 6, 4.7);

SELECT  p.prod_description AS "Product", 
        pm.Unit_Used || m.unit_of_measure || ' of ' || m.material_description AS "Raw Materials"
FROM Product_Raw_Material pm
JOIN products p ON p.Prod_ID = pm.Prod_ID
JOIN raw_material m ON m.Material_ID = pm.Material_ID; --examine



--Part 3: Queries
--2016
    --How much was the cost for transaction #5? Display Transaction ID 
    --and the total cost for the transaction.
--Query 1
--limit: transaction = 5
--columns: transaction id, total cost >> group by
SELECT T.Trac_ID AS "Transaction ID",
       TO_CHAR(SUM(TE.qty * TT.Rental_Charge), '$9,999') AS "Total Cost In Dollars"
FROM Transactions T
JOIN Trip_Equip TE ON TE.TransactionTrac_ID = T.Trac_ID
JOIN Tube T ON T.Tube_ID = TE.Tube_Tube_ID
JOIN Tube_Type TT ON TT.Tube_Type_ID = T.Tube_TypeTube_Type_ID
WHERE T.Trac_ID = 5
GROUP BY T.Trac_ID;
--***Q: how to add destination fee on total cost??
SELECT T.Trac_ID AS "Transaction ID",
TO_CHAR(RentalFee + DestFee, '$9,999') AS "Total Cost In Dollars"
FROM Transactions T, 
    (SELECT SUM(TE.qty * TT.Rental_Charge) AS RentalFee
    FROM Transactions T
    JOIN Trip_Equip TE ON TE.TransactionTrac_ID = T.Trac_ID
    JOIN Tube T ON T.Tube_ID = TE.Tube_Tube_ID
    JOIN Tube_Type TT ON TT.Tube_Type_ID = T.Tube_TypeTube_Type_ID
    WHERE T.Trac_ID = 5),
    (SELECT D.Fee AS DestFee
    FROM Destination D
    JOIN Transactions T ON T.DestinationDest_ID = D.Dest_ID
    WHERE T.Trac_ID = 5)
WHERE T.Trac_ID = 5; -- no good

--2015
    --Write a query that will calculate how much money it costs to produce the filing cabinet.  
SELECT p.prod_description AS "Item",
TO_CHAR(SUM(m.unit_price * pm.unit_used), '$9,999.99') AS "Total Cost"
FROM products p 
JOIN product_raw_material pm ON pm.prod_id = p.prod_id
JOIN raw_material m ON m.material_id = pm.material_id
WHERE UPPER(p.prod_description) LIKE UPPER('Filing Cabinet')
GROUP BY p.prod_description;

--2014 (MYSQL)
    --This query will select information about volunteers and their assigned animals. 
    --Print the last phone number and last name, 
    --followed by the arrival date of the animal at the shelter (formatted as shown), 
    --followed by the breed of the animal. Order by the phone area code. 
    --Only include those records where the animal arrived in 2013.
select concat('(', left(vol_phone,3),')',mid(vol_phone,4,3),'-',right(vol_phone,4), 
              lpad(concat(vol_first,' ', vol_last),20,'.')) as 'Volunteer Contact Information',
	date_format(arrival_date,'%m/%d/%Y') as 'Arrival Date', 
    concat(animal_name,' (', breed_name,')') as 'Assigned Animal'
from animal a, breed b, volunteer v
where b.breed_id = a.breed_id
and v.vol_id = a.vol_id
and year(arrival_date) = 2013
order by left(vol_phone,3);



--Query2
--2016
    --List the Customer ID, Name, City, State for customers who had rental transactions processed for trips 
    --that started in both the months of June 2014 and July 2014 
    --(i.e. had at least one Trip start date in June 2014 and at least one in July 2014).
--limit: tripstartdate: month = BOTH 6 and 7; year = 2014
--columns: custid, fname lname as customer name, city state as location, phone, email, tripstartdate
SELECT C.Cust_ID AS "Customer ID",
  C.FName || ' ' || C.LName AS "Name",
  C.City || ', ' || C.State AS "Location",
  C.Phone AS "Phone",
  C.email AS "Email"
FROM CTA_Customer C 
WHERE C.Cust_ID = (SELECT C.Cust_ID
                   FROM CTA_CUSTOMER C JOIN Transactions T ON T.CustomerCust_ID = C.Cust_ID
                   WHERE TO_CHAR(T.Trip_Start_Date_Time, 'MM/YY') = '06/14'
                INTERSECT
                   SELECT C.Cust_ID
                   FROM CTA_CUSTOMER C JOIN Transactions T ON T.CustomerCust_ID = C.Cust_ID
                   WHERE TO_CHAR(T.Trip_Start_Date_Time, 'MM/YY') = '07/14');
--WHERE EXTRACT (MONTH FROM T.Trip_Start_Date_Time) IN (6,7)
--AND EXTRACT (YEAR FROM T.Trip_Start_Date_Time) = '2014'

--2015
    --The Pine Valley Furniture Company gives a 10% discount to companies who spend more than $100,000.
    --Write a query that will provide the total amount spent on all orders 
    --that are currently in the Orders table.  
    --If the total amount is $100,000 or over, calculate the discount amount, 
    --and the final price to the company, formatted as shown below.    
    --Order by Total Invoice from largest to smallest values.  
SELECT cp.company_name AS "COMPANY_NAME",
        TO_CHAR(SUM(po.quantity * p.unit_price), '$999,999') AS "Total Invoice",
        TO_CHAR(SUM(po.quantity * p.unit_price)*0.1, '$999,999') AS "Discount",
        TO_CHAR(SUM(po.quantity * p.unit_price)*0.9, '$999,999') AS "Final Price"
FROM company cp 
JOIN customer c ON c.cust_id = cp.cust_id
JOIN orders o ON o.cust_id = cp.cust_id
JOIN product_order po ON po.order_id = o.order_id
JOIN products p ON p.prod_id = po.prod_id
GROUP BY cp.company_name
HAVING SUM(po.quantity * p.unit_price) >= 100000
ORDER BY "Total Invoice" DESC;

--2014
    --The Rescue Shelter needs to find Adopters and Volunteers who have the same zip code 
    --so that homes can be found in a nearby vicinity. 
    --List all of the Adopters and Volunteers who have the same zip code. 
    --Also list the number of wishes for each adopter. 
    --Only include those adopters who have 2 or more wishes. Order by column 1.
SELECT CONCAT(adopter_first, ' ',adopter_last, ' has ', COUNT(wish_id), ' wishes') AS 'Adopter and Wishlist', CONCAT(vol_first, ' ', vol_last) AS 'Volunteer', adopter_zip AS 'Common Zip Code'
FROM adopter a
INNER JOIN wishlist w ON a.adopter_id = w.adopter_id
INNER JOIN volunteer v ON a.adopter_zip = v.vol_zip
WHERE w.adopter_id = a.adopter_id
GROUP BY a.adopter_zip
HAVING COUNT(w.wish_id) > 1
ORDER BY adopter_first;



--Query3
--2016
    --Create a query that will list a phrase giving person capacity, ‘One Person’, ‘Two Persons’, etc., 
    --the name of the tube type, the rental charge with 6% tax, and the charge per person.
--limit: case person capacity
--columns: personcapacity as can hold, tubename, rentalcharge with 6%tax, rentalcharge per person
SELECT (CASE WHEN Person_Capacity = 1 THEN 'One Person'
             WHEN Person_Capacity = 2 THEN 'Two Persons'
             WHEN Person_Capacity = 3 THEN 'Three Persons' END) AS "Can Hold",
  Tube_Name AS "Tube Name",
  TO_CHAR(Rental_Charge * 1.06, '$9,999.99') AS "Rental Charge With Tax",
  TO_CHAR(Rental_Charge * 1.06 / Person_Capacity, '$9,999.99') AS "Charge per person"
FROM Tube_Type
ORDER BY Person_Capacity; 

--2015
    --Write the SQL code to give the number of orders 
    --along with the total number of items that were in all orders, 
    --grouped by the order’s origination (‘O’ for ‘Online’, ‘P’ for ‘Phone’, and ‘M’ for ‘Mail’).  
    --Order the records by the number of orders in descending order.
SELECT (CASE  WHEN o.origination = 'O' THEN 'Online'
              WHEN o.origination = 'P' THEN 'Phone'
              WHEN o.origination = 'M' THEN 'Mail' END) AS "Origination",
COUNT(DISTINCT o.order_id) AS "Number of Orders",
SUM(po.quantity) AS "Number of Items"
FROM orders o
JOIN product_order po ON po.order_id = o.order_id
GROUP BY o.origination
ORDER BY "Number of Orders" DESC;

--2014
    --List the animal’s name, breed name, and weight for all animals. 
    --Using the male and female high and low weight averages, 
    --determine whether the animal’s weight falls 
    --within the low and high average weights for their own gender and breed. 
    --Indicate whether the animal is Underweight, Normal, or Overweight. 
    --Format the columns and headings as shown below, and order by The animal’s weight descending.
SELECT animal_name AS 'Animal Name', animal_gender AS 'Gender', 
breed_name AS 'Breed', animal_weight AS 'Weight', 
CASE animal_gender 
WHEN 'M' THEN CONCAT('Male: ', male_lo_weight, ' -- ', male_hi_weight) 
WHEN 'F' THEN CONCAT('Female: ', female_lo_weight, ' -- ', female_hi_weight)
END AS 'Weight Range for Breed', 
CASE 
WHEN animal_gender = 'M' AND animal_weight > male_hi_weight THEN 'Over'
WHEN animal_gender = 'M' AND (animal_weight <= male_hi_weight AND animal_weight >= male_lo_weight) THEN 'Normal'
WHEN animal_gender = 'M' AND animal_weight < male_lo_weight THEN 'Under'
WHEN animal_gender = 'F' AND animal_weight > female_hi_weight THEN 'Over'
WHEN animal_gender = 'F' AND (animal_weight <= female_hi_weight AND animal_weight >= female_lo_weight) THEN 'Normal'
WHEN animal_gender = 'F' AND animal_weight < female_lo_weight THEN 'Under'
END AS 'Indication'
FROM animal a
INNER JOIN breed b ON a.breed_id = b.breed_id
WHERE b.breed_id = a.breed_id
ORDER BY animal_weight DESC;



--Query 4
--2016
    --What is the most popular tube type requested in terms of the number of tubes rented? 
    --(that is, it has the largest number of tubes rented.) 
    --Display tube type ID, Name, Size, Person Capacity, Cooler Capacity, Drink Capacity 
    --and the total number of tubes rented.
--limit: MAX(SUM(Trip_Equip.qty))
--columns: tubetype, tubename, size, pplcapacity, coolercapacity, drink capacity, sum(trip_equip.qty)
SELECT * FROM (
    SELECT DISTINCT a.Tube_Type_ID AS "Tube Type",
      a.Tube_Name AS "Tube Name",
      a.Tube_Size AS "Tube Size",
      a.Person_Capacity AS "People Capacity",
      a.Cooler_Capacity AS "Cooler Capacity",
      a.Drink_Capacity AS "Drink Capacity",
      (SELECT SUM(Trip_Equip.qty) 
         FROM Trip_Equip
         JOIN Tube ON Trip_Equip.Tube_Tube_ID = Tube.Tube_ID
         JOIN Tube_Type b ON b.Tube_Type_ID = Tube.Tube_TypeTube_Type_ID
         WHERE b.Tube_Type_ID = a.Tube_Type_ID) AS "Number Tubes Rented"
    FROM Tube_Type a
    JOIN Tube T ON T.Tube_TypeTube_Type_ID = a.Tube_Type_ID
    JOIN Trip_Equip TE ON TE.Tube_Tube_ID = T.Tube_ID
    ORDER BY "Number Tubes Rented" DESC)
WHERE ROWNUM = 1; 

--2015
    --Create a query that lists each customer’s ID number, 
    --their name (formatted as “Firstname Lastname”, first letter capitalized) 
    --or the name of the company, 
    --and their type (Individual or Company) as shown in the results below.  
    --Order according to the type of customer, then by customer name, as shown.  
SELECT c.cust_id AS "ID Number",
INITCAP(i.cust_first || ' ' || i.cust_last) AS "Customer Name",
'Individual' AS "Type"
FROM customer c 
JOIN individual i ON i.cust_id = c.cust_id
UNION
SELECT c.cust_id,
cp.company_name,
'Company'
FROM customer c 
JOIN company cp ON cp.cust_id = c.cust_id
ORDER BY "Type", "Customer Name";
--() UNION () >> error 

--2014
    --This query will help shelter personnel find adopters for animals that they are currently sheltering
    --The shelter personnel will be prompted to enter the breed of the animal. 
    --Any adopters that have indicated this type of animal on their wishlist will be displayed. 
    --The breed of the animal must match what the user has typed in, 
    --and the breed and gender of the animal must match the breed and gender on the adopter’s wish list. 
    --Show the adopter’s full name, desired breed, desired gender, name of the animal, and gender of the animal. 
    --The query should work correctly regardless of case, that is, BEAGLE, beagle, and Beagle should all work. 
    --Display the gender with capital letters, i.e., “M” or “F”. Order by the first column.
Select concat(adopter_first, ' ', adopter_last) as Adopter, 
	breed_name as 'Desired Breed', ucase(desired_gender) as 'Desired Gender',
	animal_name as 'Name', Animal_Gender as 'Animal Gender'
from animal an, breed b, Wishlist w, adopter ad
where w.adopter_id = ad.adopter_id
and w.desired_breed = b.breed_id
and b.breed_id = an.breed_id
and w.desired_gender = an.Animal_gender;



--Query 5
--2015
    --Select all products whose unit price is greater 
    --than the average unit price for their own product line.  
    --Order by the product description
SELECT prod_description AS "Product Description",
       prod_line_name AS "Product Line",
       TO_CHAR(outp.unit_price, '$9,999') AS "Unit Price",
       (SELECT TO_CHAR(AVG(inp.unit_price), '$9,999')
        FROM products inp 
        JOIN product_line pl ON pl.prod_line_id= inp.prod_line_id
        WHERE inp.prod_line_id = outp.prod_line_id 
        GROUP BY inp.prod_line_id) AS "Average Product Line Price"
FROM products outp
JOIN product_line pl ON pl.prod_line_id= outp.prod_line_id
WHERE outp.unit_price > (SELECT AVG(inp.unit_price)
        FROM products inp 
        JOIN product_line pl ON pl.prod_line_id= inp.prod_line_id
        WHERE inp.prod_line_id = outp.prod_line_id 
        GROUP BY inp.prod_line_id)
ORDER BY "Product Description"
--unnecessary to do join on/group by in inner query 
SELECT prod_description AS "Product Description",
       prod_line_name AS "Product Line",
       TO_CHAR(outp.unit_price, '$9,999') AS "Unit Price",
       (SELECT TO_CHAR(AVG(inp.unit_price), '$9,999')
        FROM products inp 
        WHERE inp.prod_line_id = outp.prod_line_id ) AS "Average Product Line Price"
FROM products outp
JOIN product_line pl ON pl.prod_line_id= outp.prod_line_id
WHERE outp.unit_price > (SELECT AVG(inp.unit_price)
        FROM products inp 
        WHERE inp.prod_line_id = outp.prod_line_id )
ORDER BY "Product Description"

--2014
    --Select all animals whose weight is an odd number that is more than the heaviest cat. 
    --Include the animal’s name, weight, and the name of the volunteer who is taking care of it. 
    --Indicate if there is no volunteer. Order by weight from largest to smallest
select animal_name 'Animal', 
    animal_weight as'Weight', 
    ifnull(concat(vol_first,' ',vol_last),'No volunteer') as 'Volunteer'
from Animal a left join volunteer v on (a.vol_id = v.vol_id)
Where animal_weight > (select max(animal_weight) 
				from animal an, breed br 
				where an.breed_id = br.breed_id
				and breed_type = 'Cat')
and round(animal_weight/2,0) <> animal_weight/2
order by weight desc;



--Tie-Breaker
--2016
    --What was the average travel time in minutes between destinations 3 and 4?
--limit: destination between 3 and 4
--column: avg(Date_Time) in minute
SELECT TO_CHAR(AVG(
    (( TRUNC(TO_CHAR(a.Date_Time, 'hh24'))*60*60 + TRUNC(TO_CHAR(a.Date_Time, 'mi'))*60 
      + TRUNC(TO_CHAR(a.Date_Time, 'ss')) ) 
    - ( TRUNC(TO_CHAR(b.Date_Time, 'hh24'))*60*60 + TRUNC(TO_CHAR(b.Date_Time, 'mi'))*60 
       + TRUNC(TO_CHAR(b.Date_Time, 'ss')) ) ) 
                    /60 ), '9,999.99') AS "Avg Travel Dest 3 and 4"
FROM Stop_Log_Detail a, Stop_Log_Detail b
WHERE a.DestinationDest_ID = 4
AND b.DestinationDest_ID = 3;

--2015
    --This query will return the street address of any customer, 
    --such that the numerical part of the street address 
    --contains the number of characters in that street address.
INSERT INTO customer VALUES ('0199', '1920 Piedmont Place', 'Omaha', 'NE', '30303', 'I'); 

SELECT c.cust_street AS "Street Address",
LENGTH(c.cust_street) AS "Number Characters"
FROM customer c
WHERE c.cust_street LIKE '%'||LENGTH(c.cust_street)||'%';

