create database e_commerse;

use e_commerse;

create table supplier 
(supp_id int primary key,
supp_name varchar(50),supp_city varchar(50),
supp_phone varchar(50) not null);

create table customer
(cust_id int primary key,
cust_name varchar(50) not null,
cust_phone varchar(50) not null,
cust_city varchar(30) not null,
cust_gender char);

create table catagory(
cat_id int primary key,
cat_name varchar(20) not null);

create table product(
prod_id int primary key,
prod_name varchar(50) not null default "dummy",
prod_desc varchar(60),
cat_id int,
foreign key (cat_id) references catagory(cat_id));

create table supplier_pricing
(pricing_id int primary key,
prod_id int,
supp_id int,
foreign key (prod_id) references product(prod_id),
foreign key (supp_id) references supplier(supp_id),
supp_price int default 0);

create table cust_order(
ord_id int primary key,
ord_amt int not null,
ord_date date not null,
cust_id int,
pricing_id int, 
foreign key (cust_id) references customer(cust_id),
foreign key (pricing_id) references supplier_pricing(pricing_id));

create table rating
(rat_id int primary key,
ord_id int,
rat_ratstars int not null,
foreign key (ord_id) references cust_order(ord_id));

insert into supplier values 
(1,'Rajesh Retails','delhi','1234567890'),
(2,'Appario Ltd.','mumbai','2589631470'),
(3,'Knome products','banglore','9785462315'),
(4,'Bansal Retails','kochi','8975463285'),
(5,'Mittal Ltd.','lucknow','7898456532');

insert into customer values
(1,'akash','9999999999','delhi','m'),
(2,'aman','9785463215','noida','m'),
(3,'neha','9999999999','mumbai','f'),
(4,'megha','9994562399','kolkata','f'),
(5,'pulkit','7895999999','lucknow','m');

insert into  catagory values
(1,'books'),
(2,'games'),
(3,'groceries'),
(4,'electronics'),
(5,'clothes');

insert into product values
(1,'gta v','Windows 7 and above with i5 processor and 8GB RAM',2),
(2,'tshirt','SIZE-L with Black, Blue and White variations',5),
(3,'rog laptop','Windows 10 with 15inch screen, i7 processor, 1TB SSD',4),
(4,'oats','Highly Nutritious from Nestle',3),
(5,'harry porter','Best Collection of all time by J.K Rowling ',1),
(6,'milk','1L Toned MIlk',3),
(7,'boat earphones','1.5Meter long Dolby Atmos',4),
(8,'jeans','Stretchable Denim Jeans with various sizes and color',5),
(9,'project IGI','compatible with windows 7 and above',2),
(10,'Hoodie','Black GUCCI for 13 yrs and above',5),
(11,'Rich Dad Poor Dad','Written by RObert Kiyosaki',1),
(12,'Train Your Brain','By Shireen Stephen',1);

insert into supplier_pricing values
(1,1,2,1500),
(2,3,5,30000),
(3,5,1,3000),
(4,2,3,2500),
(5,4,1,1000);

insert into cust_order values
(101,1500,'2021-10-06',2,1),
(102,1000,'2021-10-12',3,5),
(103,30000,'2021-09-16',5,2),
(104,1500,'2021-10-05',1,1),
(105,3000,'2021-08-16',4,3),
(106,1450,'2021-08-18',1,4),
(107,789,'2021-09-01',3,2),
(108,780,'2021-09-07',5,5),
(109,3000,'2021-00-10',5,3),
(110,2500,'2021-09-10',2,4),
(111,1000,'2021-09-15',4,5),
(112,789,'2021-09-16',4,3),
(113,3100,'2021-09-16',1,4),
(114,1000,'2021-09-16',3,5),
(115,3000,'2021-09-16',5,3),
(116,99,'2021-09-17',2,1);

insert into rating values
(1,101,4),
(2,102,3),
(3,103,1),
(4,104,2),
(5,105,4),
(6,106,3),
(7,107,4),
(8,108,4),
(9,109,3),
(10,110,5),
(11,111,3),
(12,112,4);

#3
select count(1),c.cust_gender from customer c join cust_order o on c.cust_id
 = o.cust_id where ord_amt >= 3000 group by c.cust_gender;
 
#4
select c.*,p.prod_name from cust_order c join supplier_pricing s on 
c.pricing_id = s.pricing_id join product p on s.prod_id = p.prod_id
where c.cust_id = 2;

#5 
select * from supplier where supp_id in (
select supp_id from supplier_pricing group by supp_id having count(prod_id) > 1);

#6
select min(s.supp_price) Least_expensive ,p.*,c.cat_name from supplier_pricing s join product p
on s.prod_id = p.prod_id join catagory c on p.cat_id = c.cat_id group by c.cat_id;

#7
select p.prod_id,p.prod_name,co.ord_date from product p 
join cust_order co where co.ord_date > '2021-10-05';

#8
select cust_name,cust_gender from customer where cust_name like '%A%';

#9
drop procedure Review;
DELIMITER $$
CREATE PROCEDURE Review()
BEGIN
SELECT s.SUPP_ID, s.SUPP_NAME, rt.RAT_RATSTARS,
CASE
    WHEN rt.RAT_RATSTARS =5 THEN 'EXCELLENT SERVICE'
    WHEN rt.RAT_RATSTARS = 4 THEN 'GOOD SERVICE'
    WHEN rt.RAT_RATSTARS = 3 THEN 'AVGERAGE SERVICE'
	WHEN rt.RAT_RATSTARS > 2 THEN 'POOR SERVICE'
    ELSE 'VERY POOR SERVICE'
END AS Type_of_Service
FROM rating rt
INNER JOIN orders ON rt.ORD_ID= orders.ORD_ID
INNER JOIN supplier_pricing sp ON sp.PRICING_ID= orders.PRICING_ID
INNER JOIN supplier s ON s.SUPP_ID= sp.SUPP_ID;
END $$
DELIMITER ;

call Review();

