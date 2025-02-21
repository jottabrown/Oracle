-- query_optimization.sql
-- Performance tuning tips

-- Oracle Database Scripts
-- Author: Jean Alves
-- Position: Systems Analyst | Software Engineer | Oracle Database Specialist

EXPLAIN PLAN FOR SELECT * FROM orders WHERE total_amount > 100;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);