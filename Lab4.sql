create database if not exists `order-directory` ;
use `order-directory`;

create table if not exists `supplier`(
`SUPP_ID` int primary key,
`SUPP_NAME` varchar(50) ,
`SUPP_CITY` varchar(50),
`SUPP_PHONE` varchar(10)
);

CREATE TABLE IF NOT EXISTS `customer` (
  `CUS_ID` INT NOT NULL,
  `CUS_NAME` VARCHAR(20) NULL DEFAULT NULL,
  `CUS_PHONE` VARCHAR(10),
  `CUS_CITY` varchar(30) ,
  `CUS_GENDER` CHAR,
  PRIMARY KEY (`CUS_ID`)
  );

CREATE TABLE IF NOT EXISTS `category` (
  `CAT_ID` INT NOT NULL,
  `CAT_NAME` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`CAT_ID`)
  );

  CREATE TABLE IF NOT EXISTS `product` (
  `PRO_ID` INT NOT NULL,
  `PRO_NAME` VARCHAR(20) NULL DEFAULT NULL,
  `PRO_DESC` VARCHAR(60) NULL DEFAULT NULL,
  `CAT_ID` INT NOT NULL,
  PRIMARY KEY (`PRO_ID`),
  FOREIGN KEY (`CAT_ID`) REFERENCES category (`CAT_ID`)
  );

 CREATE TABLE IF NOT EXISTS `product_details` (
  `PROD_ID` INT NOT NULL,
  `PRO_ID` INT NOT NULL,
  `SUPP_ID` INT NOT NULL,
  `PROD_PRICE` INT NOT NULL,
  PRIMARY KEY (`PROD_ID`),
  FOREIGN KEY (`PRO_ID`) REFERENCES product (`PRO_ID`),
  FOREIGN KEY (`SUPP_ID`) REFERENCES supplier (`SUPP_ID`)
  );
 
CREATE TABLE IF NOT EXISTS `order` (
  `ORD_ID` INT NOT NULL,
  `ORD_AMOUNT` INT NOT NULL,
  `ORD_DATE` DATE,
  `CUS_ID` INT NOT NULL,
  `PROD_ID` INT NOT NULL,
  PRIMARY KEY (`ORD_ID`),
  FOREIGN KEY (`CUS_ID`) REFERENCES customer (`CUS_ID`),
  FOREIGN KEY (`PROD_ID`) REFERENCES product_details (`PROD_ID`)
  );

CREATE TABLE IF NOT EXISTS `rating` (
  `RAT_ID` INT NOT NULL,
  `CUS_ID` INT NOT NULL,
  `SUPP_ID` INT NOT NULL,
  `RAT_RATSTARS` INT NOT NULL,
  PRIMARY KEY (`RAT_ID`),
  FOREIGN KEY (`SUPP_ID`) REFERENCES supplier (`SUPP_ID`),
  FOREIGN KEY (`CUS_ID`) REFERENCES customer (`CUS_ID`)
  );

insert into `supplier` values(1,"Rajesh Retails","Delhi",'1234567890');
insert into `supplier` values(2,"Appario Ltd.","Mumbai",'2589631470');
insert into `supplier` values(3,"Knome products","Banglore",'9785462315');
insert into `supplier` values(4,"Bansal Retails","Kochi",'8975463285');
insert into `supplier` values(5,"Mittal Ltd.","Lucknow",'7898456532');
  
INSERT INTO `CUSTOMER` VALUES(1,"AAKASH",'9999999999',"DELHI",'M');
INSERT INTO `CUSTOMER` VALUES(2,"AMAN",'9785463215',"NOIDA",'M');
INSERT INTO `CUSTOMER` VALUES(3,"NEHA",'9999999999',"MUMBAI",'F');
INSERT INTO `CUSTOMER` VALUES(4,"MEGHA",'9994562399',"KOLKATA",'F');
INSERT INTO `CUSTOMER` VALUES(5,"PULKIT",'7895999999',"LUCKNOW",'M');
  
