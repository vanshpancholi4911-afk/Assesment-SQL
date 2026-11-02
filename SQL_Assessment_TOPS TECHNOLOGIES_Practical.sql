-- SQL for Data Analytics Assessment M4-A1
-- MySQL 8+. Examples for Sections B and C; Section A explanations are in the DOCX.
-- Review and run each task in order. Some tables are intentionally separate.

CREATE DATABASE IF NOT EXISTS food_delivery_assessment;
USE food_delivery_assessment;

-- SECTION B TASK 1
CREATE TABLE food_orders (
  order_id INT PRIMARY KEY,
  customer_name VARCHAR(100),
  restaurant_name VARCHAR(100),
  item_ordered VARCHAR(100),
  quantity INT,
  price_per_item DECIMAL(10,2),
  order_date DATE,
  city VARCHAR(50)
);
INSERT INTO food_orders VALUES
(1,'Aarav','Spice Hub','Paneer Wrap',2,180.00,'2026-10-01','Mumbai'),
(2,'Diya','Pizza Point','Large Pizza',1,650.00,'2026-10-02','Pune'),
(3,'Kabir','Curry House','Thali',2,320.00,'2026-10-03','Mumbai'),
(4,'Meera','Burger Town','Burger Meal',1,280.00,'2026-10-04','Ahmedabad'),
(5,'Ishaan','Pizza Point','Garlic Bread',2,160.00,'2026-10-05','Pune'),
(6,'Anaya','Spice Hub','Biryani',3,240.00,'2026-10-06','Mumbai'),
(7,'Reyansh','Noodle Box','Noodles',1,210.00,'2026-10-07','Surat'),
(8,'Sara','Curry House','Family Thali',1,850.00,'2026-10-08','Mumbai'),
(9,'Vivaan','Burger Town','Double Burger',2,390.00,'2026-10-09','Ahmedabad'),
(10,'Ira','Noodle Box','Combo Meal',1,520.00,'2026-10-10','Surat');

SELECT * FROM food_orders WHERE city='Mumbai' ORDER BY price_per_item DESC;
SELECT DISTINCT restaurant_name FROM food_orders ORDER BY restaurant_name;
SELECT order_id, customer_name, restaurant_name, item_ordered, quantity, price_per_item,
       quantity * price_per_item AS individual_order_value
FROM food_orders ORDER BY individual_order_value DESC LIMIT 5;

-- SECTION B TASK 2
CREATE TABLE delivery_orders (
  order_id INT PRIMARY KEY,
  restaurant_name VARCHAR(100),
  city VARCHAR(50),
  total_amount DECIMAL(10,2),
  order_status VARCHAR(30),
  order_date DATE
);
INSERT INTO delivery_orders VALUES
(101,'Spice Hub','Mumbai',1800,'Completed','2026-10-01'),
(102,'Spice Hub','Mumbai',2200,'Completed','2026-10-02'),
(103,'Spice Hub','Mumbai',2500,'Completed','2026-10-03'),
(104,'Pizza Point','Pune',4000,'Completed','2026-10-04'),
(105,'Pizza Point','Pune',3500,'Completed','2026-10-05'),
(106,'Pizza Point','Pune',2800,'Cancelled','2026-10-06'),
(107,'Curry House','Mumbai',1500,'Completed','2026-10-07'),
(108,'Curry House','Mumbai',1900,'Completed','2026-10-08'),
(109,'Burger Town','Ahmedabad',6000,'Completed','2026-10-09'),
(110,'Burger Town','Ahmedabad',5200,'Completed','2026-10-10'),
(111,'Noodle Box','Surat',900,'Completed','2026-10-11'),
(112,'Noodle Box','Surat',1200,'Completed','2026-10-12');

SELECT restaurant_name, SUM(total_amount) AS total_revenue, COUNT(*) AS total_orders,
       AVG(total_amount) AS average_order_value,
       CASE WHEN SUM(total_amount)>10000 THEN 'High Revenue'
            ELSE 'Moderate Revenue' END AS revenue_label
FROM delivery_orders
GROUP BY restaurant_name
HAVING SUM(total_amount)>5000
ORDER BY total_revenue DESC;

-- SECTION B TASK 3
CREATE TABLE customers (
  customer_id INT PRIMARY KEY, name VARCHAR(100), city VARCHAR(50), phone VARCHAR(20)
);
CREATE TABLE restaurants (
  restaurant_id INT PRIMARY KEY, name VARCHAR(100), cuisine_type VARCHAR(50), city VARCHAR(50)
);
CREATE TABLE orders (
  order_id INT PRIMARY KEY, customer_id INT, restaurant_id INT,
  amount DECIMAL(10,2), order_date DATE,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);
