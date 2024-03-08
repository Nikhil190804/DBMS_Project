CREATE DATABASE IF NOT EXISTS NNV;
USE NNV;
-- ENTITY TABLES
CREATE TABLE IF NOT EXISTS Admin (
    adminID INT NOT NULL ,
    email_ID VARCHAR(255) NOT NULL,
    username VARCHAR(255) UNIQUE NOT NULL,
 	password VARCHAR(255) NOT NULL,
    PRIMARY KEY (adminID),
    CONSTRAINT CK_Password_Alphanumeric1 CHECK (password REGEXP '[0-9]' AND password REGEXP '[a-zA-Z]' AND password REGEXP '[@#!&]')
);

INSERT INTO Admin (adminID, email_ID, username, password)
VALUES
(1, 'admin1@gmail.com', 'admin1', 'SecureP@ssword1');


CREATE TABLE IF NOT EXISTS Customer (
    adminID INT NOT NULL,
    userID INT NOT NULL AUTO_INCREMENT,
	password VARCHAR(255) NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    middle_name VARCHAR(255),
    last_name VARCHAR(255),
	email_ID VARCHAR(255) NOT NULL,
	phoneID INT UNIQUE NOT NULL,
    date_of_birth DATE NOT NULL,
    age INT NOT NULL,
    house_number INT NOT NULL,
    street_name VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    pincode INT  NOT NULL,
    state VARCHAR(255) NOT NULL,
    CONSTRAINT CK_Password_Alphanumeric2 CHECK (password REGEXP '[0-9]' AND password REGEXP '[a-zA-Z]' AND password REGEXP '[@#!&]'),
    CHECK (age >= 13),
    PRIMARY KEY (userID),
    FOREIGN KEY (adminID) REFERENCES Admin(adminID)
);

-- Insert 10 valid values into Customer table
INSERT INTO Customer (adminID, userID, password, first_name, middle_name, last_name, email_ID, phoneID, date_of_birth, age, house_number, street_name, city, pincode, state)
VALUES
(1, 1, 'SecureP@ssword1', 'John', NULL, 'Doe', 'john.doe@example.com', 1, '1990-01-15', 32, 123, 'Main St', 'City1', 110001, 'State1'),
(1, 2, 'SecureP@ssword2', 'Alice', 'M', 'Smith', 'alice.smith@example.com', 2, '1985-05-25', 37, 456, 'Maple St', 'City2', 110002, 'State1'),
(1, 3, 'SecureP@ssword3', 'Bob', NULL, 'Johnson', 'bob.johnson@example.com', 3, '1995-08-20', 26, 789, 'Oak St', 'City3', 110003, 'State1'),
(1, 4, 'SecureP@ssword4', 'Nikhil', NULL, 'Last1', 'user1@example.com', 4, '1992-06-18', 29, 456, 'Maple St', 'City4', 110004, 'State1'),
(1, 5, 'SecureP@ssword5', 'vipul', NULL, 'Last2', 'user2@example.com', 5, '1988-09-12', 33, 789, 'Oak St', 'City5', 110005, 'State1'),
(1, 6, 'SecureP@ssword6', 'Nitin', NULL, 'Last3', 'user3@example.com', 6, '1990-03-18', 32, 123, 'Main St', 'City1', 110006, 'State2'),
(1, 7, 'SecureP@ssword7', 'Eve', NULL, 'Anderson', 'eve.anderson@example.com', 7, '1994-12-05', 27, 789, 'Oak St', 'City2', 110007, 'State2'),
(1, 8, 'SecureP@ssword8', 'Michael', NULL, 'Williams', 'michael.williams@example.com', 8, '1987-07-10', 34, 456, 'Maple St', 'City3', 110008, 'State2'),
(1, 9, 'SecureP@ssword9', 'Sophia', 'L', 'Taylor', 'sophia.taylor@example.com', 9, '1998-04-22', 23, 123, 'Main St', 'City4', 110009, 'State2'),
(1, 10, 'SecureP@ssword10', 'James', NULL, 'Brown', 'james.brown@example.com', 10, '1991-11-30', 30, 789, 'Oak St', 'City5', 110010, 'State2');



