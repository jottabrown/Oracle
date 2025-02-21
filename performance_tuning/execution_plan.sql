-- execution_plan.sql
-- How to analyze execution plans

-- Oracle Database Scripts
-- Author: Jean Alves
-- Position: Systems Analyst | Software Engineer | Oracle Database Specialist

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR);