INSERT INTO `CATEGORY` VALUES( 1,"BOOKS");
INSERT INTO `CATEGORY` VALUES(2,"GAMES");
INSERT INTO `CATEGORY` VALUES(3,"GROCERIES");
INSERT INTO `CATEGORY` VALUES (4,"ELECTRONICS");
INSERT INTO `CATEGORY` VALUES(5,"CLOTHES");
  
INSERT INTO `PRODUCT` VALUES(1,"GTA V","DFJDJFDJFDJFDJFJF",2);
INSERT INTO `PRODUCT` VALUES(2,"TSHIRT","DFDFJDFJDKFD",5);
INSERT INTO `PRODUCT` VALUES(3,"ROG LAPTOP","DFNTTNTNTERND",4);
INSERT INTO `PRODUCT` VALUES(4,"OATS","REURENTBTOTH",3);
INSERT INTO `PRODUCT` VALUES(5,"HARRY POTTER","NBEMCTHTJTH",1);
  
INSERT INTO `PRODUCT_DETAILS` VALUES(1,1,2,1500);
INSERT INTO `PRODUCT_DETAILS` VALUES(2,3,5,30000);
INSERT INTO `PRODUCT_DETAILS` VALUES(3,5,1,3000);
INSERT INTO `PRODUCT_DETAILS` VALUES(4,2,3,2500);
INSERT INTO `PRODUCT_DETAILS` VALUES(5,4,1,1000);

INSERT INTO `ORDER` VALUES (50,2000,"2021-10-06",2,1);
INSERT INTO `ORDER` VALUES(20,1500,"2021-10-12",3,5);
INSERT INTO `ORDER` VALUES(25,30500,"2021-09-16",5,2);
INSERT INTO `ORDER` VALUES(26,2000,"2021-10-05",1,1);
INSERT INTO `ORDER` VALUES(30,3500,"2021-08-16",4,3);
  
INSERT INTO `RATING` VALUES(1,2,2,4);
INSERT INTO `RATING` VALUES(2,3,4,3);
INSERT INTO `RATING` VALUES(3,5,1,5);
INSERT INTO `RATING` VALUES(4,1,3,2);
INSERT INTO `RATING` VALUES(5,4,5,4);

-- 3)	Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.
select customer.cus_gender,count(customer.cus_gender) as count 
from customer
join `order`
on customer.cus_id=`order`.cus_id
where `order`.ord_amount>=3000
group by customer.cus_gender;

-- 4)	Display all the orders along with the product name ordered by a customer having Customer_Id=2.
select `order`.*, product.pro_name
from `order`, product_details, product
where `order`.cus_id=2
and `order`.prod_id = product_details.prod_id
and product_details.pro_id = product.pro_id;

-- 5)	Display the Supplier details who can supply more than one product.
select supplier.*
from supplier, product_details
where supplier.supp_id in
(
select product_details.supp_id
from product_details
group by product_details.supp_id
having count(product_details.supp_id) > 1
)
group by supplier.supp_id;

-- 6)	Find the category of the product whose order amount is minimum.
select category.*, `order`.ord_id
from `order`
inner join product_details
on `order`.prod_id = product_details.prod_id
inner join product on product.pro_id = product_details.pro_id
inner join category on category.cat_id = product.cat_id
having min(`order`.ord_amount);

-- 7)	Display the Id and Name of the Product ordered after “2021-10-05”.
select product.pro_id, product.pro_name from product
join product_details on product.pro_id = product_details.pro_id
join `order` on product_details.prod_id = `order`.prod_id
where `order`.ord_date > '2021-10-05';

-- 8)	Display customer name and gender whose names start or end with character 'A'.
select cus_name, cus_id from customer
where cus_name like 'A%' or cus_name like '%A';

-- 9)	Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”.
DELIMITER &&
create procedure proc()
BEGIN
select supplier.supp_id, supplier.supp_name, rating.rat_ratstars,
case
	when rating.rat_ratstars >4 then 'GENUINE Supplier'
    when rating.rat_ratstars >2 then 'Average Supplier'
    else 'Supplier should not be considered'
END as verdict from rating inner join supplier on supplier.supp_id = rating.supp_id;
END
&& DELIMITER ;

call proc();
