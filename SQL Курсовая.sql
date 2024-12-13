/* База данных магазина бытовой техники. В ней содержится информация о продаваемых товарах, 
их категориях, производителях, магазинах, поставках товаров, изменений цен на товары, 
покупателях, покупках.

- customers (покупатели)
- products (товары)
- purchases (покупки)
- purchase_item (элемент покупки)
- deliveries (поставки)
- price_change (изменения цены товаров)
- categories (типы товара)
- manufacturers (наименование производителя товара)
- stores (филиалы)
*/


DROP DATABASE IF EXISTS m_video;
CREATE DATABASE m_video;
USE m_video;


-- Создание таблицы categories (типы товара)

DROP TABLE IF EXISTS categories;
CREATE TABLE categories 
(
    category_id SERIAL PRIMARY KEY, 
    category_name VARCHAR(255) NOT NULL
    );

INSERT INTO `categories` VALUES 
	(1, 'Kitchen Appliances'),
	(2, 'Laptops and computers'),
	(3, 'Photo and video'),
	(4, 'Smartphones and gadgets'),
    (5, 'Home Appliances');
    
-- Создание таблицы manufacturers (наименование производителя товара)

DROP TABLE IF EXISTS manufacturers;
CREATE TABLE manufacturers
(
    manufacturer_id SERIAL PRIMARY KEY, 
    manufacturer_name VARCHAR(255) NOT NULL
);
INSERT INTO `manufacturers` VALUES 
	(1, 'Bosch'),
	(2, 'Haier'),
	(3, 'Asus'),
	(4, 'Samsung'),
    (5, 'Apple'),
    (6, 'Tefal'),
    (7, 'Xiaomi'),
    (8, 'Sony');

-- Создание таблицы products (товары)

DROP TABLE IF EXISTS products;
CREATE TABLE products
(
    product_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255)  NOT NULL,
    manufacturer_id BIGINT UNSIGNED,    
    category_id BIGINT UNSIGNED,
    FOREIGN KEY (category_id) REFERENCES categories (category_id),
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturers (manufacturer_id)
);
INSERT INTO `products` VALUES 
	(1, 'Dishwasher Bosch SMS43D08ME', 1, 1),
	(2, 'Fridge Haier C2F637CWMV', 2, 1),
	(3, 'Laptop ASUS TUF Gaming F15 FX506LHB-HN323', 3, 2),
	(4, 'Tablet Samsung Galaxy Tab A7 Lite SM-T220', 4, 4),
    (5, 'Smart watch Apple Watch SE MNT83', 5, 4),
    (6, 'Iron Tefal EXPRESS STEAM FV2836E0', 6, 5),
    (7, 'Hand vacuum cleaner Xiaomi Vacuum Cleaner G11 EU', 7, 5),
    (8, 'Camera Sony DSC-RX100M5A', 8, 3);


-- Создание таблицы price_change (изменения цены товаров)

DROP TABLE IF EXISTS price_change;
CREATE TABLE price_change
(
    product_id BIGINT UNSIGNED NOT NULL,
    date_price_change DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    new_price NUMERIC(9,2) NOT NULL,      
    CONSTRAINT PK_PRICE_CHANGE PRIMARY KEY (product_id, date_price_change),  
    FOREIGN KEY (product_id) REFERENCES products (product_id)   
);
INSERT INTO `price_change` VALUES 
	(1, '2022-12-29 23:20:55', 44999),
	(2, '2023-02-20', 50999),
    (6, '2023-02-22', 3999);

-- Создание таблицы stores (филиалы)

DROP TABLE IF EXISTS stores;
CREATE TABLE stores
(
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(255) NOT NULL
);
INSERT INTO `stores` VALUES 
	(1, 'Ul. Krasnaya Presnya, d. 23, korpus B, stroyeniye 1'),
	(2, 'Pr-t Mira, d. 91, k. 1'),
	(3, 'Slavyanskiy b-r, d. 13, str. 1'),
	(4, 'Ul. Obrucheva, 34/63');


-- Создание таблицы deliveries (поставки)

DROP TABLE IF EXISTS deliveries;
CREATE TABLE deliveries
(    
    product_id BIGINT UNSIGNED NOT NULL,
    store_id BIGINT UNSIGNED,
    delivery_date  DATETIME DEFAULT CURRENT_TIMESTAMP,
    product_count  INTEGER UNSIGNED NOT NULL,    
    FOREIGN KEY (product_id) REFERENCES products (product_id),
    FOREIGN KEY (store_id) REFERENCES stores (store_id)
);
INSERT INTO `deliveries` VALUES 
	(1, 2, '2022-12-25 12:20:55', 10),
	(3, 3, '2023-01-20 10:13:29', 5);


-- Создание таблицы customers (покупатели)

