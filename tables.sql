-- -----------------------------------------------------
-- Schema MailOrderingSystem
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS `MailOrderingSystem` ;
USE `MailOrderingSystem` ;

-- -----------------------------------------------------
-- Table `MailOrderingSystem`.`EMPLOYEE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EMPLOYEE` (
  `Employee_ID` INT NOT NULL AUTO_INCREMENT,
  `First_name` VARCHAR(350) NULL,
  `Last_name` VARCHAR(350) NULL,
  `ZIP_code` VARCHAR(10) NULL,
  PRIMARY KEY (`Employee_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MailOrderingSystem`.`ORDER_STATUS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ORDER_STATUS` (
  `Status_ID` INT NOT NULL AUTO_INCREMENT,
  `Status` VARCHAR(8) NULL,
  `Date` DATE NULL,
  PRIMARY KEY (`Status_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MailOrderingSystem`.`CUSTOMER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CUSTOMER` (
  `Customer_ID` INT NOT NULL AUTO_INCREMENT,
  `First_name` VARCHAR(350) NULL,
  `Last_name` VARCHAR(350) NULL,
  `ZIP_code` VARCHAR(10) NULL,
  PRIMARY KEY (`Customer_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MailOrderingSystem`.`ORDER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ORDER` (
  `Order_ID` INT NOT NULL AUTO_INCREMENT,
  `Date_of_receipt` DATE NULL,
  `Employee_ID` INT NOT NULL,
  `Customer_ID` INT NOT NULL,
  `Status_ID` INT NOT NULL,
  PRIMARY KEY (`Order_ID`),
  INDEX `Employee_ID_idx` (`Employee_ID` ASC) VISIBLE,
  INDEX `Status_ID_idx` (`Status_ID` ASC) VISIBLE,
  INDEX `Customer_ID_idx` (`Customer_ID` ASC) VISIBLE,
  CONSTRAINT `Employee_ID`
    FOREIGN KEY (`Employee_ID`)
    REFERENCES `EMPLOYEE` (`Employee_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Status_ID`
    FOREIGN KEY (`Status_ID`)
    REFERENCES `ORDER_STATUS` (`Status_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Customer_ID`
    FOREIGN KEY (`Customer_ID`)
    REFERENCES `CUSTOMER` (`Customer_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MailOrderingSystem`.`PART`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PART` (
  `Part_ID` INT NOT NULL,
  `Part_name` VARCHAR(100) NULL,
  `Price` DOUBLE NOT NULL,
  `Quantity_in_stock` INT NOT NULL CHECK (`Quantity_in_stock` >= 0) DEFAULT 0,
  PRIMARY KEY (`Part_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MailOrderingSystem`.`ORDER_PART`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ORDER_PART` (
  `Order_ID` INT NOT NULL,
  `Part_ID` INT NOT NULL,
  `Quantity_in_cart` INT NOT NULL CHECK (`Quantity_in_cart` >= 0) DEFAULT 0,
  PRIMARY KEY (`Order_ID`, `Part_ID`),
  INDEX `Part_ID_idx` (`Part_ID` ASC) VISIBLE,
  INDEX `Order_ID_idx` (`Order_ID` ASC) VISIBLE,
  CONSTRAINT `Order_ID`
    FOREIGN KEY (`Order_ID`)
    REFERENCES `ORDER` (`Order_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Part_ID`
    FOREIGN KEY (`Part_ID`)
    REFERENCES `PART` (`Part_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;