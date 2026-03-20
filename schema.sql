-- Create Database (if needed)
CREATE DATABASE IF NOT EXISTS bankfraudddb;

USE bankfraudddb;

-- Drop existing tables if needed
DROP TABLE IF EXISTS fraud_alerts;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS customers;

-- Create tables
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT CHECK (age >= 18),
    city VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    balance DECIMAL(15,2) DEFAULT 50000.00 CHECK (balance >= 0),
    account_type VARCHAR(20) DEFAULT 'savings',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT,
    amount DECIMAL(12,2) NOT NULL CHECK (amount > 0),
    transaction_type VARCHAR(20) NOT NULL,
    merchant VARCHAR(100),
    transaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(45) DEFAULT '127.0.0.1',
    status VARCHAR(20) DEFAULT 'SUCCESS',
    FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE CASCADE
);

CREATE TABLE fraud_alerts (
    alert_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id INT,
    reason TEXT NOT NULL,
    severity VARCHAR(20) DEFAULT 'HIGH',
    alert_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id) ON DELETE CASCADE
);