CREATE TABLE IF NOT EXISTS phone_number_customers (
 phone_number CHAR(15) NOT NULL,
 phoneID INT NOT NULL,
 PRIMARY KEY (phoneID,phone_number),
 FOREIGN KEY (phoneID) REFERENCES Customer(phoneID)  
);

-- Insert 20 phone numbers into phone_number table
INSERT INTO phone_number_customers (phone_number, phoneID)
VALUES
('9876543210', 1), ('8765432109', 1),
('8765432101', 2), ('7654321098', 2),
('7654321090', 3), ('6543210987', 3),
('6543210981', 4), ('5432109876', 4),
('5432109870', 5), ('4321098765', 5),
('4321098761', 6), ('3210987654', 6),
('3210987650', 7), ('2109876543', 7),
('2109876541', 8), ('1098765432', 8),
('1098765430', 9), ('0987654321', 9),
('0987654320', 10), ('9876543210', 10);



CREATE TABLE IF NOT EXISTS Coupans  (
    adminID INT NOT NULL,
    coupanID INT NOT NULL,
    expiry_date DATE NOT NULL,
    discount_percentage INT NOT NULL,
    description TEXT ,
    coupan_code VARCHAR(50) NOT NULL,
    CHECK (discount_percentage >= 10 AND discount_percentage <=70),
    PRIMARY KEY (coupanID),
    FOREIGN KEY (adminID) REFERENCES Admin(adminID)
);

-- Insert data into Coupans table
INSERT INTO Coupans (adminID, coupanID, expiry_date, discount_percentage, description, coupan_code)
VALUES
(1, 1, '2024-12-31', 15, 'Special discount for laptops', 'CPN123'),
(1, 2, '2024-11-30', 20, 'Discount on smartphones and accessories', 'CPN456'),
(1, 3, '2024-10-15', 25, 'Wireless headphones promotion', 'CPN789'),
(1, 4, '2024-09-30', 30, '4K Smart TV deal', 'CPN101'),
(1, 5, '2024-08-20', 35, 'Gaming console flash sale', 'CPN202');



CREATE TABLE IF NOT EXISTS Customer_uses_Coupans(
userID INT NOT NULL ,
coupanID INT NOT NULL,
PRIMARY KEY (userID,coupanID),
FOREIGN KEY (userID) REFERENCES Customer(userID),
FOREIGN KEY (coupanID) REFERENCES Coupans(coupanID)
);

-- Insert data into Customer_uses_Coupans table
INSERT INTO Customer_uses_Coupans (userID, coupanID)
VALUES
(1, 1),  
(2, 2),  
(3, 3),  
(4, 4),  
(5, 5);  



CREATE TABLE IF NOT EXISTS Product (
  adminID INT NOT NULL,
  productID INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  CHECK (price>=0 AND price<=100000),
  PRIMARY KEY (productID),
  FOREIGN KEY (adminID) REFERENCES Admin(adminID)
);

-- Insert 20 products into Product table
INSERT INTO Product (adminID, productID, name, description, price)
VALUES
(1, 1, 'Laptop', 'High-performance laptop with the latest specs', 1200.00),
(1, 2, 'Smartphone', 'Feature-rich smartphone with a powerful camera', 799.99),
(1, 3, 'Wireless Headphones', 'Noise-canceling wireless headphones for immersive audio', 129.99),
(1, 4, '4K Smart TV', 'Ultra HD smart TV with a large display', 899.99),
(1, 5, 'Gaming Console', 'Next-gen gaming console for an immersive gaming experience', 499.99),
(1, 6, 'Fitness Tracker', 'Advanced fitness tracker with heart rate monitoring', 79.99),
(1, 7, 'Coffee Maker', 'Smart coffee maker with programmable features', 49.99),
(1, 8, 'Bluetooth Speaker', 'Portable Bluetooth speaker with high-quality sound', 39.99),
(1, 9, 'Digital Camera', 'Professional-grade digital camera for photography enthusiasts', 899.99),
(1, 10, 'Smart Thermostat', 'Energy-efficient smart thermostat for home automation', 129.99),
(1, 11, 'Robot Vacuum', 'Intelligent robot vacuum for hands-free cleaning', 199.99),
(1, 12, 'Electric Toothbrush', 'Smart electric toothbrush for effective oral care', 59.99),
(1, 13, 'Outdoor Grill', 'Premium outdoor grill for barbecue enthusiasts', 299.99),
(1, 14, 'Home Security Camera', 'Wireless home security camera with motion detection', 129.99),
(1, 15, 'Digital Drawing Tablet', 'Graphic drawing tablet for digital artists', 149.99),
(1, 16, 'Smart Refrigerator', 'Refrigerator with smart features for modern kitchens', 1499.99),
(1, 17, 'Drone', 'High-quality drone with a built-in camera for aerial photography', 699.99),
(1, 18, 'Portable Projector', 'Compact portable projector for on-the-go entertainment', 79.99),
(1, 19, 'Electric Scooter', 'Eco-friendly electric scooter for urban commuting', 299.99),
(1, 20, 'Smartwatch', 'Feature-packed smartwatch with health tracking capabilities', 199.99);




