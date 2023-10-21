CREATE DATABASE sql_superstore_2;
use sql_superstore_2;

-- Create tha superstore_data table
CREATE TABLE `superstore_data` (
  `Row_ID` int,
  `Order_ID` varchar(255),
  `Order_Date` date,
  `Ship_Date` date,
  `Ship_Mode` varchar(255),
  `Customer_ID` varchar(255),
  `Customer_Name` varchar(255),
  `Segment` varchar(255),
  `Country_Region` varchar(255),
  `City` varchar(255),
  `State` varchar(255),
  `Postal_Code` varchar(255),
  `Region` varchar(255),
  `Product_ID` varchar(255),
  `Category` varchar(255),
  `Sub_Category` varchar(255),
  `Product_Name` varchar(255),
  `Sales` decimal(10, 2),
  `Quantity` int,
  `Discount` decimal(5, 2),
  `Profit` decimal(10, 2),
  PRIMARY KEY (`Row_ID`)
);

-- Finding secure directory to put the CSV file in the secure directory
SHOW VARIABLES LIKE 'secure_file_priv';

-- Load the CSV data into the new table using the 'latin-1' encoding
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.1/Uploads/Sample_Superstore_1.csv'
INTO TABLE superstore_data
CHARACTER SET latin1
FIELDS TERMINATED BY ',' ENCLOSED BY '"' -- Adjust the delimiter and enclosure as needed
LINES TERMINATED BY '\n'
IGNORE 1 LINES; 

-- ------------------------------------------------------------------------------

-- Create tha People_data table
CREATE TABLE `People` (
  `Region_IDi` int auto_increment,
  `Regional_Manager` varchar(255),
  `Region` varchar(255),
  PRIMARY KEY (`Region_IDi`)
);

-- Load the CSV data into the new table using the 'latin-1' encoding
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.1/Uploads/People.csv'
INTO TABLE People
CHARACTER SET latin1
FIELDS TERMINATED BY ',' ENCLOSED BY '"' -- Adjust the delimiter and enclosure as needed
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(`Regional_Manager`, `Region`); 

-- -------------------------------------------------------------------------------

-- Create the Customers table with an integer primary key:
CREATE TABLE `customers` (
	`Customer_IDi` int auto_increment,
  `Customer_ID` varchar(255),
  `Customer_Name` varchar(255),
  PRIMARY KEY (`Customer_IDi`)
);

-- Insert data into the Customers table and maintain the mapping between the alphanumeric IDs and integer keys:
INSERT INTO Customers (Customer_ID, Customer_Name)
SELECT DISTINCT
	s1.Customer_ID,
    s1.Customer_Name
FROM superstore_data s1
JOIN superstore_data s2
ON s1.Customer_ID = s2.Customer_ID;


-- Create the Products table with an integer primary key:
CREATE TABLE `products` (
  `Product_IDi` int AUTO_INCREMENT,
  `Product_ID` varchar(255),
  `Category` varchar(255),
  `Sub_Category` varchar(255),
  `Product_Name` varchar(255),
  KEY `AK` (`Product_ID`),
  PRIMARY KEY (`Product_IDi`)
);

-- Insert data into the Products table and maintain the mapping between the alphanumeric IDs and integer keys:
INSERT INTO Products (Product_ID, Category, Sub_Category, Product_Name)
SELECT DISTINCT
	s1.Product_ID,
    s1.Category, 
    s1.Sub_Category, 
    s1.Product_Name
FROM superstore_data s1
JOIN superstore_data s2
ON s1.Product_ID = s2.Product_ID;


-- Create the Orders table with integer foreign keys for Customer_IDi:
CREATE TABLE `orders` (
  `Order_IDi` int AUTO_INCREMENT,
  `Order_ID` varchar(255),
  `Order_Date` date,
  `Ship_Date` date,
  `Ship_Mode` varchar(255),
  `Segment` VARCHAR(255),
  `Country_Region` VARCHAR(255),
  `City` VARCHAR(255),
  `State` VARCHAR(255),
  `Postal_Code` VARCHAR(255),
  `Region_IDi` int,
  `Customer_IDi` int,
  KEY `AK` (`Order_ID`),
  PRIMARY KEY (`Order_IDi`),
  FOREIGN KEY (`Customer_IDi`) REFERENCES `customers`(`Customer_IDi`),
  FOREIGN KEY (`Region_IDi`) REFERENCES `People`(`Region_IDi`)
);

