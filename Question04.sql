CREATE TABLE customers (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE orders(
	id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customers(id),
	product VARCHAR(50),
	quantity INT,
	price DECIMAL (10,2),
	order_date DATE
);

SELECT * FROM customers;
SELECT * FROM orders; 

INSERT INTO customers (name,city) VALUES
('An','Hà Nội'),
('Bình','HCM'),
('Cường','Đà Nẵng'),
('Dương','Hà Nội');

INSERT INTO orders (customer_id, product, quantity, price, order_date) VALUES
(1,'Laptop', 2,1500.00,'2025-10-01'),
(2,'Chuột', 5, 25.50,'2025-10-02'),
(3,'Bàn phím', 3,120.00,'2025-10-03'),
(1,'Laptop', 1,1500.00,'2025-10-05'),
(4,'Tủ lạnh', 1,800.00,'2025-10-06');

-- Thêm một đơn hàng 
INSERT INTO orders (customer_id, product, quantity, price, order_date) VALUES
(2,'Laptop', 1, 1500.00, '2025-10-10');

-- Cập nhật đơn hàng
UPDATE orders
SET quantity = 3
WHERE customer_id = (SELECT id FROM customers WHERE name = 'An') 
AND order_date = '2025-10-01'; 

-- Xóa đơn hàng 
DELETE FROM orders WHERE quantity = 0; 

-- Liệt kê các đơn hàng 
SELECT customers.name "Tên khách hàng", orders.product "Tên sản phẩm",
(orders.quantity * orders.price) "Tổng tiền" 
FROM customers 
INNER JOIN orders 
ON customers.id = orders.customer_id 
ORDER BY "Tổng tiền" DESC; 

-- Liệt kê khách hàng có giá của tất cả đơn hàng > 2000  
SELECT * FROM customers 
WHERE id IN (SELECT customer_id FROM orders GROUP BY customer_id HAVING SUM(quantity*price) > 2000); 

-- Liệt kê khách hàng ở Hà Nội và đã mua các sản phẩm có tên chứa Laptop
SELECT id "Mã khách hàng", name "Tên khách hàng" FROM customers 
WHERE city = 'Hà Nội'
AND id IN (SELECT DISTINCT customer_id FROM orders WHERE product LIKE '%Laptop%'); 


-- Hiển thị 3 khách hàng đầu tiên theo tổng tiền giảm dần ( tổng của tất cả các đơn hàng )
SELECT customers.id "Mã khách hàng", customers.name "Tên khách hàng", customers.city "Địa chỉ"
FROM customers
INNER JOIN (SELECT customer_id AS customer_id, SUM(quantity * price) AS sum FROM orders GROUP BY customer_id) AS total_price
ON customers.id = total_price.customer_id
ORDER BY total_price.sum DESC 
LIMIT 3; 