CREATE TABLE product_images (
  imageID INT NOT NULL AUTO_INCREMENT,
  productID INT NOT NULL,
  image_url VARCHAR(255) NOT NULL,
  PRIMARY KEY (imageID),
  FOREIGN KEY (productID) REFERENCES Product(productID)
);

INSERT INTO product_images (imageID, productID, image_url)
VALUES
(1, 1, 'image1_product1.jpg'),
(2, 1, 'image2_product1.jpg'),
(3, 1, 'image3_product1.jpg'),
(4, 2, 'image1_product2.jpg'),
(5, 2, 'image2_product2.jpg'),
(6, 3, 'image1_product3.jpg'),
(7, 4, 'image1_product4.jpg'),
(8, 4, 'image2_product4.jpg'),
(9, 4, 'image3_product4.jpg'),
(10, 4, 'image4_product4.jpg'),
(11, 5, 'image1_product5.jpg'),
(12, 5, 'image2_product5.jpg'),
(13, 5, 'image3_product5.jpg'),
(14, 5, 'image4_product5.jpg'),
(15, 5, 'image5_product5.jpg'),
(16, 6, 'image1_product6.jpg'),
(17, 7, 'image1_product7.jpg'),
(18, 7, 'image2_product7.jpg'),
(19, 7, 'image3_product7.jpg'),
(20, 7, 'image4_product7.jpg'),
(21, 8, 'image1_product8.jpg'),
(22, 8, 'image2_product8.jpg'),
(23, 9, 'image1_product9.jpg'),
(24, 9, 'image2_product9.jpg'),
(25, 9, 'image3_product9.jpg'),
(26, 10, 'image1_product10.jpg'),
(27, 10, 'image2_product10.jpg'),
(28, 11, 'image1_product11.jpg'),
(29, 12, 'image1_product12.jpg'),
(30, 12, 'image2_product12.jpg'),
(31, 12, 'image3_product12.jpg'),
(32, 13, 'image1_product13.jpg'),
(33, 13, 'image2_product13.jpg'),
(34, 14, 'image1_product14.jpg'),
(35, 14, 'image2_product14.jpg'),
(36, 15, 'image1_product15.jpg'),
(37, 15, 'image2_product15.jpg'),
(38, 15, 'image3_product15.jpg'),
(39, 16, 'image1_product16.jpg'),
(40, 17, 'image1_product17.jpg'),
(41, 17, 'image2_product17.jpg'),
(42, 18, 'image1_product18.jpg'),
(43, 19, 'image1_product19.jpg'),
(44, 19, 'image2_product19.jpg'),
(45, 20, 'image1_product20.jpg'),
(46, 20, 'image2_product20.jpg'),
(47, 20, 'image3_product20.jpg');



CREATE TABLE IF NOT EXISTS Category(
    categoryID INT NOT NULL,
    adminID INT NOT NULL,
    category_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (categoryID),
    FOREIGN KEY (adminID) REFERENCES Admin(adminID)
);

-- Insert categories into Category table based on the provided products
INSERT INTO Category (categoryID, adminID, category_name)
VALUES
(1, 1, 'Laptops and Computers'),
(2, 1, 'Smartphones and Accessories'),
(3, 1, 'Audio and Headphones'),
(4, 1, 'Home Appliances'),
(5, 1, 'Gaming Consoles'),
(6, 1, 'Fitness and Wearables'),
(7, 1, 'Outdoor and Recreation'),
(8, 1, 'Digital Cameras and Photography'),
(9, 1, 'Home Security and Surveillance'),
(10, 1, 'Smart Devices and Gadgets');


