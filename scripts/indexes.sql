-- indexes.sql
-- Indexing best practices

-- Oracle Database Scripts
-- Author: Jean Alves
-- Position: Systems Analyst | Software Engineer | Oracle Database Specialist

CREATE INDEX idx_customer_email ON customers(email);
CREATE INDEX idx_order_customer_id ON orders(customer_id);
