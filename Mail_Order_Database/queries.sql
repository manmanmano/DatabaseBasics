/*
Query orders in a specified time frame returning:
- order number
- customer name
- number of ordered items
- total sum
- expected shipping
- actual shipping 
*/

SELECT Order_list.Order_ID, Customer.First_name,  Order_list.actual_ship,
Order_list.Planned_ship FROM Customer
INNER JOIN Order_list ON Order_list.Customer_ID = Customer.Customer_ID
WHERE Order_list.Date_of_receipt  BETWEEN '20210101' AND '20211231'
ORDER BY Order_list.Order_ID ASC;