CREATE TABLE IF NOT EXISTS Product_And_Category(
categoryID INT NOT NULL,
productID INT NOT NULL,
PRIMARY KEY (productID),
FOREIGN KEY (productID) REFERENCES Product(productID),
FOREIGN KEY (categoryID) REFERENCES Category(categoryID)
);

INSERT INTO Product_And_Category (categoryID, productID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(3, 8),
(4, 4),
(4, 7),
(4, 12),
(4, 16),
(5, 5),
(6, 6),
(7, 13),
(7, 17),
(7, 18),
(7, 19),
(8, 9),
(8, 14),
(10, 10),
(10, 11),
(10, 15),
(10, 20);


CREATE TABLE IF NOT EXISTS Delivery_Agent (
    adminID INT NOT NULL,
    uniqueID INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    middle_name VARCHAR(255),
    last_name VARCHAR(255),
    phoneID INT UNIQUE NOT NULL,
    PRIMARY KEY (uniqueID) ,
    FOREIGN KEY (adminID) REFERENCES Admin(adminID)
);

-- Insert data into Delivery_Agent table
INSERT INTO Delivery_Agent (adminID, first_name, middle_name, last_name, phoneID)
VALUES
(1, 'John', 'A', 'Doe', 1),
(1, 'Alice', 'B', 'Smith', 2),
(1, 'Bob', 'C', 'Johnson', 3),
(1, 'Eva', 'D', 'Williams', 4),
(1, 'Michael', 'E', 'Jones', 5),
(1, 'Sophia', 'F', 'Miller', 6),
(1, 'Daniel', 'G', 'Davis', 7),
(1, 'Olivia', 'H', 'Brown', 8),
(1, 'James', 'I', 'Wilson', 9),
(1, 'Ava', 'J', 'Moore', 10);



CREATE TABLE IF NOT EXISTS phone_number_deliveryAgents (
 phone_number CHAR(15) NOT NULL,
 phoneID INT NOT NULL,
 PRIMARY KEY (phoneID,phone_number),
 FOREIGN KEY (phoneID) REFERENCES Delivery_Agent(phoneID)  
);

-- Insert data into phone_number_deliveryAgents table
INSERT INTO phone_number_deliveryAgents (phone_number, phoneID)
VALUES
('1234567890', 1),
('9876543210', 1),
('2345678901', 2),
('8765432109', 2),
('3456789012', 2),
('4567890123', 3),
('7654321098', 3),
('5678901234', 4),
('6543210987', 4),
('6789012345', 4),
('7890123456', 5),
('8901234567', 6),
('9012345678', 7),
('5432109876', 7),
('0123456789', 8),
('2109876543', 9),
('3210987654', 10);



CREATE TABLE IF NOT EXISTS Transactions(
    transactionID INT NOT NULL UNIQUE,
    date_of_transaction DATE,
    amount INT NOT NULL,
    transactions_status VARCHAR(150) NOT NULL,
    payment_name VARCHAR(255) NOT NULL,
    CHECK(amount>=0),
    PRIMARY KEY (transactionID)
);

-- Insert data into Transactions table
INSERT INTO Transactions (transactionID, date_of_transaction, amount, transactions_status, payment_name)
VALUES
(1, '2024-03-01', 100, 'Completed', 'Credit Card'),
(2, '2024-03-02', 50, 'Pending', 'PayPal'),
(3, '2024-03-03', 75, 'Completed', 'Debit Card'),
(4, '2024-03-04', 120, 'Failed', 'Bank Transfer'),
(5, '2024-03-05', 90, 'Completed', 'Credit Card'),
(6, '2024-03-06', 60, 'Pending', 'PayPal'),
(7, '2024-03-07', 110, 'Completed', 'Debit Card'),
(8, '2024-03-08', 80, 'Failed', 'Bank Transfer'),
(9, '2024-03-09', 130, 'Completed', 'Credit Card'),
(10, '2024-03-10', 95, 'Pending', 'PayPal');

CREATE TABLE IF NOT EXISTS CustomersTransactions(
userID INT NOT NULL,
transactionID INT NOT NULL,
PRIMARY KEY (transactionID),
FOREIGN KEY (transactionID) REFERENCES Transactions(transactionID),
FOREIGN KEY (userID) REFERENCES Customer(userID) 
);

-- Insert data into CustomersTransactions table
INSERT INTO CustomersTransactions (userID, transactionID)
VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 6),
(5, 7),
(6, 8),
(7, 9),
(8, 10);