INSERT INTO customers VALUES
(1,'Aarav','Mumbai','9000000001'),(2,'Diya','Pune','9000000002'),
(3,'Kabir','Mumbai','9000000003'),(4,'Meera','Ahmedabad','9000000004'),
(5,'Ishaan','Surat','9000000005'),(6,'Anaya','Pune','9000000006');
INSERT INTO restaurants VALUES
(11,'Spice Hub','Indian','Mumbai'),(12,'Pizza Point','Italian','Pune'),
(13,'Curry House','Indian','Mumbai'),(14,'Burger Town','Fast Food','Ahmedabad'),
(15,'Noodle Box','Asian','Surat'),(16,'Green Bowl','Healthy','Pune');
INSERT INTO orders VALUES
(201,1,11,650,'2026-10-01'),(202,2,12,900,'2026-10-02'),
(203,3,13,450,'2026-10-03'),(204,4,14,520,'2026-10-04'),
(205,1,13,700,'2026-10-05'),(206,5,15,390,'2026-10-06');

SELECT o.order_id, c.name AS customer_name, r.name AS restaurant_name, o.amount, o.order_date
FROM orders o
INNER JOIN customers c ON c.customer_id=o.customer_id
INNER JOIN restaurants r ON r.restaurant_id=o.restaurant_id;

SELECT c.customer_id, c.name AS customer_name, c.city, o.order_id, o.amount, o.order_date,
       r.name AS restaurant_name
FROM customers c
LEFT JOIN orders o ON o.customer_id=c.customer_id
LEFT JOIN restaurants r ON r.restaurant_id=o.restaurant_id
ORDER BY c.customer_id, o.order_date DESC;

SELECT o.order_id, c.name AS customer_name, c.city AS customer_city,
       r.name AS restaurant_name, r.city AS restaurant_city, o.amount
FROM orders o
JOIN customers c ON c.customer_id=o.customer_id
JOIN restaurants r ON r.restaurant_id=o.restaurant_id
WHERE c.city=r.city;

-- SECTION B TASK 4
CREATE TABLE deliveries (
  delivery_id INT PRIMARY KEY, agent_name VARCHAR(100), restaurant_name VARCHAR(100),
  delivery_time_mins DECIMAL(6,2), order_date DATE
);
INSERT INTO deliveries VALUES
(1,'Ravi','Spice Hub',25,'2026-10-01'),(2,'Ravi','Curry House',30,'2026-10-02'),
(3,'Ravi','Spice Hub',28,'2026-10-03'),(4,'Neha','Pizza Point',20,'2026-10-01'),
(5,'Neha','Burger Town',24,'2026-10-02'),(6,'Neha','Pizza Point',22,'2026-10-03'),
(7,'Arjun','Noodle Box',35,'2026-10-01'),(8,'Arjun','Spice Hub',32,'2026-10-02'),
(9,'Arjun','Curry House',40,'2026-10-03'),(10,'Sara','Burger Town',27,'2026-10-01'),
(11,'Sara','Noodle Box',29,'2026-10-02'),(12,'Sara','Pizza Point',26,'2026-10-03');

WITH agent_stats AS (
  SELECT agent_name, AVG(delivery_time_mins) AS avg_delivery_time
  FROM deliveries GROUP BY agent_name
),
ranked_agents AS (
  SELECT agent_name, avg_delivery_time,
         RANK() OVER (ORDER BY avg_delivery_time ASC) AS speed_rank
  FROM agent_stats
)
SELECT agent_name, avg_delivery_time, speed_rank,
       (SELECT AVG(delivery_time_mins) FROM deliveries) AS platform_avg_time,
       CASE WHEN avg_delivery_time <= (SELECT AVG(delivery_time_mins) FROM deliveries)
            THEN 'On Track' ELSE 'Needs Improvement' END AS performance_status
FROM ranked_agents ORDER BY speed_rank;

