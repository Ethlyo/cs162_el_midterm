#HEADER
#Program Name: Midterm SQL
#Author: Ethan Lyons
#Class: CS162 Spring 2021
#Date: 5/18/2021
#description: A code that creates a database and tables based off of an ERD and example data

DROP DATABASE IF EXISTS simplesheetsorder;
CREATE DATABASE simplesheetsorder;
USE simplesheetsorder;

/*
Step 1) Make tables.

Address
	AddressID (int, autoinc, not null) PK
	Line1 (varchar50, not null)
    Line2 (varchar50, null)
    City (varchar30, not null)
    State (varchar30, null)
    Country (varchar56, not null)					Chose 56 as that is the longest English recognized country name (being the UK's full title).
    PostalCode (varchar20, not null)

Payment
	PaymentID (int, autoinc, not null) PK			For these payment methods, I decided just to leave them as varchars and give room for whatever relevant information is necessary
    WireInfo (varchar100, null)						You say this assumes things work, so these values would assume the correct format of inputs for SWIFT, Routing Numbers, Bank accounts, and all other info
    CreditInfo (varchar100, null)					What I would have done instead is make new entities for each of these so I can hold more information and format it correctly
    debitInfo (varchar100, null)					However, I decided this was not necessary nor the focus of the project.

Customer
	CustomerID (int, autoinc, not null) PK
	AddressID (int, not null) FK
    PaymentID (int, not null) FK
    CustomerName (varchar50, not null)				No first or Last name as a customer may be a company rather than an individual
    Email (varchar50, not null)
    Phone (varchar16, not null)

Item
	ItemID (int, autoinc, not null) PK
    ItemName (varchar50, not null)
    CostPer (decimal(10,2), not null)
    ItemDescription (varchar255, null)
    QuantityStock (int, not null)					For inventory purposes, would change with status
    NonHold (int, not null)							For inventory purposes, would change with status

OrderInfo
	OrderID (int, autoinc, not null) PK
	CustomerID (int, not null) FK
    OrderDate (date, not null)
    PaymentMethod (enum(cash, check, wired, credit, debit), not null)				To select a payment method if a customer has multiple, and to leave space for one-time transactions like cash and checks
    Status (enum(processing, paid, packaged, shipped, complete) not null)			For the process through the facility, how the order arrives to different employees at the proper time

OrderLine
	OrderID (int, not null) PK FK
    ItemID (int, not null) PK FK
	Quantity (int, not null)
    
Employees
	ID (int, autoinc, not null) PK
	FirstName (varchar20, not null)
    LastName (varchar20, not null)
    DepartmentID (in, not null) FK

Department
	DepartmentID (int, autoinc, not null) PK
	DepartmentName (varchar30, not null)
*/

CREATE TABLE Address (
	AddressID int PRIMARY KEY auto_increment NOT NULL,
    Line1 varchar(50) NOT NULL,
    Line2 varchar(50) NULL,
    City varchar(30) NOT NULL,
    State varchar(30) NULL,
    Country varchar(56) NOT NULL,
    PostalCode varchar(20) NOT NULL
	);
    
CREATE TABLE Payment (
	PaymentID int PRIMARY KEY auto_increment NOT NULL,
    WireInfo varchar(100) NULL,
    CreditInfo varchar(100) NULL,
    DebitInfo varchar(100) NULL
	);

CREATE TABLE Customer (
	CustomerID int PRIMARY KEY auto_increment NOT NULL,
	AddressID int NOT NULL,
    PaymentID int NOT NULL,
    CustomerName varchar(50) NOT NULL,				
    Email varchar(50) NOT NULL,
    Phone varchar(50) NOT NULL,
    FOREIGN KEY (AddressID) references Address(AddressID),
    FOREIGN KEY (PaymentID) references Payment(PaymentID)
    );

CREATE TABLE Item (
	ItemID int PRIMARY KEY auto_increment NOT NULL,
    ItemName varchar(50) NOT NULL,
    CostPer decimal(10,2) NOT NULL,
    ItemDescription varchar(255) NULL,
    QuantityStock int NOT NULL,				
    NonHold int NOT NULL
	);
    
 CREATE TABLE OrderInfo (
	OrderID int auto_increment NOT NULL,
	CustomerID int NOT NULL,
    OrderDate date NOT NULL,
    PaymentMethod enum('cash', 'check', 'wired', 'credit', 'debit') not null,
    OrderStatus enum('processing', 'paid', 'packaged', 'shipped', 'complete') not null,
    PRIMARY KEY (OrderID, CustomerID),
    FOREIGN KEY (CustomerID) references Customer(CustomerID)
	);
    
CREATE TABLE OrderLine (
	OrderID int NOT NULL,
    ItemID int NOT NULL,
    Quantity int NOT NULL,
    PRIMARY KEY (OrderID, ItemID),
    FOREIGN KEY (OrderID) references OrderInfo(OrderID),
    FOREIGN KEY (ItemID) references Item(ItemID)
	);

CREATE TABLE Department (
	DepartmentID int PRIMARY KEY auto_increment not null,
	DepartmentName varchar(30) not null
	);
    
CREATE TABLE Employees (
	EmployeeID int PRIMARY KEY auto_increment not null,
    DepartmentID int not null,
    FirstName varchar(20) not null,
    LastName varchar(20) not null,
    FOREIGN KEY (DepartmentID) references Department(DepartmentID)
	);

/*
Step 2) Insert data
*/