CREATE TABLE IF NOT EXISTS Review(
	reviewID INT NOT NULL, 
    userID INT NOT NULL,
    descriptionn TEXT,
    review_date DATE NOT NULL,
    review_rating INT NOT NULL ,
    CHECK (review_rating >= 0 AND review_rating <=10 ),
    PRIMARY KEY (reviewID),
    FOREIGN KEY (userID) REFERENCES Customer(userID)
);

-- Insert data into Review table for customers who made successful transactions
INSERT INTO Review (reviewID, userID, descriptionn, review_date, review_rating)
VALUES
(1, 1, 'Great product! Fast delivery.', '2024-03-01', 9),
(2, 2, 'Excellent service and quality.', '2024-03-02', 10),
(3, 3, 'Good experience overall.', '2024-03-03', 8),
(4, 4, 'Product met expectations.', '2024-03-04', 7),
(5, 5, 'Very satisfied with the purchase.', '2024-03-05', 9),
(6, 6, 'Quick and efficient service.', '2024-03-06', 10);



CREATE TABLE IF NOT EXISTS Product_Review(
reviewID INT NOT NULL, 
productID INT NOT NULL,
PRIMARY KEY (reviewID),
FOREIGN KEY (reviewID) REFERENCES Review(reviewID),
FOREIGN KEY (productID) REFERENCES Product(productID)
);

-- Insert data into Product_Review table based on the products customers ordered and reviewed
INSERT INTO Product_Review (reviewID, productID)
VALUES
(1, 1),  
(2, 2), 
(3, 3),  
(4, 4),  
(5, 5),  
(6, 6);  




CREATE TABLE IF NOT EXISTS Orders(
	orderID INT NOT NULL, 
    userID INT NOT NULL,
	house_number INT NOT NULL,
    street_name varchar(255) NOT NULL,
    city varchar(255) NOT NULL,
    pincode INT NOT NULL,
    state varchar(255) NOT NULL,
    total_amount INT NOT NULL,
    CHECK(total_amount>=0),
    PRIMARY KEY (orderID),
    FOREIGN KEY (userID) REFERENCES Customer(userID)
);

-- Insert data into Orders table for customers who placed orders
INSERT INTO Orders (orderID, userID, house_number, street_name, city, pincode, state, total_amount)
VALUES
(1, 1, 123, 'Main Street', 'City1', 123456, 'State1', 150),
(2, 2, 456, 'Broadway Avenue', 'City2', 654321, 'State2', 200),
(3, 3, 789, 'Oak Street', 'City3', 987654, 'State3', 120),
(4, 4, 101, 'Pine Avenue', 'City4', 345678, 'State1', 180),
(5, 5, 202, 'Cedar Lane', 'City5', 876543, 'State2', 250),
(6, 6, 303, 'Maple Road', 'City1', 234567, 'State3', 160);



CREATE TABLE IF NOT EXISTS Order_has_Products (
orderID INT NOT NULL,
productID INT NOT NULL,
product_quantity INT NOT NULL,
CHECK (product_quantity>0 AND product_quantity<=3),
PRIMARY KEY (orderID,productID),
FOREIGN KEY (productID) REFERENCES Product(productID),
FOREIGN KEY (orderID) REFERENCES Orders(orderID)
);

INSERT INTO Order_has_Products (orderID, productID, product_quantity)
VALUES
(1, 1, 2),
(1, 3, 1),
(2, 2, 1),
(3, 4, 3),
(4, 5, 2),
(5, 6, 1),
(5, 7, 1),
(6, 8, 3);



