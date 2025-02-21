-- monitor_sessions.sql
-- Active session monitoring script

-- Oracle Database Scripts
-- Author: Jean Alves
-- Position: Systems Analyst | Software Engineer | Oracle Database Specialist

SELECT sid, serial#, username, status FROM v$session WHERE username IS NOT NULL;