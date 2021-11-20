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
# in the select statement or the number of items in an order so I did them both

# First function - finds items in the SELECT statement 
DELIMITER // 
CREATE FUNCTION FindItemsInQuery(NAME_OF_VIEW VARCHAR(500))
  RETURNS DECIMAL 
  READS SQL DATA
  BEGIN 
    RETURN IFNull((SELECT COUNT(*) AS NumberOfItems
                    FROM information_schema.columns
                   WHERE table_name = NAME_OF_VIEW), 0); 
  END // 
DELIMITER ;

SELECT FindItemsInQuery('OrdersInSpecificTimeRange') AS nItems;

# Second function - finds number of items in an order
DELIMITER // 
CREATE FUNCTION GetNumberOfItems(SD DATE, ED DATE) -- SD - Start date, ED - End date 
  RETURNS DECIMAL 
  READS SQL DATA
  BEGIN 
    RETURN IFNull((SELECT COUNT(OP.Part_ID)
                    FROM Order_part OP
                    INNER JOIN Order_list OL ON OL.Order_ID = OP.Order_ID
                   WHERE OL.Date_of_receipt BETWEEN SD AND ED), 0); 
  END // 
DELIMITER ; 

SELECT GetNumberOfItems('2018-01-01', '2021-12-31') AS Ordered_items;



-- -----------------------------------------------------
-- Stored procedure
-- -----------------------------------------------------

DELIMITER // 
CREATE PROCEDURE GetWorkplaceCountByContact (firstName varchar(50)) 
BEGIN 
  SET firstName = IFNULL(firstName, ''); 
   
  select C.FullName, Count(W.ID) AS NumberOfWorkplaces  
    from Contact C LEFT OUTER JOIN  
         Workplace W ON C.ID = W.ContactID 
   where (firstName = '') OR (C.FirstName = firstName) 
   group by C.FullName; 
END// 
DELIMITER ;