CREATE TABLE IF NOT EXISTS OrderShipment(
deliveryagentID INT NOT NULL,
orderID INT NOT NULL,
orderstatus VARCHAR(255) NOT NULL,
PRIMARY KEY(orderID),
FOREIGN KEY (deliveryagentID) REFERENCES Delivery_Agent (uniqueID),
FOREIGN KEY (orderID) REFERENCES Orders(orderID)
);

-- Insert data into OrderShipment table
INSERT INTO OrderShipment (deliveryagentID, orderID, orderstatus)
VALUES
(1, 1, 'Shipped'),
(2, 2, 'Processing'),
(3, 3, 'Delivered'),
(4, 4, 'In Transit'),
(5, 5, 'Shipped'),
(6, 6, 'Processing');




CREATE TABLE IF NOT EXISTS Coupan_And_Order(
orderID INT NOT NULL, 
coupanID INT NOT NULL,
PRIMARY KEY (orderID),
FOREIGN KEY (orderID) REFERENCES Orders(orderID),
FOREIGN KEY (coupanID) REFERENCES Coupans(coupanID)
);

INSERT INTO Coupan_And_Order (orderID, coupanID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);



CREATE TABLE IF NOT EXISTS Cart(
    cartID INT NOT NULL ,
    userID INT NOT NULL UNIQUE , 
    total_amount INT ,
    CHECK(total_amount>=0),
    PRIMARY KEY (cartID) ,
    FOREIGN KEY (userID) REFERENCES Customer(userID)
);
INSERT INTO Cart (cartID, userID, total_amount)
VALUES
(1, 1, 1200),
(2, 2, 799.99),
(3, 3, 259.98),
(4, 4, 899.99),
(5, 5, 1299.98),
(6, 6, 239.97),
(7, 7, 49.99),
(8, 8, 79.98),
(9, 9, 269.97),
(10, 10, 199.99);



CREATE TABLE IF NOT EXISTS Cart_has_Products(
cartID INT NOT NULL ,
productID INT NOT NULL,
product_quantity INT NOT NULL,
CHECK (product_quantity>0 AND product_quantity<=3),
PRIMARY KEY (cartID,productID) ,
FOREIGN KEY (productID) REFERENCES product(productID) ,
FOREIGN KEY (cartID) REFERENCES Cart(cartID)
);

INSERT INTO Cart_has_Products (cartID, productID, product_quantity)
VALUES
(1, 1, 2),
(1, 2, 1),
(2, 3, 3),
(3, 4, 1),
(4, 5, 2),
(5, 6, 3),
(6, 7, 1),
(7, 8, 2),
(8, 9, 3),
(9, 10, 1);


CREATE TABLE IF NOT EXISTS transaction_for_order(
orderID INT NOT NULL, 
transactionID INT NOT NULL,
PRIMARY KEY (transactionID),
FOREIGN KEY (orderID) REFERENCES Orders(orderID),
FOREIGN KEY (transactionID) REFERENCES Transactions(transactionID)
);
-- Insert data into transaction_for_order table
INSERT INTO transaction_for_order (orderID, transactionID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6);



-- INDEX CREATION

CREATE INDEX idx_product_price ON Product(price);
CREATE INDEX idx_product_review_rating ON Review(review_rating);
CREATE INDEX idx_customers_city ON Customer(city);
CREATE INDEX idx_customers_age ON Customer(age);
CREATE INDEX idx_order_amount ON Orders(total_amount);
CREATE INDEX idx_coupan_discount ON Coupans(discount_percentage);
CREATE INDEX idx_coupan_expiry_date ON Coupans(expiry_date);
CREATE INDEX idx_cart_amount ON Cart(total_amount);
CREATE INDEX idx_transaction_status ON Transactions(transactions_status);
CREATE INDEX idx_transaction_payment_name ON Transactions(payment_name);
CREATE INDEX idx_order_city ON Orders(city);




-- TO FIND THE PRODUCT WITH THEIR CATEGORY HAVING AVG RATING 9
SELECT
    P.productID,
    P.name AS product_name,
    PC.categoryID,
    C.category_name,
    AVG(R.review_rating) AS average_rating
FROM
    Product P
JOIN
    Product_Review PR ON P.productID = PR.productID
JOIN
    Review R ON PR.reviewID = R.reviewID
JOIN
    Product_And_Category PC ON P.productID = PC.productID
