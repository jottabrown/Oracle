-- data_migration.sql
-- Sample data migration script

-- Oracle Database Scripts
-- Author: Jean Alves
-- Position: Systems Analyst | Software Engineer | Oracle Database Specialist

INSERT INTO new_table SELECT * FROM old_table WHERE migration_flag = 'Y';