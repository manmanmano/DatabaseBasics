-- -----------------------------------------------------
-- View
-- -----------------------------------------------------

CREATE VIEW OrdersInSpecificTimeRange AS
	SELECT SUM(OP.Quantity_in_cart * P.Price) AS Total, SUM(OP.Quantity_in_cart) AS Ordered_quantities, 
	COUNT(OP.Part_ID) AS Ordered_items, CONCAT(C.First_name, ' ', C.Last_name) AS Customer_fullname,
	OL.Order_ID,  OL.Actual_ship, OL.Planned_ship 
	FROM Customer C
	INNER JOIN Order_list OL ON OL.Customer_ID = C.Customer_ID
	INNER JOIN Order_part OP ON OP.Order_ID = OL.Order_ID
	INNER JOIN Part P ON P.Part_ID = OP.Part_ID
	WHERE OL.Date_of_receipt BETWEEN '2021-01-01' AND '2021-12-31'
	GROUP BY OL.Order_ID, Customer_fullname, OL.Actual_ship, OL.Planned_ship
	ORDER BY OL.Order_ID ASC;

SELECT * FROM OrdersInSpecificTimeRange;



-- -----------------------------------------------------
-- Function
-- -----------------------------------------------------

# N.B: I was not sure what I had to find with the function if either the number of items
# in the select statement (number of items the first query may require)  or the number 
# of items in an order so I did them both

# First function - finds number of items the first query may require 
# Firstly create a view of the desired query and then type in the name of the view as a parameter
DELIMITER // 
CREATE FUNCTION FindQueryNeeds(nameOfView VARCHAR(500))
  RETURNS DECIMAL 
  READS SQL DATA
  BEGIN 
    RETURN IFNull((SELECT COUNT(*) AS NumberOfItems
                    FROM information_schema.columns
                   WHERE table_name = nameOfView), 0); 
  END// 
DELIMITER ;

SELECT FindQueryNeeds('OrdersInSpecificTimeRange') AS nItems;
SELECT FindQueryNeeds(NULL) AS nItems;


# Second function - finds number of items in a period of time -- not quantity but n times items are ordered
DELIMITER // 
CREATE FUNCTION GetNumberOfItems(SD DATE, ED DATE) -- SD - Start date, ED - End date 
  RETURNS DECIMAL 
  READS SQL DATA
  BEGIN 
    RETURN IFNull((SELECT COUNT(OP.Part_ID)
                    FROM Order_part OP
                    INNER JOIN Order_list OL ON OL.Order_ID = OP.Order_ID
                   WHERE OL.Date_of_receipt BETWEEN SD AND ED), 0); 
  END// 
DELIMITER ; 

SELECT GetNumberOfItems('2018-01-01', '2021-12-31') AS Ordered_items;
SELECT GetNumberOfItems(NULL, '2021-12-31') AS Ordered_items;
SELECT GetNumberOfItems('2018-01-01', NULL) AS Ordered_items;
SELECT GetNumberOfItems('2018-01-01', '2019-12-31') AS Ordered_items;
SELECT GetNumberOfItems('2020-01-01', '2021-12-31') AS Ordered_items;



-- -----------------------------------------------------
-- Stored procedure
-- -----------------------------------------------------

DELIMITER // 
CREATE PROCEDURE GetOrderInfoByID (order_id INT) 
BEGIN 
  SET order_id = IFNULL(order_id, 0); 
   
  SELECT P.Part_name, SUM(OP.Quantity_in_cart) AS Ordered_quantities, OL.Order_ID,
  CONCAT(C.First_name, ' ', C.Last_name) AS Customer_fullname, C.ZIP_code AS Customer_ZIP
	FROM Part P 
    INNER JOIN Order_part OP ON OP.Part_ID = P.Part_ID
    INNER JOIN Order_list OL ON OL.Order_ID = OP.Order_ID
    INNER JOIN Customer C ON C.Customer_ID = OL.Customer_ID
   WHERE OL.Order_ID = order_id 
   GROUP BY OL.Order_ID, OP.Quantity_in_cart, P.Part_name, Customer_ZIP, Customer_fullname;
END// 
DELIMITER ;

CALL GetOrderInfoByID(3);
CALL GetOrderInfoByID(NULL);
CALL GetOrderInfoByID(10);