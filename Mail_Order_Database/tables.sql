-- WARNING! RESET THE DATABASE
######################################
## DROP DATABASE MailOrderingSystem ##
######################################

-- -----------------------------------------------------
-- Schema MailOrderingSystem
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS `MailOrderingSystem` ;
USE `MailOrderingSystem` ;

-- -----------------------------------------------------
-- Table `MailOrderingSystem`.`EMPLOYEE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Employee` (
  `Employee_ID` INT NOT NULL AUTO_INCREMENT,
  `First_name` VARCHAR(350) NOT NULL,
  `Last_name` VARCHAR(350) NOT NULL,
  `ZIP_code` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`Employee_ID`))
ENGINE = InnoDB;


-- REMOVED FOR SEMPLICITY SAKE
-- -- -----------------------------------------------------
-- -- Table `MailOrderingSystem`.`ORDER_STATUS`
-- -- -----------------------------------------------------
-- CREATE TABLE IF NOT EXISTS `ORDER_STATUS` (
--   `Status_ID` INT NOT NULL AUTO_INCREMENT,
--   `Status` VARCHAR(8) NULL,
--   `Date` DATE NULL,
--   PRIMARY KEY (`Status_ID`))
-- ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MailOrderingSystem`.`CUSTOMER`
-- -----------------------------------------------------
 CREATE TABLE IF NOT EXISTS `Customer` (
  `Customer_ID` INT NOT NULL AUTO_INCREMENT,
  `First_name` VARCHAR(350) NOT NULL,
  `Last_name` VARCHAR(350) NOT NULL,
  `ZIP_code` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`Customer_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MailOrderingSystem`.`ORDER_LIST`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Order_list` ( -- replaces ORDER
  `Order_ID` INT NOT NULL AUTO_INCREMENT,
  `Employee_ID` INT NOT NULL,
  `Customer_ID` INT NOT NULL,
  `Date_of_receipt` DATE NOT NULL,
  `Planned_ship` DATE NOT NULL,  -- it was making everything a bit complex for me so I decided to keep it simple and change the structure of the DB
  `Actual_ship` DATE NULL,   -- actual_ship and planned_ship were added to substitute the Status_ID and its related ORDER_STATUS table,
  PRIMARY KEY (`Order_ID`),
  CONSTRAINT `Employee_ID`
    FOREIGN KEY (`Employee_ID`)
    REFERENCES `Employee` (`Employee_ID`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `Customer_ID`
    FOREIGN KEY (`Customer_ID`)
    REFERENCES `Customer` (`Customer_ID`)
    ON DELETE CASCADE -- customers can be deleted from the database
    ON UPDATE RESTRICT) -- their id cannot be updated 
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MailOrderingSystem`.`PART`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Part` (
  `Part_ID` INT NOT NULL,
  `Part_name` VARCHAR(100) NOT NULL,
  `Price` DOUBLE NOT NULL,
  `Quantity_in_stock` INT NOT NULL CHECK (`Quantity_in_stock` >= 0) DEFAULT 0,
  PRIMARY KEY (`Part_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MailOrderingSystem`.`ORDER_PART`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Order_part` (
  `Order_ID` INT NOT NULL,
  `Part_ID` INT NOT NULL,
  `Quantity_in_cart` INT NOT NULL CHECK (`Quantity_in_cart` >= 0) DEFAULT 0,
  PRIMARY KEY (`Order_ID`, `Part_ID`),
  CONSTRAINT `Order_ID`
    FOREIGN KEY (`Order_ID`)
    REFERENCES `Order_list` (`Order_ID`)
    ON DELETE CASCADE -- deletion of order id will result in cancelling of order 
    ON UPDATE RESTRICT, -- order id cannot be updated
  CONSTRAINT `Part_ID`
    FOREIGN KEY (`Part_ID`)
    REFERENCES `Part` (`Part_ID`)
    ON DELETE CASCADE -- parts can be removed from db
    ON UPDATE RESTRICT)  -- part id cannot be updated
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Data Insertion -- 
-- mockaroo was used to generate data, but some of the
-- colums have been manually modified
-- -----------------------------------------------------

INSERT INTO Employee (Employee_ID, First_name, Last_name, ZIP_code) VALUES 
(1, 'Justinian', 'Delap', '2805'), (2, 'Peterus', 'Mellor', '84389'),
(3, 'Rolf', 'Losseljong', '9712'), (4, 'Rhona', 'Pettiward', '13284'), 
(5, 'Sheri', 'Bennetto', '3673'), (6, 'Osbourn', 'Whatford', '69913'),
(7, 'Karry', 'Partkya', '3119'), (8, 'Yalonda', 'Latus', '10384'),
(9, 'Niels', 'Condell', '8841'), (10, 'Tamarra', 'Kochl', '47394');

INSERT INTO Customer (Customer_ID, First_name, Last_name, ZIP_code) VALUES
(1, 'Brenden', 'Leopard', '10160'), (2, 'Tish', 'Van Castele', '91303'),
(3, 'Angelique', 'Di Ruggiero', '11293'), (4, 'Carilyn', 'Lapenna', '51361'),
(5, 'Clara', 'Nelle', '93462'), (6, 'Eli', 'Devon', '43528'),
(7, 'Demetri', 'Paunsford', '79977'), (8, 'Elsworth', 'Stitch', '668010'), 
(9, 'Pollyanna', 'Draude', '7200-505'), (10, 'Artus', 'Brownlie', '37122');

INSERT INTO Part (Part_ID, Part_name, Price, Quantity_in_stock) VALUES 
(1, 'Wood', 2.93, 360), (2, 'Aluminum', 2.3, 431),
(3, 'Steel', 9.43, 438), (4, 'Stone', 1.69, 492),
(5, 'Plexiglass', 9.39, 305), (6, 'Steel', 8.74, 274),
(7, 'Brass', 4.18, 89), (8, 'Rubber', 9.73, 49),
(9, 'Steel', 8.24, 24), (10, 'Wood', 3.39, 123);

INSERT Order_list (Order_ID, Employee_ID, Customer_ID, Date_of_receipt, Planned_ship, Actual_ship) VALUES 
(1, 1, 2, '2021-07-13', '2021-07-16', '2021-07-21'), (2, 2, 3, '2021-08-16', '2021-08-19', '2021-08-30'),
(3, 3, 4, '2020-03-22', '2020-03-30', NULL), (4, 4, 5, '2019-03-12', '2019-03-14', '2019-03-22'),
(5, 5, 6, '2020-11-19', '2020-12-02', NULL), (6, 6, 7, '2019-08-17', '2019-08-20', '2019-08-23'),
(7, 7, 8, '2019-01-09', '2019-01-10', '2019-02-02'), (8, 8, 9, '2018-12-17', '2018-12-19', NULL),
(9, 9, 10, '2021-09-17', '2021-09-19', '2021-09-20'), (10, 10, 1, '2021-10-02', '2021-10-09', NULL);

INSERT INTO Order_part (Part_ID, Order_ID, Quantity_in_cart) VALUES 
(1, 2, 100), (3, 10, 23), (10, 4, 11), (10, 6, 33), (7, 5, 3),
(9, 8, 7), (8, 1, 12), (5, 7, 11), (4, 3, 79), (4, 2, 17);