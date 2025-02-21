# Oracle Database Scripts & Automation

## 📌 Overview
This repository contains a collection of **PL/SQL scripts**, **stored procedures**, **triggers**, and **database automation** solutions for **Oracle Database**. It is designed to assist database administrators (DBAs), developers, and engineers in managing and optimizing Oracle environments efficiently.

## 📂 Repository Structure

```
📁 Oracle/
│
├── 📁 scripts/                 # General SQL and PL/SQL scripts
│   ├── create_tables.sql       # Sample script for table creation
│   ├── insert_data.sql         # Example data insertion script
│   ├── indexes.sql             # Indexing best practices
│
├── 📁 procedures/              # Stored procedures for automation
│   ├── sp_backup_manager.sql   # Procedure for automated backups
│   ├── sp_user_audit.sql       # User audit tracking procedure
│
├── 📁 triggers/                # PL/SQL triggers for data integrity and automation
│   ├── trg_prevent_delete.sql  # Prevent unauthorized deletes
│   ├── trg_auto_timestamp.sql  # Auto-updates timestamps on changes
│
├── 📁 performance_tuning/      # SQL tuning & optimization techniques
│   ├── query_optimization.sql  # Performance tuning tips
│   ├── execution_plan.sql      # How to analyze execution plans
│
├── 📁 migration/               # Scripts for Oracle database migrations
│   ├── data_migration.sql      # Sample data migration script
│   ├── schema_migration.sql    # Schema conversion script
│
├── 📁 automation/              # Automations using PL/SQL & Shell scripts
│   ├── backup_cleanup.sh       # Automated backup cleanup script
│   ├── monitor_sessions.sql    # Active session monitoring script
│
└── README.md                   # Project documentation
```

## ⚡ Key Features

✅ **PL/SQL Stored Procedures & Functions** – Ready-to-use scripts for managing and automating database tasks.  
✅ **Triggers for Data Integrity** – Pre-defined triggers to enforce business rules and maintain consistency.  
✅ **Performance Tuning Scripts** – Optimized queries and indexing strategies to boost database performance.  
✅ **Backup & Recovery Automation** – Shell scripts and procedures for automating backups and disaster recovery.  
✅ **Migration & Deployment Scripts** – Pre-built scripts for seamless database migrations and deployments.  

## 🛠️ Installation & Usage

1️⃣ Clone the repository:
```bash
git clone https://github.com/jottabrown/Oracle.git
cd Oracle
```

2️⃣ Connect to your Oracle Database:
```sql
sqlplus username/password@your_database
```

3️⃣ Run the scripts:
```sql
@scripts/create_tables.sql
@procedures/sp_backup_manager.sql
```

## 🚀 Best Practices & Guidelines
- **Follow Naming Conventions**: Use meaningful and standard naming for tables, indexes, and constraints.
- **Use Transactions**: Always use `COMMIT` and `ROLLBACK` appropriately.
- **Optimize Queries**: Leverage indexing and execution plans to improve performance.
- **Automate Where Possible**: Use PL/SQL and shell scripts to automate repetitive tasks.

## 📖 Resources
- [Oracle PL/SQL Documentation](https://docs.oracle.com/en/database/oracle/Oracle/)
- [SQL Performance Tuning Guide](https://docs.oracle.com/en/database/oracle/Oracle/19/tgsql/index.html)
- [Backup & Recovery Guide](https://docs.oracle.com/en/database/oracle/Oracle/19/bradv/index.html)

## 👨‍💻 Author
**Jean Alves**  
🔹 **Specialist in Oracle Database** – Development & Optimization  
🔹 **Expert in PL/SQL, Triggers, Procedures, and Database Migrations**  
🔹 **Worked on major data migration projects (Oi Móvel → TIM, Vivo, Claro)**  
📧 Email: jeancleber.alves@hotmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/jeancleberalves)

## 📝 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
