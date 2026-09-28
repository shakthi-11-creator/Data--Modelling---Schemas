CREATE DATABASE snowflake_Schema;
USE snowflake_Schema;

CREATE TABLE dim_merchant_category (
    category_key INT PRIMARY KEY,
    category_name VARCHAR(40),
    risk_level INT
);

CREATE TABLE dim_merchant (
    merchant_key INT PRIMARY KEY,
    merchant_name VARCHAR(30),
    terminal_id INT,
    category_key INT,
    FOREIGN KEY (category_key)
        REFERENCES dim_merchant_category (category_key)
);

CREATE TABLE dim_state (
    state_key INT PRIMARY KEY,
    state_name VARCHAR(60),
    region VARCHAR(50)
);

CREATE TABLE dim_city (
    city_key INT PRIMARY KEY,
    city_name VARCHAR(80),
    state_key INT,
    FOREIGN KEY (state_key)
        REFERENCES dim_state (state_key)
);

CREATE TABLE dim_customer (
    customer_key INT PRIMARY KEY,
    customer_name VARCHAR(50),
    account_type VARCHAR(10),
    city_key INT,
    FOREIGN KEY (city_key)
        REFERENCES dim_city (city_key)
);

CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE,
    financial_quarter VARCHAR(30),
    is_holiday VARCHAR(5)
);

CREATE TABLE fact_cc_transactions (
    transaction_id INT PRIMARY KEY,
    customer_key INT,
    merchant_key INT,
    date_key INT,
    transaction_amount_inr FLOAT,
    cashback_earned FLOAT,
    FOREIGN KEY (customer_key)
        REFERENCES dim_customer (customer_key),
    FOREIGN KEY (merchant_key)
        REFERENCES dim_merchant (merchant_key),
    FOREIGN KEY (date_key)
        REFERENCES dim_date (date_key)
);