CREATE DATABASE APU_EBookstore_TP062986; --To Create a Database
GO

USE APU_EBookstore_TP062986; -- In order To use the Database 
GO

CREATE TABLE Publisher --To create a Publisher Table to store information about Publishers
(
Publisher_ID INT PRIMARY KEY IDENTITY(1000,1), --Will automatically increment by one and start the first count with 1000 and assign into Publisher_ID which is the Primary key
First_Name NVARCHAR(50) NOT NULL, --Cannot be Null
Second_Name NVARCHAR(50) NOT NULL, 
Phone_Number NVARCHAR(20) NOT NULL CHECK(LEN(Phone_Number) > 8), --Will check if the length of the Phone_Number value is more than 8 characters
Email NVARCHAR(50) UNIQUE CHECK(LEN(Email) > 4) --Must be unique and Will check if the length of the Email value is more than 4 characters
);
GO

CREATE TABLE RENTAL(
RecID INT PRIMARY KEY,
RegistrationNum NVARCHAR(10) FOREIGN KEY REFERENCES CAR(RegistrationNum),
CustCode NVARCHAR(10) FOREIGN KEY REFERENCES CUSTOMER(CustCode),
MilesDriven INT,
DateHired DATE
);

SELECT COUNT(*) AS amount FROM Book
WHERE Book.Category_ID  BETWEEN 1 AND 3;

CREATE TABLE Category --Creating a Bridge table
( 
Category_ID TINYINT PRIMARY KEY,
Category_Name CHAR(30) NOT NULL --Cannot be Null
);
GO
 
