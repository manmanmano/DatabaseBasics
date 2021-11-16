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
  `First_name` VARCHAR(350) NULL,
  `Last_name` VARCHAR(350) NULL,
  `ZIP_code` VARCHAR(10) NULL,
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
  `First_name` VARCHAR(350) NULL,
  `Last_name` VARCHAR(350) NULL,
  `ZIP_code` VARCHAR(10) NULL,
  PRIMARY KEY (`Customer_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MailOrderingSystem`.`ORDER_LIST`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Order_list` ( -- replaces ORDER
  `Order_ID` INT NOT NULL AUTO_INCREMENT,
  `Date_of_receipt` DATE NULL,
  `Employee_ID` INT NOT NULL,
  `Customer_ID` INT NOT NULL,
  `Status_ID` INT NOT NULL,
  `Actual_ship` DATE NULL,   -- actual_ship and planned_ship were added to substitute the Status_ID and its related ORDER_STATUS table,
  `Planned_ship` DATE NULL,  -- it was making everything a bit complex for me so I decided to keep it simple and change the structure of the DB
  PRIMARY KEY (`Order_ID`),
  CONSTRAINT `Employee_ID`
    FOREIGN KEY (`Employee_ID`)
    REFERENCES `Employee` (`Employee_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Customer_ID`
    FOREIGN KEY (`Customer_ID`)
    REFERENCES `Customer` (`Customer_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MailOrderingSystem`.`PART`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Part` (
  `Part_ID` INT NOT NULL,
  `Part_name` VARCHAR(100) NULL,
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
    ON DELETE CASCADE
    ON UPDATE RESTRICT,
  CONSTRAINT `Part_ID`
    FOREIGN KEY (`Part_ID`)
    REFERENCES `Part` (`Part_ID`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT)
ENGINE = InnoDB;