-- SECTION C: capstone tables and inserts
CREATE TABLE cap_customers (
  customer_id INT PRIMARY KEY, customer_name VARCHAR(100) NOT NULL, city VARCHAR(50) NOT NULL
);
CREATE TABLE cap_restaurants (
  restaurant_id INT PRIMARY KEY, restaurant_name VARCHAR(100) NOT NULL, city VARCHAR(50) NOT NULL
);
CREATE TABLE delivery_agents (
  agent_id INT PRIMARY KEY, agent_name VARCHAR(100) NOT NULL, city VARCHAR(50) NOT NULL
);
CREATE TABLE cap_orders (
  order_id INT PRIMARY KEY, customer_id INT NOT NULL, restaurant_id INT NOT NULL, agent_id INT,
  order_date DATE NOT NULL, order_amount DECIMAL(10,2) NOT NULL, delivery_time_mins INT,
  FOREIGN KEY (customer_id) REFERENCES cap_customers(customer_id),
  FOREIGN KEY (restaurant_id) REFERENCES cap_restaurants(restaurant_id),
  FOREIGN KEY (agent_id) REFERENCES delivery_agents(agent_id)
);
INSERT INTO cap_customers VALUES
(1,'Aarav Shah','Mumbai'),(2,'Diya Patel','Pune'),(3,'Kabir Mehta','Surat'),
(4,'Meera Shah','Ahmedabad'),(5,'Ishaan Desai','Mumbai'),(6,'Anaya Joshi','Pune'),
(7,'Reyansh Shah','Surat'),(8,'Sara Patel','Ahmedabad'),(9,'Vivaan Mehta','Mumbai'),
(10,'Ira Desai','Pune');
INSERT INTO cap_restaurants VALUES
(11,'Spice Hub','Mumbai'),(12,'Pizza Point','Pune'),(13,'Curry House','Surat'),
(14,'Burger Town','Ahmedabad'),(15,'Noodle Box','Mumbai'),(16,'Green Bowl','Pune'),
(17,'Dosa Corner','Surat'),(18,'Tandoor House','Ahmedabad'),(19,'Wrap Works','Mumbai'),
(20,'Sweet Treats','Pune');
INSERT INTO delivery_agents VALUES
(31,'Ravi','Mumbai'),(32,'Neha','Pune'),(33,'Arjun','Surat'),(34,'Sara','Ahmedabad'),
(35,'Karan','Mumbai'),(36,'Pooja','Pune'),(37,'Dev','Surat'),(38,'Mira','Ahmedabad'),
(39,'Jay','Mumbai'),(40,'Riya','Pune');
INSERT INTO cap_orders VALUES
(1001,1,11,31,'2026-10-14',1200,25),(1002,2,12,32,'2026-10-14',1800,30),
(1003,3,13,33,'2026-10-15',900,35),(1004,4,14,34,'2026-10-15',2200,28),
(1005,5,15,35,'2026-10-16',1500,24),(1006,6,16,36,'2026-10-16',2600,27),
(1007,7,17,37,'2026-10-17',1300,32),(1008,8,18,38,'2026-10-17',3000,26),
(1009,9,19,39,'2026-10-18',2100,23),(1010,10,20,40,'2026-10-18',1700,29);

SELECT r.restaurant_id, r.restaurant_name, COUNT(o.order_id) AS total_orders,
       SUM(o.order_amount) AS total_revenue, AVG(o.order_amount) AS average_order_value
FROM cap_restaurants r JOIN cap_orders o ON o.restaurant_id=r.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name
HAVING COUNT(o.order_id)>3
ORDER BY total_revenue DESC;

SELECT c.customer_id, c.customer_name, COALESCE(SUM(o.order_amount),0) AS total_spend,
       CASE WHEN COALESCE(SUM(o.order_amount),0)>5000 THEN 'Platinum'
            WHEN COALESCE(SUM(o.order_amount),0)>=2000 THEN 'Gold'
            ELSE 'Standard' END AS customer_tier
FROM cap_customers c LEFT JOIN cap_orders o ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.customer_name ORDER BY total_spend DESC;

WITH restaurant_revenue AS (
  SELECT r.city, r.restaurant_id, r.restaurant_name, SUM(o.order_amount) AS total_revenue
  FROM cap_restaurants r JOIN cap_orders o ON o.restaurant_id=r.restaurant_id
  GROUP BY r.city, r.restaurant_id, r.restaurant_name
),
ranked_restaurants AS (
  SELECT city, restaurant_id, restaurant_name, total_revenue,
         DENSE_RANK() OVER (PARTITION BY city ORDER BY total_revenue DESC) AS revenue_rank
  FROM restaurant_revenue
)
SELECT city, restaurant_name, total_revenue, revenue_rank
FROM ranked_restaurants WHERE revenue_rank<=3 ORDER BY city, revenue_rank;

WITH customer_order_rank AS (
  SELECT c.customer_id, c.customer_name, o.order_id, o.order_date, o.order_amount,
         ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY o.order_date DESC, o.order_id DESC) AS rn
  FROM cap_customers c LEFT JOIN cap_orders o ON o.customer_id=c.customer_id
)
SELECT customer_id, customer_name, order_id, order_date, order_amount
FROM customer_order_rank WHERE rn=1 ORDER BY customer_id;

CREATE OR REPLACE VIEW vw_daily_order_summary AS
SELECT o.order_date, c.customer_name, r.restaurant_name, a.agent_name,
       o.order_amount, o.delivery_time_mins
FROM cap_orders o
JOIN cap_customers c ON c.customer_id=o.customer_id
JOIN cap_restaurants r ON r.restaurant_id=o.restaurant_id
LEFT JOIN delivery_agents a ON a.agent_id=o.agent_id;

SELECT * FROM vw_daily_order_summary
WHERE order_date >= CURRENT_DATE - INTERVAL 6 DAY
  AND order_date < CURRENT_DATE + INTERVAL 1 DAY
ORDER BY order_date DESC;

-- SECTION D: Use the query in the DOCX with your own Section D orders table.
-- It assumes orders(order_id, agent_id, order_status, delivery_time_mins, city)