-- Insert data into the Orders table using the alphanumeric Order_ID, but maintain the integer foreign keys:
INSERT INTO Orders (Order_ID, Order_Date, Ship_Date, Ship_Mode, Segment, Country_Region, City, State, Postal_Code, Region_IDi, Customer_IDi)
SELECT DISTINCT
    s1.Order_ID,
    s1.Order_Date, 
    s1.Ship_Date, 
    s1.Ship_Mode, 
    s1.Segment, 
    s1.Country_Region, 
    s1.City, 
    s1.State, 
    s1.Postal_Code, 
    p.Region_IDi, 
    c.Customer_IDi 
FROM superstore_data s1
JOIN customers c ON s1.Customer_ID = c.Customer_ID
JOIN superstore_data s2 ON s1.Order_ID = s2.Order_ID
JOIN People p ON s1.Region = REPLACE(p.Region, '\r', ''); 
  

-- Insert data into the Orders table using the alphanumeric Order_ID, but maintain the integer foreign keys:
CREATE TABLE `order_items` (
  `Order_IDi` int,
  `Product_IDi` int,
  `Sales` decimal(10, 2),
  `Quantity` int,
  `Discount` decimal(5, 2),
  `Profit` decimal(10, 2),
  FOREIGN KEY (`Order_IDi`) REFERENCES `orders`(`Order_IDi`),
  FOREIGN KEY (`Product_IDi`) REFERENCES `products`(`Product_IDi`)
);

-- Insert data into the Orders table using the alphanumeric Order_ID, but maintain the integer foreign keys:
INSERT INTO Order_items (Order_IDi, Product_IDi, Sales, Quantity, Discount, Profit)
SELECT DISTINCT
    orders.Order_IDi, 
    products.Product_IDi,  
    Sales, 
    Quantity, 
    Discount, 
    Profit 
FROM superstore_data s1
JOIN products ON s1.Product_ID = products.Product_ID
JOIN orders ON s1.Order_ID = orders.Order_ID;

-- ---------------------------------------------------------------------------

-- Create tha Returned_Order_data table
CREATE TABLE `Returns` (
  `Returns_IDi` int auto_increment,
  `Returns_status` varchar(255),
  `Returned_Order_ID` varchar(255),
  PRIMARY KEY (`Returns_IDi`)
  -- FOREIGN KEY (`Region`) REFERENCES `Orders`(`Region`)
);

-- Load the CSV data into the new table using the 'latin-1' encoding
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.1/Uploads/Returns.csv'
INTO TABLE `Returns`
CHARACTER SET latin1
FIELDS TERMINATED BY ',' ENCLOSED BY '"' -- Adjust the delimiter and enclosure as needed
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(`Returns_status`, `Returned_Order_ID`); 

-- -------------------------------------------------------------------------------------------

-- Finding secure directory 
-- SHOW VARIABLES LIKE 'secure_file_priv';

select 'Customer_IDi', 'Customer_ID', 'Customer_Name'
union
select *
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.1/Uploads/Customers.csv'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
from customers;


-- -------------------------------------------------------------------------------------------

-- To create an executive table to compare the sales value in years 2020 and 2021 an assumed superstore
with 
region_sales as (

with 
Sales_Date_1 AS (
select p.Region, o.State, oi.Order_IDi,
	sum(oi.Sales * oi.Quantity) as sales_1, sum(oi.Profit * oi.Quantity) as Profit_1
from people p 
join orders o on o.Region_IDi = p.Region_IDi 
join order_items oi on oi.Order_IDi = o.Order_IDi 
where o.Order_Date like '2020-%' and REPLACE(p.Region, '\r', '') = 'Central'
group by oi.Order_IDi
),

Sales_Date_2 AS (
select p.Region, o.State, oi.Order_IDi,
sum(oi.Sales * oi.Quantity) as sales_2, sum(oi.Profit * oi.Quantity) as Profit_2
from people p 
join orders o on o.Region_IDi = p.Region_IDi 
join order_items oi on oi.Order_IDi = o.Order_IDi 
where o.Order_Date like '2021-%' and REPLACE(p.Region, '\r', '') = 'Central'
group by oi.Order_IDi
)

SELECT s1.Region, s1.State, sum(sales_1) as sales_date_1, sum(sales_2) as sales_date_2, 
	sum(Profit_1) as Profit_date_1, sum(Profit_2) as Profit_date_2 
FROM Sales_Date_1 s1
left join Sales_Date_2 s2 on s2.State = s1.State
GROUP BY s1.Region, s1.State

),

