/*
Query orders in a specified time frame returning:
- order number
- customer name
- number of ordered items
- total sum
- expected shipping
- actual shipping 
*/

SELECT SUM(Order_part.Quantity_in_cart * Part.Price) AS Total, 
SUM(Order_part.Quantity_in_cart) AS Ordered_items, Order_list.Order_ID, 
Customer.First_name AS Customer_name,  Order_list.Actual_ship, Order_list.Planned_ship 
FROM Customer
INNER JOIN Order_list ON Order_list.Customer_ID = Customer.Customer_ID
INNER JOIN Order_part ON Order_part.Order_ID = Order_list.Order_ID
INNER JOIN Part ON Part.Part_ID = Order_part.Part_ID
WHERE Order_list.Date_of_receipt BETWEEN '2021-01-01' AND '2021-12-31'
GROUP BY 
Order_list.Order_ID, Customer.First_name, Order_list.Actual_ship, Order_list.Planned_ship
ORDER BY Order_list.Order_ID ASC;