INSERT INTO Address (Line1, Line2, City, State, Country, PostalCode)
Values
	('1700 ABC St.', '' ,'Omaha', 'Nebraska', 'United States of America', '68102'),
    ('1315 Via Marccello', '' ,'Venice', 'Veneto', 'Italy', '30124'),
    ('1533 Cannon Way', 'Lot 100' ,'Vancouver', 'British Columbia', 'Canada', 'V5Z'),
    ('4326 Laoshu St.', '' ,'Beijing', 'Haubei', 'China', '100072'),
    ('653 Pale Ave.', 'Building C' ,'Miami', 'Florida', 'United States of Ameria', '33149');

INSERT INTO Payment (WireInfo, CreditInfo, DebitInfo)
Values
	('031312986 0017834349','002382451948 03/22 286 1315 Via Marcello Venice Venito Italy 30124',''),
    ('','','012257829812124 11/21 552 4326 Laoshu St. Beijing Haubei China 100072'),
    ('','',''),
    ('','',''),
    ('','0456787828218284123 6/23 480 1700 ABC St. Omaha Nebraska United States of America','');
    
INSERT INTO Customer (AddressID, PaymentID, CustomerName, Email, Phone)
Values
	('1', '5', 'Barbra Park', 'bpark@mailcompany.com', '+15555555555'),
    ('5', '3', 'Arrow Financials LLC', 'procurement@arrowfinancials.com', '+15555555556'),
    ('2', '1', 'Cappuccino Emprimere', 'augustpiri@cappuccinoexp.com', '+15555555557'),
    ('4', '2', 'Sun Xiao', 'sun.xiao@mailcompany.com', '+15555555558'),
    ('3', '4', 'Crown Digital Electronics', 'purchasing@crowndigital.com', '+15555555559');
    
INSERT INTO Item (ItemName, CostPer, ItemDescription, QuantityStock, NonHold)
Values
	('A4 Plain', '1.99', 'A 200 pack  of plain A4 sized paper ', '343', '287'),
    ('A4 Lined', '1.99', 'A 200 pack of lined A4 sized paper', '456', '428'),
    ('Legal Plain', '2.99', 'A 200 pack of plain Legal sized paper', '231', '189'),
    ('Postcard Plain', '15.99', 'A 100 pack of plain post cards', '58', '43'),
    ('Envelope 3.2in by 2.25', '4.56', 'A 100 pack of yellow envelopes for coins and jewelry', '40', '32');
    
INSERT INTO OrderInfo (CustomerID, OrderDate, PaymentMethod, OrderStatus)
Values
	('1', '2021-03-22', 'credit', 'processing'),
    ('2', '2021-03-21', 'check', 'paid'),
    ('3', '2021-03-20', 'wired', 'packaged'),
    ('4', '2021-03-19', 'debit', 'shipped'),
    ('5', '2021-03-18', 'cash', 'complete');

INSERT INTO OrderLine (OrderID, ItemID, Quantity)
Values
	('1', '1', '6'),
    ('2', '3', '10'),
    ('3', '4', '2'),
    ('4', '5', '4'),
    ('5', '1', '10');

INSERT INTO Department (DepartmentName)
Values
	('Sales'),
    ('Finance'),
    ('Packaging'),
    ('Shipping'),
    ('Manager');

INSERT INTO Employees (DepartmentID, FirstName, LastName)
Values
	('1', 'John', 'Doe'),
    ('2', 'Jane', 'Do'),
    ('3', 'James', 'Doh'),
    ('4', 'Jack', 'Dohe'),
    ('2', 'Jerry', 'Doeh');
    
    
Select * FROM Address;
Select * FROM Payment;
Select * FROM Customer;
Select * FROM Item;
Select * FROM OrderInfo;
Select * FROM OrderLine;
Select * FROM Department;
Select * FROM Employees;

/*FOOTER
1	1700 ABC St.		Omaha	Nebraska	United States of America	68102
2	1315 Via Marccello		Venice	Veneto	Italy	30124
3	1533 Cannon Way	Lot 100	Vancouver	British Columbia	Canada	V5Z
4	4326 Laoshu St.		Beijing	Haubei	China	100072
5	653 Pale Ave.	Building C	Miami	Florida	United States of Ameria	33149

1	031312986 0017834349	002382451948 03/22 286 1315 Via Marcello Venice Venito Italy 30124	
2			012257829812124 11/21 552 4326 Laoshu St. Beijing Haubei China 100072
3			
4			
5		0456787828218284123 6/23 480 1700 ABC St. Omaha Nebraska United States of America	

1	1	5	Barbra Park	bpark@mailcompany.com	+15555555555
2	5	3	Arrow Financials LLC	procurement@arrowfinancials.com	+15555555556
3	2	1	Cappuccino Emprimere	augustpiri@cappuccinoexp.com	+15555555557
4	4	2	Sun Xiao	sun.xiao@mailcompany.com	+15555555558
5	3	4	Crown Digital Electronics	purchasing@crowndigital.com	+15555555559

1	A4 Plain	1.99	A 200 pack  of plain A4 sized paper 	343	287
2	A4 Lined	1.99	A 200 pack of lined A4 sized paper	456	428
3	Legal Plain	2.99	A 200 pack of plain Legal sized paper	231	189
4	Postcard Plain	15.99	A 100 pack of plain post cards	58	43
5	Envelope 3.2in by 2.25	4.56	A 100 pack of yellow envelopes for coins and jewelry	40	32

1	1	2021-03-22	credit	processing
2	2	2021-03-21	check	paid
3	3	2021-03-20	wired	packaged
4	4	2021-03-19	debit	shipped
5	5	2021-03-18	cash	complete

1	1	6
2	3	10
3	4	2
4	5	4
5	1	10

1	Sales
2	Finance
3	Packaging
4	Shipping
5	Manager

1	1	John	Doe
2	2	Jane	Do
3	3	James	Doh
4	4	Jack	Dohe
5	2	Jerry	Doeh

*/