-- -----------------------------------------------------
-- FIRST QUERY	
-- -----------------------------------------------------

/*
Query orders in a specified time frame returning:
- order number
- customer name and ID
- number of ordered items
- total sum
- expected shipping
- actual shipping 
*/

SELECT SUM(OP.Quantity_in_cart * P.Price) AS Total, SUM(OP.Quantity_in_cart) AS Ordered_quantities, 
COUNT(OP.Part_ID) AS Ordered_items, CONCAT(C.First_name, ' ', C.Last_name) AS Customer_fullname,
OL.Order_ID, C.Customer_ID,  OL.Actual_ship, OL.Planned_ship 
FROM Customer C
INNER JOIN Order_list OL ON OL.Customer_ID = C.Customer_ID
INNER JOIN Order_part OP ON OP.Order_ID = OL.Order_ID
INNER JOIN Part P ON P.Part_ID = OP.Part_ID
WHERE OL.Date_of_receipt BETWEEN '2021-01-01' AND '2021-12-31'
GROUP BY OL.Order_ID, C.Customer_ID, C.First_name, OL.Actual_ship, OL.Planned_ship
ORDER BY OL.Order_ID ASC;


-- -----------------------------------------------------
-- SECOND QUERY
-- -----------------------------------------------------

/*
Select a single order and list:
- order header info (client name and address)
- ordered items
- ordered quantities
*/

SELECT SUM(OP.Quantity_in_cart) AS Ordered_quantities, CONCAT(C.First_name, ' ', C.Last_name) AS Customer_fullname,
C.Customer_ID, C.ZIP_code AS Customer_ZIP, OL.Order_ID, OP.Quantity_in_cart, P.Part_name
FROM Part P
INNER JOIN Order_part OP ON OP.Part_ID = P.Part_ID
INNER JOIN Order_list OL ON OL.Order_ID = OP.Order_ID
INNER JOIN Customer C ON C.Customer_ID = OL.Customer_ID
WHERE OL.Order_ID = '2'
GROUP BY OL.Order_ID, OP.Quantity_in_cart, P.Part_name, C.Customer_ID, Customer_ZIP, Customer_fullname;