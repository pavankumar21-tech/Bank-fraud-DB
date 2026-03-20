# Bank-fraud-DB
fraud detection in banking transactions using MYSQL triggers
# Bank Fraud Detection using MySQL Triggers

2nd Year CSE Data Science Project  
Fraud Detection in Banking Transactions using DBMS (MySQL)

## Features
- Relational database with normalized tables (customers, accounts, transactions, fraud_alerts)
- Automatic fraud detection using MySQL **Triggers** (runs on every insert)
- Rules implemented:
  - High amount (> ₹50,000)
  - High velocity (5+ transactions in 10 minutes)
  - Unusual night time high-value (00:00–05:00, > ₹10,000)
  - Sudden amount spike (>5x 30-day average)
- Views for fraud alerts & customer-wise summary

## Technologies
- MySQL 8.0+
- Python (for sample data generation – optional, code not uploaded yet)

## How to Run
1. Create database: 'bankfraddb'or (your choice)
2. Run `schema.sql` to create tables
3. (Optional) Generate data using Python script
4. Run `Trigger.sql` to create fraud detection trigger
5. Run `views.sql` for reporting views
6. Test: Insert suspicious transaction & check `fraud_alerts` table

## Screenshots
![Database Tables](screenshots/show-tables.png)  
![Fraud Alerts Example](screenshots/fraud-alerts.png)  
![Views Output](screenshots/views.png)  

(Replace with your actual screenshot file names)