DROP TABLE IF EXISTS customers;
CREATE TABLE customers
(
    customer_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    customer_fname VARCHAR(255) NOT NULL,
    customer_lname VARCHAR(255) NOT NULL,
    e_mail VARCHAR(255) UNIQUE,
    phone BIGINT
);
INSERT INTO `customers` VALUES 
('1', 'Marina', 'Ivanova', 'mar.iv@example.com', '9339073755'),
('2', 'Valentina', 'Rogova', 'val.r@example.net', '9803404650'),
('3', 'Ivan', 'Ivanov', 'ivanivan@example.net', '9924275184'),
('4', 'Peter', 'Mihailov', 'petr.mich@example.com', '9619165091'),
('5', 'Konstantin', 'Petrov', 'const@example.org', '9231898080'),
('6', 'Ekaterina', 'Nilova', 'katenil@example.net', '9348426774'),
('7', 'Vladimir', 'Vikentiev', 'volodja@example.org', '9574058915'),
('8', 'Natalia', 'Krotova', 'nata@example.net', '9363178382'),
('9', 'Gennadiy', 'Korr', 'gennadij@example.net', '9743498718'),
('10', 'Denis', 'Krukov', 'dencru@example.com', '9229739697');


-- Создание таблицы purchases (покупки)

DROP TABLE IF EXISTS purchases;
CREATE TABLE purchases
(
    purchase_id SERIAL PRIMARY KEY,
    customer_id BIGINT UNSIGNED NOT NULL,
    store_id BIGINT UNSIGNED NOT NULL,    
    purchase_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
    FOREIGN KEY (store_id) REFERENCES stores (store_id)
);
INSERT INTO `purchases` VALUES 
	(1, 2, 2, '2022-10-02 12:00:00'),
	(2, 10, 1, '2022-10-05 11:11:24'),
    (3, 8, 3, '2022-11-10 16:04:05');


-- Создание таблицы purchase_item (элемент покупки)

DROP TABLE IF EXISTS purchase_items;
CREATE TABLE purchase_items
(
    purchase_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    product_count BIGINT UNSIGNED NOT NULL,
    product_price NUMERIC(9,2) NOT NULL,
    CONSTRAINT PK_PURCHASE_ITEMS PRIMARY KEY (purchase_id, product_id),  
    FOREIGN KEY (product_id) REFERENCES products (product_id),
    FOREIGN KEY (purchase_id) REFERENCES purchases (purchase_id)
);
INSERT INTO `purchase_items` VALUES 
	(1, 1, 1, 44999),
	(1, 6, 1, 3999),
    (2, 2, 1, 50999);





-- Выборка данных по производителю.
SELECT product_id, product_name, m.manufacturer_name
FROM products p
    JOIN manufacturers m ON p.manufacturer_id = m.manufacturer_id;
	
    
-- Представление, содержащее список товаров с актуальными ценами
CREATE OR REPLACE VIEW v_product_purchase_items_list
AS 
  (SELECT product_id, product_name
  FROM products) 
  UNION
  (SELECT  price_change.product_id, new_price
  FROM price_change 
  join products on price_change.product_id = products.product_id);
  
-- Представление, содержащее данные о покупках клиентов
CREATE OR REPLACE VIEW v_customers_purchase_items_list
AS     
SELECT 
	customer_fname, customer_lname, purchase_items.product_id, 
    purchase_items.product_count, purchase_items.product_price
  FROM customers
    JOIN purchases ON customers.customer_id = purchases.customer_id
    JOIN purchase_items ON purchases.purchase_id = purchase_items.purchase_id;
    
   
-- Создание процедуры по добавлению товара 
DROP PROCEDURE IF EXISTS `add_product`;
    
DELIMITER $$
CREATE PROCEDURE `add_product`(product_name varchar(100), 
manufacturer_id INT, category_id INT, product_id INT, store_id INT,
    product_count  INT, OUT tran_result varchar(200))
BEGIN
    DECLARE `_rollback` BOOL DEFAULT 0;
   	DECLARE code varchar(100);
   	DECLARE error_string varchar(100);
    

   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
   begin
    	SET `_rollback` = 1;
	GET stacked DIAGNOSTICS CONDITION 1
          code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
    	set tran_result := concat('Error occured. Code: ', code, '. Text: ', error_string);
    end;
		        
    START TRANSACTION;
		INSERT INTO products (product_name, manufacturer_id, category_id)
		  VALUES (product_name, manufacturer_id, category_id);
        INSERT INTO deliveries (product_id, store_id, product_count)
		  VALUES (product_id, store_id, product_count);
	
	    IF `_rollback` THEN
	       ROLLBACK;
	    ELSE
		set tran_result := 'ok';
	       COMMIT;
	    END IF;
END$$

DELIMITER ;



-- вызываем процедуру
call add_product('Washing machine Bosch WAJ20180ME', 1, 5, 9, 3, 5, @tran_result);

-- смотрим результат
select @tran_result;
select * from products;
select * from deliveries;