region_returns as (

with 
Returns_Date_1 AS (
select p.Region, o.State, oi.Order_IDi,
	sum(oi.Sales * oi.Quantity) as Returns_sales_1, sum(oi.Profit * oi.Quantity) as Returns_Profit_1
from people p 
join orders o on o.Region_IDi = p.Region_IDi 
join order_items oi on oi.Order_IDi = o.Order_IDi 
join returns r on REPLACE(r.Returned_Order_ID, '\r', '') = o.Order_ID
where o.Order_Date like '2020-%' and REPLACE(p.Region, '\r', '') = 'Central'
group by oi.Order_IDi
),

Returns_Date_2 AS (
select p.Region, o.State, oi.Order_IDi,
	sum(oi.Sales * oi.Quantity) as Returns_sales_2, sum(oi.Profit * oi.Quantity) as Returns_Profit_2
from people p 
join orders o on o.Region_IDi = p.Region_IDi 
join order_items oi on oi.Order_IDi = o.Order_IDi 
join Returns r on REPLACE(r.Returned_Order_ID, '\r', '') = o.Order_ID
where o.Order_Date like '2021-%' and REPLACE(p.Region, '\r', '') = 'Central'
group by oi.Order_IDi
)

SELECT r1.Region, r1.State, sum(Returns_sales_1) as Returns_date_1, sum(Returns_sales_2) as Returns_date_2,
	sum(Returns_Profit_1) as Returns_Profit_date_1, sum(Returns_Profit_2) as Returns_Profit_date_2 
FROM Returns_Date_1 r1
left join Returns_Date_2 r2 on r2.State = r1.State
GROUP BY r1.Region, r1.State
),

total_sales as (
select 
	Region,
	sum(sales_date_1) as date_1_total_sales,
	sum(sales_date_2) as date_2_total_sales,
	sum(Profit_date_1) as date_1_total_Profit,
	sum(Profit_date_2) as date_2_total_Profit
from region_sales 
group by Region
),

total_returns as (
select 
	Region,
	sum(Returns_date_1) as date_1_total_returns,
	sum(Returns_date_2) as date_2_total_returns,
	sum(Returns_Profit_date_1) as date_1_total_returns_Profit,
	sum(Returns_Profit_date_2) as date_2_total_returns_Profit
from region_returns
group by Region
),

main_query AS (
SELECT
    rs.Region,
    p.Regional_Manager,
    rs.State,
    (rs.sales_date_1 - COALESCE(rr.Returns_date_1, 0)) AS sales_date_1,
    (rs.sales_date_2 - COALESCE(rr.Returns_date_2, 0)) AS sales_date_2,
    ((rs.sales_date_2 - COALESCE(rr.Returns_date_2, 0)) - (rs.sales_date_1 - COALESCE(rr.Returns_date_1, 0))) AS date_2_VS_date_1,
    ((rs.sales_date_1 - COALESCE(rr.Returns_date_1, 0)) / (ts.date_1_total_sales - COALESCE(tr.date_1_total_returns, 0))) AS Sales_Parti_date_1,
    ((rs.sales_date_2 - COALESCE(rr.Returns_date_2, 0)) / (ts.date_2_total_sales - COALESCE(tr.date_2_total_returns, 0))) AS Sales_Parti_date_2,
    (rs.Profit_date_1 - COALESCE(rr.Returns_Profit_date_1, 0)) AS Profit_date_1,
    (rs.Profit_date_2 - COALESCE(rr.Returns_Profit_date_2, 0)) AS Profit_date_2
FROM
    region_sales rs
LEFT JOIN
    region_returns rr ON rr.State = rs.State
LEFT JOIN
    total_sales ts ON ts.Region = rs.Region
LEFT JOIN
    total_returns tr ON tr.Region = rs.Region
LEFT JOIN
    people p ON p.Region = rs.Region
)

-- The main query with subquery for summary row
SELECT * FROM main_query

UNION ALL

-- Summary row
SELECT
    'Total' AS Region,
    NULL AS Regional_Manager,
    'Total' AS State,
    SUM(sales_date_1),
    SUM(sales_date_2),
    SUM(date_2_VS_date_1), 
    SUM(Sales_Parti_date_1),
    SUM(Sales_Parti_date_2),
    SUM(Profit_date_1),
    SUM(Profit_date_2)
-- To save the data in the secure directory 
-- INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.1/Uploads/Central.csv'
-- FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
FROM main_query;
