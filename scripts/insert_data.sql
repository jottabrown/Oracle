-- insert_data.sql
-- Example data insertion script

-- Oracle Database Scripts
-- Author: Jean Alves
-- Position: Systems Analyst | Software Engineer | Oracle Database Specialist

INSERT INTO customers (name, email) VALUES ('John Doe', 'johndoe@example.com');
INSERT INTO customers (name, email) VALUES ('Jane Smith', 'janesmith@example.com');

INSERT INTO orders (customer_id, total_amount) VALUES (1, 250.75);
INSERT INTO orders (customer_id, total_amount) VALUES (2, 125.50);