JOIN
    Category C ON PC.categoryID = C.categoryID
GROUP BY
    P.productID, P.name, PC.categoryID, C.category_name
HAVING
    AVG(R.review_rating) >= 9;



-- Query to display the entire record of each customer properly
SELECT
    userID AS customerID,
    CONCAT(first_name, ' ', COALESCE(middle_name, ''), ' ', last_name) AS name,
    CONCAT(house_number, ', ', street_name, ', ', city, ', ', state, ' - ', pincode) AS customer_address,
    age,
    MAX(ph.phone_number) AS primary_phone_number, -- Assuming you want to display just one phone number
    email_ID AS email
FROM
    Customer
JOIN
    phone_number_customers ph ON Customer.phoneID = ph.phoneID
GROUP BY
    customerID;


-- Query to show the shipped orders of delivery agents with their names
SELECT
    os.orderID,
    os.orderstatus,
    CONCAT(da.first_name, ' ', COALESCE(da.middle_name, ''), ' ', da.last_name) AS delivery_agent_name
FROM
    OrderShipment os
JOIN
    Delivery_Agent da ON os.deliveryagentID = da.uniqueID
WHERE
    os.orderstatus = 'Shipped';



-- Query to show the top 3 customers with the highest total transactions amounts
SELECT
    c.userID,
    CONCAT(c.first_name, ' ', COALESCE(c.middle_name, ''), ' ', c.last_name) AS customer_name,
    SUM(t.amount) AS total_transaction_amount
FROM
    Customer c
JOIN
    CustomersTransactions ct ON c.userID = ct.userID
JOIN
    Transactions t ON ct.transactionID = t.transactionID
GROUP BY
    c.userID
ORDER BY
    total_transaction_amount DESC
LIMIT
    3;


-- Query to print the transaction history of all customers
SELECT
    c.userID,
    CONCAT(c.first_name, ' ', COALESCE(c.middle_name, ''), ' ', c.last_name) AS customer_name,
    t.transactionID,
    t.date_of_transaction,
    t.amount,
    t.transactions_status,
    t.payment_name
FROM
    Customer c
JOIN
    CustomersTransactions ct ON c.userID = ct.userID
JOIN
    Transactions t ON ct.transactionID = t.transactionID
ORDER BY
    c.userID, t.date_of_transaction;


-- Query to update a customer's address with userID 1
UPDATE Customer
SET
    house_number = '372',
    street_name = 'Naya Ghr',
    city = 'Grand theft auto vice city',
    pincode = 110000,
    state = 'IDK'
WHERE
    userID = 1;

-- To Verify: SELECT * from customer where userID =1;



-- Query to delete a product from the customer's cart 
DELETE FROM Cart_has_Products
WHERE cartID = 1 AND productID = 2;
SELECT * from cart where userID=1;
-- Query to update the total amount in the customer's cart 
UPDATE Cart
SET total_amount = (
    SELECT SUM(Product.price * Cart_has_Products.product_quantity)
    FROM Cart_has_Products
    JOIN Product ON Cart_has_Products.productID = Product.productID
    WHERE Cart_has_Products.cartID = Cart.cartID
)
WHERE userID = 1;


-- Query to add a new phone number for a customer
INSERT INTO phone_number_customers (phoneID, phone_number)
VALUES (
    (SELECT phoneID FROM customer WHERE userID = 5),
    '1234567890'
);
-- TO Verfiy: SELECT * from phone_number_customers where phoneID=5;



-- Query to fetch customers who have not purchased any product
SELECT *
FROM customer
WHERE userID NOT IN (
    SELECT DISTINCT userID
    FROM customerstransactions
);



-- Query to list customers who have purchased all the products of Category: Gaming Consoles
SELECT O.userID
FROM Orders as O 
EXCEPT
SELECT NotAnswer.userID
FROM 
(SELECT userID , categoryProduct.productID
FROM Customer CROSS JOIN  
(SELECT productID 
FROM Product_And_Category PC , Category C 
WHERE PC.categoryID = C.categoryID AND c.category_name = 'Gaming Consoles') categoryProduct
EXCEPT
SELECT O.userID , OP.productID
FROM Orders as O JOIN Order_has_Products OP ON O.orderID = OP.orderID) AS NotAnswer;

