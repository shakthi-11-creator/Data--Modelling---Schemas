create database galaxy_schema;
use galaxy_schema;
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE,
    day_of_week VARCHAR(15),
    calendar_month VARCHAR(15),
    calendar_quarter VARCHAR(2),
    calendar_year INT,
    is_weekend BOOLEAN
);

CREATE TABLE dim_customer (
    customer_key INT PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    customer_name VARCHAR(100),
    customer_tier VARCHAR(20),
    city VARCHAR(50),
    state VARCHAR(50)
);

CREATE TABLE dim_product (
    product_key INT PRIMARY KEY,
    product_id VARCHAR(50) NOT NULL,
    product_name VARCHAR(150),
    product_category VARCHAR(50),
    unit_weight_kg DECIMAL(10,2),
    base_price DECIMAL(10,2)
);

CREATE TABLE dim_payment_method (
    payment_key INT PRIMARY KEY,
    payment_type VARCHAR(30),
    payment_provider VARCHAR(50),
    gateway_name VARCHAR(50)
);

CREATE TABLE dim_warehouse (
    warehouse_key INT PRIMARY KEY,
    warehouse_code VARCHAR(30),
    city VARCHAR(50),
    storage_capacity_sqft INT,
    is_refrigerated BOOLEAN
);

CREATE TABLE dim_carrier (
    carrier_key INT PRIMARY KEY,
    carrier_name VARCHAR(50),
    service_level VARCHAR(30)
);

CREATE TABLE fact_orders (
    order_item_id INT PRIMARY KEY,
    order_date_key INT,
    customer_key INT,
    product_key INT,
    payment_key INT,
    quantity_ordered INT,
    unit_price DECIMAL(12,2),
    discount_amount DECIMAL(12,2),
    tax_amount DECIMAL(12,2),
    total_order_value DECIMAL(12,2),
    FOREIGN KEY (order_date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (payment_key) REFERENCES dim_payment_method(payment_key)
);

CREATE TABLE fact_shipments (
    shipment_id INT PRIMARY KEY,
    dispatch_date_key INT,
    delivery_date_key INT,
    customer_key INT,
    product_key INT,
    warehouse_key INT,
    carrier_key INT,
    quantity_shipped INT,
    base_freight_cost DECIMAL(12,2),
    surcharge_cost DECIMAL(12,2),
    total_freight_cost DECIMAL(12,2),
    delivery_delay_hours INT,
    FOREIGN KEY (dispatch_date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (delivery_date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (warehouse_key) REFERENCES dim_warehouse(warehouse_key),
    FOREIGN KEY (carrier_key) REFERENCES dim_carrier(carrier_key)
);