CREATE TABLE Book --Creating a Book table to store infromation about books
(
ISBN NVARCHAR(20) PRIMARY KEY,
Price SMALLMONEY NOT NULL CHECK (Price >= 0), --Will check if price more or equal than 0
Title NVARCHAR(2000) NOT NULL, --Cannot be Null
Publisher_ID INT FOREIGN KEY REFERENCES Publisher(Publisher_ID)
ON DELETE SET NULL ON UPDATE CASCADE --Will SET NULL IF Publisher is deleted also Allow update 
CHECK (Publisher_ID >= 1000),
Category_ID TINYINT NOT NULL FOREIGN KEY REFERENCES Category(Category_ID)
ON DELETE NO ACTION ON UPDATE CASCADE,
Author NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE Warehouse_Address--Creating a Table to store information about the location of the warehouse
(
Address_ID NVARCHAR(50) PRIMARY KEY,
Country NVARCHAR(50) NOT NULL, --Cannot be Null
City NVARCHAR(100) NOT NULL,
Street NVARCHAR(400) NOT NULL,
ZIP_Code NVARCHAR(12) NOT NULL
);
GO

CREATE TABLE Warehouse--Creating a Table to store infromation about Warehouses
(
Warehouse_ID NVARCHAR(50) PRIMARY KEY,
Phone_Number NVARCHAR(20) NOT NULL, --Cannot be Null
Publisher_ID INT NOT NULL FOREIGN KEY REFERENCES Publisher(Publisher_ID)
ON DELETE CASCADE ON UPDATE CASCADE, --Will delete or update the Publisher_ID column in the Publisher table
Address_ID NVARCHAR(50) FOREIGN KEY REFERENCES Warehouse_Address(Address_ID)
ON DELETE SET NULL ON UPDATE CASCADE
);
GO


CREATE TABLE Supplies--Creating a Bridge table to store all supplies
(
Supply_ID INT PRIMARY KEY IDENTITY(1, 1),
Amount INT NOT NULL CHECK (Amount > 0), --Will check if Amount more than 0
Supply_Date DATE DEFAULT GETDATE(), --Will get the current date if there is no value was entered
Warehouse_ID NVARCHAR(50) NOT NULL FOREIGN KEY REFERENCES Warehouse(Warehouse_ID)
ON DELETE NO ACTION ON UPDATE NO ACTION, --Will not allow delete or update the Warehouse_ID column in the Warehouse table
ISBN NVARCHAR(20) NOT NULL FOREIGN KEY REFERENCES Book(ISBN)
ON DELETE CASCADE ON UPDATE CASCADE
);
GO

CREATE TABLE Order_Book--Creating a order table to store all orders of the manager
(
Order_ID INT PRIMARY KEY IDENTITY(1, 1), --Will automatically increment by one and start the first count with 1 and assign into Order_ID which is the Primary key
Amount_Of_Books INT NOT NULL CHECK (Amount_Of_Books > 0), --Will check if Amount of books more than 0
Order_Date DATE DEFAULT GETDATE(), --Will get the current date if there is no value was entered
Order_Status NVARCHAR(50) NOT NULL DEFAULT 'Pending', --Will assign 'Pending' string if there is no value was entered
ISBN NVARCHAR(20) NOT NULL FOREIGN KEY REFERENCES Book(ISBN)--Cannot be Null
ON DELETE CASCADE ON UPDATE CASCADE
);
GO

CREATE TABLE Address_Of_Member--Creating a Table to store addresses of the Members
(
Address_ID NVARCHAR(50) PRIMARY KEY,
Country NVARCHAR(50) NOT NULL, --Cannot be Null
City NVARCHAR(100) NOT NULL,
Street NVARCHAR(400) NOT NULL,
ZIP_Code NVARCHAR(12) NOT NULL
);
GO

CREATE TABLE Member--Creating a Table to store infromation about members
(
Username NVARCHAR(50) PRIMARY KEY CHECK(LEN(Username) > 4), --Will check if the length of the Username attribute is more than 4 characters
First_Name NVARCHAR(50) NOT NULL, --Cannot be Null
Second_Name NVARCHAR(50) NOT NULL,
Phone_Number NVARCHAR(20) NOT NULL CHECK(LEN(Phone_Number) > 8), --Will check if the length of the Phone_Number attribute is more than 8 characters
Email NVARCHAR(50) NOT NULL UNIQUE CHECK(LEN(Email) > 4), --Must be unique and Will check if the length of the Email attribute is more than 4 characters
Identification_Number NVARCHAR(30) UNIQUE REFERENCES Member(Identification_Number) ON DELETE NO ACTION/*Will not allow delete or update 
the Identification_Number column in the Member table*/
CHECK(LEN(Identification_Number) > 4),
Address_ID NVARCHAR(50) NOT NULL FOREIGN KEY REFERENCES Address_Of_Member(Address_ID) ON DELETE NO ACTION ON UPDATE CASCADE
);
GO

CREATE TABLE Login--Creating a Table to store passwords of members
(
Username NVARCHAR(50) NOT NULL UNIQUE FOREIGN KEY REFERENCES Member(Username)
ON DELETE CASCADE ON UPDATE CASCADE, -- Will allow update and delete a Username in Member table
Password NVARCHAR(50) NOT NULL CHECK ((CHARINDEX('@', Password) != 0 OR 
CHARINDEX('#', Password) != 0 OR CHARINDEX('$', Password) != 0 OR CHARINDEX('!', Password) != 0 OR CHARINDEX('%', Password) != 0
OR CHARINDEX('&', Password) != 0 OR CHARINDEX('*', Password) != 0) AND LEN(Password) > 7) 
--Will check if the password contains special characters like "@#$%!&*" and will check if the password length is more than 7 characters
);
GO

CREATE TABLE Rating--Creating a Lookup Table
(
Rating_Number TINYINT PRIMARY KEY,
Rating_Text NVARCHAR(30) NOT NULL --Cannot be null
);
GO

CREATE TABLE Feedback --Creating a Bridge table to store all feedbacks
(
Username NVARCHAR(50) FOREIGN KEY REFERENCES Member(Username)
ON DELETE SET NULL ON UPDATE CASCADE,--Will allow update Username and will set null if User was deleted in Member table
ISBN NVARCHAR(20) NOT NULL FOREIGN KEY REFERENCES Book(ISBN)
ON DELETE CASCADE ON UPDATE CASCADE,
Commentary VARCHAR(MAX), -- Varchar(MAX) - 8000 characters 
Rating_Number TINYINT NOT NULL FOREIGN KEY REFERENCES Rating(Rating_Number)
ON DELETE NO ACTION ON UPDATE NO ACTION,
);
GO

CREATE TABLE Book_State--Creating a Lookup Table that will show if a member buying an e-book or hardcopy 
(
Book_Option NVARCHAR(2) PRIMARY KEY,
Online_or_Physical_Book NVARCHAR(20)
);
GO

CREATE TABLE Shopping_Cart--Creating a Table to store all items inside members' shopping carts
(
Shopping_Cart_ID INT PRIMARY KEY IDENTITY(1, 1), --Will automatically increment by one and start the first count with 1 and assign into Shopping_Cart_ID
Count_Items INT NOT NULL CHECK (Count_Items > 0), --Will check if Count_Items more than 0
Username NVARCHAR(50) NOT NULL UNIQUE FOREIGN KEY REFERENCES Member(Username)
ON DELETE CASCADE ON UPDATE CASCADE,--Will allow update and delete
ISBN NVARCHAR(20) NOT NULL FOREIGN KEY REFERENCES Book(ISBN)
ON DELETE CASCADE ON UPDATE CASCADE,
Book_Option NVARCHAR(2) NOT NULL DEFAULT '1' FOREIGN KEY REFERENCES Book_State(Book_Option)
ON DELETE NO ACTION ON UPDATE CASCADE
);
GO

CREATE TABLE Payment_Way--Creating a Lookup Table
(
Payment_Method TINYINT PRIMARY KEY,
Payment_Option NVARCHAR(100) NOT NULL--Cannot be Null
);
GO

CREATE TABLE Delivery_Status--Creating a Lookup Table
(
Delivery_Number TINYINT PRIMARY KEY,
Delivery_Status_Text NVARCHAR(100) NOT NULL--Cannot be Null
);
GO

CREATE TABLE Delivery--Creating a table for storing the delivery statuses of members' orders
(
Delivery_ID INT PRIMARY KEY IDENTITY(1, 1),--Will automatically increment by one and start the first count with 1 and assign into Delivery_ID which is the Primary key
Delivery_Day DATE DEFAULT GETDATE(),--Will get the current date if there is no value was entered
Notes VARCHAR(MAX),
Delivery_Number TINYINT NOT NULL FOREIGN KEY REFERENCES Delivery_Status(Delivery_Number)
ON DELETE NO ACTION --Will not allow delete the Delivery_Number 
);
GO

CREATE TABLE Purchase--Creating a Bridge table
(
Purchase_ID INT PRIMARY KEY IDENTITY(10000, 1),
--Will automatically increment by one and start the first count with 10000 and assign into Purchase_ID which is the Primary key
Amount SMALLINT NOT NULL, --Cannot be Null
Payment_Method TINYINT NOT NULL FOREIGN KEY REFERENCES Payment_Way(Payment_Method)
ON DELETE NO ACTION,
Delivery_ID INT NOT NULL FOREIGN KEY REFERENCES Delivery(Delivery_ID)
ON DELETE NO ACTION,
Username NVARCHAR(50) NOT NULL FOREIGN KEY REFERENCES Member(Username)
ON DELETE CASCADE ON UPDATE CASCADE,--Will allow update and delete Username in Member table
ISBN NVARCHAR(20) NOT NULL FOREIGN KEY REFERENCES Book(ISBN)
ON DELETE CASCADE ON UPDATE CASCADE,
Book_Option NVARCHAR(2) NOT NULL DEFAULT '1' FOREIGN KEY REFERENCES Book_State(Book_Option) 
ON DELETE NO ACTION ON UPDATE CASCADE
);
GO

INSERT INTO Publisher VALUES
('Yoav', 'Richa', '269 772-8680', 'hakelen@omdiaco.com'),
('Sophia', 'Nisha', '508 766-3997', '10kogachu@kwontol.com'),
('Blaise', 'Kari', '768 659-8054', 'wannaeat@paiucil.com'),
('Sergej', 'Talha', '861 267-3782', 'screenbelow@gecici.ml'),
('Dayna', 'Jorg', '853 351-4802', 'telegal@oanghika.com'),
('Estrella', 'Reilly', '677 795-6491', 'mjqbk@gslask.net'),
('Ruthi', 'Odysseus', '234 736-4023', 'midget7@cashbackr.com'),
('Kyrsten', 'Jackalyn', '963 431-5123', 'angel17love@asifboot.com'),
('Amaranta', 'Gedaliah', '342 431-5123', 'jtnelson@abaov.com'),
('Iesha', 'Loviisa', '412 562-1324', 'blasco86@falixiao.com'),
('Gul', 'Drika', '975 436-9513', 'hopepuppy@ttlrlie.com'),
('Blagun', 'Defne', '867 877-2894', 'b2bb3df@typery.com'),
('Rikie', 'Baet', '341 563-3452', 'bej3wlz@typery.com'),
('Amanda', 'Kari', '345 123-4343', 'blo86@falixiao.com');
GO

INSERT INTO Category VALUES
(1, 'Literary Fiction'),
(2, 'Mystery'),
(3, 'Thriller'),
(4, 'Horror'),
(5, 'Historical'),
(6, 'Romance'),
(7, 'Weestern'),
(8, 'Bildungsroman'),
(9, 'Speculative Fiction'),
(10, 'Science Fiction'),
(11, 'Fantasy'),
(12, 'Dystopian'),
(13, 'Magical Realism'),
(14, 'Realist Literature'),
(15, 'Other');
GO

INSERT INTO Book VALUES
('952-1-42-231323-4', 23.10, 'Absalon, Absalon', 1001, 1, 'William Faulkner'),
('954-2-41-434123-3', 19.99, 'East of Eden', 1003, 4, 'John Steinbeck'),
('956-3-12-212131-1', 12.99, 'The Sun Also Rises', 1005, 3, 'Ernest Hemingway'),
('962-2-11-323234-2', 9.99, 'Vile Bodies', 1002, 4, 'Evelyn Waugh'),
('244-1-32-412312-6', 3.9, 'A Scanner Darkly', 1005, 2, 'Philip Dir'),
('955-1-02-231123-4', 9.99, 'Moab is my Washpot', 1004, 11, 'Stephen Fry'),
('452-1-23-123123-3', 33.8, 'Number the Stars', 1013, 5, 'Lois Lowry'),
('121-9-32-123345-2', 11.5, 'Noli Me Tangere', 1009, 13, 'Jose Rizal'),
('341-2-43-232412-9', 10.2, 'Brave New World', 1008, 8, 'Aldous Huxley'),
('812-7-32-143685-2', 31.6, 'Rosemary And Rue', 1007, 6, 'Seanan Mcguire'),
('281-5-96-860254-3', 30.1, 'Pale Fire', 1010, 14, 'Pale Fire'),
('032-1-34-856437-4', 5.2, 'Remembrance of Things Past', 1011, 15, 'Marcel Proust'),
('412-3-43-984534-3', 6.55, 'In Search of Lost Time', 1013, 12, 'Marcel Proust'),
('312-6-85-897906-5', 7.7, 'Ulysses', 1005, 9, 'James Joyce'),
('321-4-32-653357-8', 9.99, 'Don Quixote', 1013, 7, 'Miguel de Cervantes'),
('103-2-11-323452-3', 30.9, 'One Hundred Years of Solitudev', 1004, 10, 'Gabriel Marquez'),
('068-3-42-312354-4', 40, 'The Great Gatsby', 1012, 11, 'Scott Fitzgerald'),
('390-1-53-784389-8', 59.20, 'Moby Dick', 1011, 2, 'Herman Melville'),
('490-4-23-986048-3', 72, 'War and Peace', 1009, 3, 'Leo Tolstoy'),
('431-3-43-232134-5', 14, 'Hamlet', 1005, 4, 'William Shakespeare'),
('314-3-75-543785-9', 20, 'The Odyssey', 1001, 10, 'Homer'),
('300-1-30-430930-2', 11, 'Madame Bovary', 1002, 6, 'Gustave Flaubert');
GO

INSERT INTO Warehouse_Address VALUES
('W0001', 'Malaysia', 'Kajang', '12 Jln Bukit Mutiara 1 Taman Bukit Mutiara', '43000'),
('W0002', 'Malaysia', 'Kangar', 'Jalan Sena Indah 3, Taman Sena Indah', '01000'),
('W0003', 'Malaysia', 'Klang', 'B 159 Psn Raja Muda Musa Pelabuhan Pelabuhan', '42000'),
('W0004', 'Indonesia', 'Jawa Tengah', 'Jl Kadipaten Wetan KT III 325, Jawa Tengah', '55132'),
('W0005', 'Indonesia', 'Dki Jakarta', 'Jl Kb Jeruk Raya 66 RT 01/02, Dki Jakarta', '11530'),
('W0006', 'Indonesia', 'Dki Jakarta', ' Jl Hang Tuah Raya 19, Dki Jakarta', '12120'),
('W0007', 'Indonesia', 'Bandung', 'JL. Palasari 21, Bandung', '40263'),
('W0008', 'Singapore', 'Singapore', '1 Keong Saik Road #03-18 Aia Tg Pagar Agency Office', '089109'),
('W0009', 'Singapore', 'Singapore', '11 CHANG CHARN ROAD 04-01 SHRIRO HOUSE', '159640'),
('W0010', 'Singapore', 'Singapore', '7 Pasir Panjang Road Unit 8 Pasir Panjang Distripark', '118498'),
('W0011', 'Singapore', 'Singapore', '90 Jalan Lekar', '698952'),
('W0012', 'China', 'Guangzhou - Conghuashi', 'Xi Ning Zhong Lu Si Xiang 1hao Er Ti 901', '103234'),
('W0013', 'China', 'Guangzhou - Conghuashi', 'Xin Min Da Jie 1002hao Chang Chun Wan Bao She', '324342'),
('W0014', 'China', 'Nanjing - Lishuicounty', 'Yong Yang Zhen Zhen Zhu Nan Lu 111hao Li Shui Xian Wen Hua Guang Dian Ju 812shi', '324234');
GO

INSERT INTO Warehouse VALUES
('WH0001', '662 166-2366', 1000, 'W0001'),
('WH0002', '608 541-3847', 1001, 'W0002'),
('WH0003', '032 678-3078', 1002, 'W0003'),
('WH0004', '021 835-6367', 1003, 'W0004'),
('WH0005', '021 661-3726', 1004, 'W0005'),
('WH0006', '031 592-8873', 1005, 'W0006'),
('WH0007', '021 392-8328', 1006, 'W0007'),
('WH0008', '629 44-5669', 1007, 'W0008'),
('WH0009', '648 23-4216', 1008, 'W0009'),
('WH0010', '999 82-7699', 1009, 'W0010'),
('WH0011', '677 31-7133', 1010, 'W0011'),
('WH0012', '130 325-20821', 1011, 'W0012'),
('WH0013', '130 138-51208', 1012, 'W0013'),
('WH0014', '130 528-39613', 1013, 'W0014');
GO

INSERT INTO Supplies VALUES
(15, '2022-4-01', 'WH0002', '952-1-42-231323-4'),
(40, '2022-4-02', 'WH0004', '954-2-41-434123-3'),
(30, '2022-4-03', 'WH0006', '956-3-12-212131-1'),
(10, '2022-4-04', 'WH0003', '962-2-11-323234-2'),
(29, '2022-4-05', 'WH0006', '244-1-32-412312-6'),
(26, '2022-4-06', 'WH0005', '955-1-02-231123-4'),
(18, '2022-4-07', 'WH0014', '452-1-23-123123-3'),
(20, '2022-4-08', 'WH0010', '121-9-32-123345-2'),
(19, '2022-4-09', 'WH0009', '341-2-43-232412-9'),
(17, '2022-4-10', 'WH0008', '812-7-32-143685-2'),
(13, '2022-4-10', 'WH0011', '281-5-96-860254-3'),
(11, '2022-4-11', 'WH0012', '032-1-34-856437-4'),
(40, '2022-4-12', 'WH0014', '412-3-43-984534-3'),
(50, '2022-4-13', 'WH0006', '312-6-85-897906-5'),
(60, '2022-4-14', 'WH0014', '321-4-32-653357-8'),
(70, '2022-4-15', 'WH0005', '103-2-11-323452-3'),
(80, '2022-4-16', 'WH0013', '068-3-42-312354-4'),
(90, '2022-4-17', 'WH0012', '390-1-53-784389-8'),
(95, '2022-4-18', 'WH0010', '490-4-23-986048-3'),
(10, '2022-4-18', 'WH0006', '431-3-43-232134-5'),
(30, '2022-4-19', 'WH0002', '314-3-75-543785-9'),
(39, '2022-4-19', 'WH0003', '300-1-30-430930-2'),
(100, '2022-4-20', 'WH0012', '032-1-34-856437-4'),
(33, '2022-4-20', 'WH0014', '412-3-43-984534-3'),
(39, '2022-4-20', 'WH0006', '312-6-85-897906-5'),
(12, '2022-4-21', 'WH0013', '068-3-42-312354-4'),
(50, '2022-4-21', 'WH0012', '390-1-53-784389-8'),
(30, '2022-4-21', 'WH0010', '490-4-23-986048-3'),
(20, '2022-4-22', 'WH0006', '956-3-12-212131-1'),
(10, '2022-4-23', 'WH0003', '962-2-11-323234-2');
GO

INSERT INTO Order_Book VALUES
(15, '2022-3-1', 'Arrived', '952-1-42-231323-4'),
(40, '2022-3-02', 'Arrived', '954-2-41-434123-3'),
(30, '2022-3-03', 'Arrived', '956-3-12-212131-1'),
(10, '2022-3-04', 'Arrived', '962-2-11-323234-2'),
(29, '2022-3-05', 'Arrived', '244-1-32-412312-6'),
(26, '2022-3-06', 'Arrived', '955-1-02-231123-4'),
(18, '2022-3-07', 'Arrived', '452-1-23-123123-3'),
(20, '2022-3-08', 'Arrived', '121-9-32-123345-2'),
(19, '2022-3-09', 'Arrived', '341-2-43-232412-9'),
(17, '2022-3-10', 'Arrived', '812-7-32-143685-2'),
(13, '2022-3-10', 'Arrived', '281-5-96-860254-3'),
(11, '2022-3-11', 'Arrived', '032-1-34-856437-4'),
(40, '2022-3-12', 'Arrived', '412-3-43-984534-3'),
(50, '2022-3-13', 'Arrived', '312-6-85-897906-5'),
(60, '2022-3-14', 'Arrived', '321-4-32-653357-8'),
(70, '2022-3-15', 'Arrived', '103-2-11-323452-3'),
(80, '2022-3-16', 'Arrived', '068-3-42-312354-4'),
(90, '2022-3-17', 'Arrived', '390-1-53-784389-8'),
(95, '2022-3-18', 'Arrived', '490-4-23-986048-3'),
(10, '2022-3-18', 'Arrived', '431-3-43-232134-5'),
(30, '2022-3-19', 'Arrived', '314-3-75-543785-9'),
(39, '2022-3-19', 'Arrived', '300-1-30-430930-2'),
(100, '2022-3-20', 'Arrived', '032-1-34-856437-4'),
(33, '2022-3-20', 'Arrived', '412-3-43-984534-3'),
(39, '2022-3-20', 'Arrived', '312-6-85-897906-5'),
(12, '2022-3-21', 'Arrived', '068-3-42-312354-4'),
(50, '2022-3-21', 'Arrived', '390-1-53-784389-8'),
(30, '2022-3-21', 'Arrived', '490-4-23-986048-3'),
(20, '2022-3-22', 'Arrived', '956-3-12-212131-1'),
(10, '2022-3-23', 'Arrived', '962-2-11-323234-2'),
(15, '2022-4-1', 'Shipping', '952-1-42-231323-4'),
(40, '2022-4-02', 'Shipping', '954-2-41-434123-3'),
(30, '2022-4-03', 'Shipping', '956-3-12-212131-1'),
(10, '2022-4-04', 'Shipping', '962-2-11-323234-2'),
(15, '2022-4-1', 'Pending', '952-1-42-231323-4'),
(40, '2022-4-02', 'Pending', '954-2-41-434123-3'),
(30, '2022-4-03', 'Pending', '956-3-12-212131-1'),
(10, '2022-4-04', 'Pending', '962-2-11-323234-2');
GO

INSERT INTO Address_Of_Member VALUES
('MEMB0001', 'Malaysia', 'Klang', '378 Jalan Sutera Taman Maznah', '41000'),
('MEMB0002', 'Malaysia', 'Petaling Jaya', '1 D4 Jln 8/1E Seksyen 8 Petaling Jaya', '46050'),
('MEMB0003', 'Malaysia', 'Kuantan', '367, Kampung Cherating Lama', '26080'),
('MEMB0004', 'Malaysia', 'Kuala Lumpur', 'Jalan Bangsar Utama 2, Bangsar Utama', '59000'),
('MEMB0005', 'Malaysia', 'Kuala Lumpur', 'Jalan Bangsar Utama 1, Bangsar Utama', '59000'),
('MEMB0006', 'Malaysia', 'Butterworth', 'No. 2561, Kampung Baru', '13400'),
('MEMB0007', 'Malaysia', 'Klang', '378 Jalan Sutera Taman Maznah', '41000'),
('MEMB0008', 'Malaysia', 'Kuala Lumpur', '32 Jalan Kemujah', '59000'),
('MEMB0009', 'Malaysia', 'Klang', '379 Jalan Sutera Taman Maznah', '41000'),
('MEMB0010', 'Malaysia', 'Klang', '378 Jalan Sutera Taman Maznah', '41000'),
('MEMB0011', 'Malaysia', 'Klang', '108 Jalan Sutera Taman Maznah', '41000'),
('MEMB0012', 'Malaysia', 'Kuala Lumpur', '32 Jalan Ke3ujah', '59000');
GO

INSERT INTO Member VALUES
('Rikimaru', 'Samuel', 'Hope', '333 730-0160', 'yerva@txtee.site', '000114543523', 'MEMB0001'),
('Aftertgf', 'Louisa', 'Chambers', '300 030-0160', 'golubkoffvasia@neaeo.com', '011216432354', 'MEMB0002'),
('EndGames', 'Nannie', 'Morales', '123 754-0320', 'seregas54@ilrlb.com', '011101431234', 'MEMB0003'),
('foresSta', 'Devante', 'Ratcliffe', '932 730-1160', 'joesober@eetieg.com', '000223431234', 'MEMB0004'),
('ArslanCantrell7', 'Arslan', 'Cantrell', '321 543-2954', 'anatsunamun@neaeo.com', '020312435633', 'MEMB0005'),
('Saad89Clarkson', 'Saad', 'Clarkson', '058 439-6858', 'marcoanton@baanr.com', '001211324323', 'MEMB0006'),
('Katie0Mccormick', 'Katie', 'Mccormick', '430 234-2313', 'ttreeexe@mailcuk.com', '981130123432', 'MEMB0007'),
('Brielle1Hernandez0', 'Brielle', 'Hernandez', '460 121-3213', 'volik32@eetieg.com', '990912348695', 'MEMB0008'),
('Judith1Farring', 'Judith', 'Farrington', '462 463-1255', 'bkroman@hotmail.red', '970811932412', 'MEMB0009'),
('LatoyaByrne000', 'Latoya', 'Byrne', '694 294-6932', 'comedymakc@aiafhg.com', '960123123243', 'MEMB0010'),
('DevaKnow123', 'Deva', 'Fese', '604 342-6942', 'dznuts@snapboosting.com', '950201394123', 'MEMB0011'),
('DevaKn323', 'Da', 'Fse', '604 342-5942', 'dzoosting.com', '9502053394123', 'MEMB0012');
GO

INSERT INTO Login VALUES
('Rikimaru', 'fsdf!sdgdfhg'),
('Aftertgf', 'sdgfdhf@g'),
('EndGames', 'jhgk#jhkhj'),
('foresSta', 'jhgkjhjk$jh'),
('ArslanCantrell7', 'rwet%yeryrt'),
('Saad89Clarkson', 'qwrewt&ery'),
('Katie0Mccormick', '412dfsg#dg'),
('Brielle1Hernandez0', '5436dfg@dfhdf'),
('Judith1Farring', '43sdgd!fhyr54'),
('LatoyaByrne000', '43gre@546'),
('DevaKnow123', '123asdfs3#df');

INSERT INTO Rating VALUES
(1, 'Terrible'),
(2, 'Very Poor'),
(3, 'Poor'),
(4, 'Below Average'),
(5, 'Average'),
(6, 'Good'),
(7, 'Very Good'),
(8, 'Excellent'),
(9, 'Outstanding'),
(10, 'Masterpiece');
GO

INSERT INTO Payment_Way VALUES
(1, 'Cash on Delivery'),
(2, 'Maybank2u'),
(3, 'Online Banking'),
(4, 'Credit / Debit Card'),
(5, 'Google Pay');
GO

INSERT INTO Delivery_Status VALUES
(1, 'Pending'),
(2, 'Shipping'),
(3, 'Delivering'),
(4, 'Shipped Back'),
(5, 'Completed');
GO

INSERT INTO Delivery VALUES
('2022-5-1', 'Change For 50 RG', 5),
('2022-5-2', 'Change For 100 RG', 5),
('2022-5-3', 'Call me before delivering', 5),
('2022-5-3', NULL, 4),
('2022-5-4', 'As soon as possible', 5),
('2022-5-5', 'Change For 50 RG', 3),
('2022-5-6', NULL, 2),
('2022-5-7', NULL, 2),
('2022-5-8', NULL, 1),
('2022-5-8', NULL, 5),
('2022-5-8', NULL, 5),
('2022-5-8', NULL, 5),
('2022-5-9', NULL, 1);
GO

INSERT INTO Book_State VALUES
('1', 'Hardcopy'),
('2', 'E-books');
GO

INSERT INTO Purchase(Amount, Payment_Method, Delivery_ID, Username, ISBN, Book_Option) VALUES
(2, 2, 1, 'Rikimaru', '952-1-42-231323-4', '1'),
(2, 2, 1, 'Rikimaru', '032-1-34-856437-4', '1'),
(2, 2, 1, 'Rikimaru', '412-3-43-984534-3', '1'),
(1, 4, 2, 'Aftertgf', '341-2-43-232412-9', '1'),
(1, 3, 3, 'EndGames', '962-2-11-323234-2', '1'),
(1, 3, 3, 'EndGames', '956-3-12-212131-1', '1'),
(3, 4, 4, 'foresSta', '952-1-42-231323-4', '1'),
(4, 4, 5, 'ArslanCantrell7', '321-4-32-653357-8', '1'),
(4, 4, 5, 'ArslanCantrell7', '952-1-42-231323-4', '1'),
(8, 5, 6, 'Saad89Clarkson', '121-9-32-123345-2', '1'),
(5, 3, 7, 'Katie0Mccormick', '390-1-53-784389-8', '1'),
(1, 2, 8, 'Brielle1Hernandez0', '312-6-85-897906-5', '1'),
(1, 1, 9, 'Judith1Farring', '390-1-53-784389-8', '1'),
(1, 3, 10, 'LatoyaByrne000', '412-3-43-984534-3', 2),
(1, 3, 11, 'DevaKnow123', '103-2-11-323452-3', 2),
(1, 4, 12, 'LatoyaByrne000', '812-7-32-143685-2', 2),
(1, 4, 13, 'LatoyaByrne000', '490-4-23-986048-3', 2);
GO

INSERT INTO Feedback VALUES
('Rikimaru', '952-1-42-231323-4', 'Amazing book', 9),
('Rikimaru', '032-1-34-856437-4', 'Interesting book', 7),
('Aftertgf', '341-2-43-232412-9', 'Not bad', 6),
('EndGames', '962-2-11-323234-2', 'I do not like this book at all', 2),
('EndGames', '956-3-12-212131-1', 'Really like content of the book', 8),
('ArslanCantrell7', '321-4-32-653357-8', NULL, 5),
('ArslanCantrell7', '952-1-42-231323-4', NULL, 5);
GO

SELECT Feedback.ISBN, Title AS Name, AVG(Feedback.Rating_Number) AS Rating, Rating.Rating_Text 
FROM Feedback
LEFT JOIN Book 
ON Feedback.ISBN = Book.ISBN
LEFT JOIN Rating
ON Feedback.Rating_Number = Rating.Rating_Number
GROUP BY Book.Title, Feedback.ISBN, Rating.Rating_Text
HAVING AVG(Feedback.Rating_Number) >= (SELECT AVG(Sum_Of_Rating)
FROM (SELECT Feedback.ISBN, SUM(Feedback.Rating_Number) AS Sum_Of_Rating
FROM Feedback
GROUP BY Feedback.ISBN) AS Avg_Rating)
ORDER BY Rating DESC;

SELECT Member.Identification_Number, Member.First_Name, Member.Second_Name, COUNT(Feedback.ISBN) AS Total_Number_Of_feedback 
FROM Member
RIGHT JOIN Feedback
ON Member.Username = Feedback.Username
GROUP BY Member.Identification_Number, Member.First_Name, Member.Second_Name
ORDER BY COUNT(Feedback.ISBN) DESC;

SELECT Publisher.Publisher_ID, Publisher.First_Name, Publisher.Second_Name, COUNT(Book.Publisher_ID) AS Total_Number_Of_Book_Published
FROM Publisher
RIGHT JOIN Book
ON Book.Publisher_ID = Publisher.Publisher_ID
GROUP BY Publisher.Publisher_ID, Publisher.First_Name, Publisher.Second_Name
ORDER BY Total_Number_Of_Book_Published DESC;

SELECT Book.Publisher_ID, Publisher.First_Name, Publisher.Second_Name, SUM(Order_Book.Amount_Of_Books) AS Total_Amount_Of_Books,
COUNT(Order_Book.Amount_Of_Books) AS Total_Number_Of_Orders
FROM Order_Book
LEFT JOIN Book
ON Book.ISBN = Order_Book.ISBN
LEFT JOIN Publisher
ON Book.Publisher_ID = Publisher.Publisher_ID
GROUP BY Book.Publisher_ID, Publisher.First_Name, Publisher.Second_Name
ORDER BY Total_Amount_Of_Books DESC;

SELECT Book.Title, Book.ISBN, (SELECT SUM(Supplies.Amount) FROM Supplies
WHERE Supplies.ISBN = Book.ISBN) - (SELECT SUM(Purchase.Amount) FROM Purchase
WHERE Purchase.ISBN = Book.ISBN AND Purchase.Book_Option = '1') AS Amount FROM Book
INNER JOIN Supplies
ON Book.ISBN = Supplies.ISBN
GROUP BY Book.Title, Book.ISBN
HAVING (SELECT SUM(Supplies.Amount) FROM Supplies
WHERE Supplies.ISBN = Book.ISBN) - (SELECT SUM(Purchase.Amount) FROM Purchase
WHERE Purchase.ISBN = Book.ISBN AND Purchase.Book_Option = '1') > (SELECT (SUM(Supplies.Amount) - (SELECT SUM(Purchase.Amount) FROM Purchase)) 
/ (SELECT DISTINCT COUNT(Supplies.ISBN) FROM Supplies) FROM Supplies)
ORDER BY Amount DESC

SELECT Book.Title, SUM(Purchase.Amount) AS The_Best_Sales
FROM Purchase
LEFT JOIN Book
ON Book.ISBN = Purchase.ISBN
GROUP BY Book.Title
HAVING SUM(Purchase.Amount+0.00) > (SELECT AVG(Sum_Of_Order+0.00)
FROM (SELECT Purchase.ISBN, SUM(Purchase.Amount) AS Sum_Of_Order
FROM Purchase
GROUP BY Purchase.ISBN) AS Exmp)
ORDER BY The_Best_Sales DESC;

SELECT Member.Username, Member.First_Name, Member.Second_Name, SUM(Book.Price * Purchase.Amount) AS Spending_RG FROM Book 
INNER JOIN Purchase ON Book.ISBN = Purchase.ISBN
INNER JOIN Member ON Member.Username = Purchase.Username
GROUP BY Member.Username, Member.First_Name, Member.Second_Name
ORDER BY Spending_RG DESC;

SELECT Member.Username, Member.First_Name, Member.Second_Name FROM Member
WHERE Member.Username NOT IN (SELECT Purchase.Username FROM Purchase);

SELECT Member.Identification_Number, Address_Of_Member.Country, Address_Of_Member.City, Address_Of_Member.Street, Address_Of_Member.ZIP_Code,
Member.Phone_Number AS Contact_Number, Book.ISBN, Book.Title, Purchase.Amount AS Quantity, Delivery.Delivery_Day AS Date_Of_Delivery, 
Delivery_Status.Delivery_Status_Text AS Status_Of_Delivery FROM Delivery
RIGHT JOIN Delivery_Status
ON Delivery_Status.Delivery_Number = Delivery.Delivery_Number
RIGHT JOIN Purchase
ON Purchase.Delivery_ID = Delivery.Delivery_ID
RIGHT JOIN Book
ON Book.ISBN = Purchase.ISBN
RIGHT JOIN Member
ON Member.Username = Purchase.Username
Right JOIN Address_Of_Member
ON Address_Of_Member.Address_ID = Member.Address_ID
WHERE Delivery_Status.Delivery_Number != 5;

SELECT Member.Username, Member.First_Name, Member.Second_Name, COUNT(Purchase.Username) AS Number_Of_Orders FROM Member
LEFT JOIN Purchase
ON Purchase.Username = Member.Username
GROUP BY Member.Username, Member.First_Name, Member.Second_Name
HAVING COUNT(Purchase.Username) > 2
ORDER BY Number_Of_Orders DESC; 

