CREATE DATABASE IndiaKart_E_Commerce_Database;
GO 


USE IndiaKart_E_Commerce_Database;
GO

CREATE TABLE suppliers (
    supplier_id       VARCHAR(10)    PRIMARY KEY,
    supplier_name     VARCHAR(100)   NOT NULL,
    contact_person    VARCHAR(80),
    email             VARCHAR(120),
    phone             VARCHAR(15)    NOT NULL,
    city              VARCHAR(50),
    state             VARCHAR(50),
    pincode           VARCHAR(10),
    category          VARCHAR(50),
    gstin             VARCHAR(20),
    payment_terms_days INT,
    rating            DECIMAL(3,1),
    created_date      DATE,
    is_active         TINYINT        DEFAULT 1
);
GO


CREATE TABLE products (
    product_id        VARCHAR(10)    PRIMARY KEY,
    product_name      VARCHAR(150)   NOT NULL,
    category          VARCHAR(50)    NOT NULL,
    subcategory       VARCHAR(80),
    brand             VARCHAR(80),
    sku               VARCHAR(30)    UNIQUE,
    mrp               DECIMAL(10,2)  NOT NULL,
    selling_price     DECIMAL(10,2)  NOT NULL,
    cost_price        DECIMAL(10,2),
    gst_rate          INT            DEFAULT 18,
    hsn_code          VARCHAR(10),
    weight_grams      INT,
    supplier_id       VARCHAR(10),
    rating            DECIMAL(3,1),
    review_count      INT            DEFAULT 0,
    is_active         TINYINT        DEFAULT 1,
    launch_date       DATE,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);
GO


CREATE TABLE inventory (
    inventory_id          VARCHAR(10)  PRIMARY KEY,
    product_id            VARCHAR(10)  NOT NULL,
    warehouse_location    VARCHAR(50),
    quantity_available    INT          DEFAULT 0,
    quantity_reserved     INT          DEFAULT 0,
    reorder_level         INT,
    reorder_quantity      INT,
    last_restocked_date   DATE,
    unit_cost             DECIMAL(10,2),
    total_inventory_value DECIMAL(12,2),
    status                VARCHAR(20),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
GO


CREATE TABLE customers (
    customer_id        VARCHAR(12)   PRIMARY KEY,
    first_name         VARCHAR(50)   NOT NULL,
    last_name          VARCHAR(50)   NOT NULL,
    email              VARCHAR(120),
    phone              VARCHAR(15),
    city               VARCHAR(50),
    state              VARCHAR(50),
    pincode            VARCHAR(10),
    gender             VARCHAR(10),
    age                INT,
    segment            VARCHAR(20),
    registration_date  DATE,
    last_login_date    DATE,
    total_orders       INT           DEFAULT 0,
    total_spent        DECIMAL(12,2) DEFAULT 0.00,
    is_verified        TINYINT       DEFAULT 0,
    is_active          TINYINT       DEFAULT 1
);
GO


CREATE TABLE orders (
    order_id           VARCHAR(12)   PRIMARY KEY,
    customer_id        VARCHAR(12)   NOT NULL,
    order_date         DATE          NOT NULL,
    order_time         TIME,
    status             VARCHAR(20)   NOT NULL,
    city               VARCHAR(50),
    state              VARCHAR(50),
    pincode            VARCHAR(10),
    total_amount       DECIMAL(12,2),
    gst_amount         DECIMAL(10,2),
    shipping_charge    DECIMAL(8,2)  DEFAULT 0,
    discount_amount    DECIMAL(10,2) DEFAULT 0,
    final_amount       DECIMAL(12,2) NOT NULL,
    payment_method     VARCHAR(30),
    shipping_partner   VARCHAR(50),
    tracking_id        VARCHAR(30),
    delivered_date     DATE,
    is_cod             TINYINT       DEFAULT 0,
    channel            VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
GO


CREATE TABLE order_items (
    item_id            VARCHAR(12)   PRIMARY KEY,
    order_id           VARCHAR(12)   NOT NULL,
    product_id         VARCHAR(10)   NOT NULL,
    product_name       VARCHAR(150),
    category           VARCHAR(50),
    quantity           INT           NOT NULL DEFAULT 1,
    unit_price         DECIMAL(10,2) NOT NULL,
    gst_rate           INT,
    gst_amount         DECIMAL(10,2),
    discount_amount    DECIMAL(10,2) DEFAULT 0,
    total_price        DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
GO


CREATE TABLE payments (
    payment_id         VARCHAR(12)   PRIMARY KEY,
    order_id           VARCHAR(12)   NOT NULL,
    customer_id        VARCHAR(12)   NOT NULL,
    payment_date       DATE          NOT NULL,
    payment_time       TIME,
    payment_method     VARCHAR(30),
    amount             DECIMAL(12,2) NOT NULL,
    status             VARCHAR(20),
    transaction_id     VARCHAR(30)   UNIQUE,
    bank_name          VARCHAR(60),
    gateway            VARCHAR(40),
    refund_amount      DECIMAL(10,2) DEFAULT 0,
    refund_date        DATE,
    FOREIGN KEY (order_id)    REFERENCES orders(order_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
GO


CREATE TABLE returns (
    return_id          VARCHAR(10)   PRIMARY KEY,
    order_id           VARCHAR(12)   NOT NULL,
    customer_id        VARCHAR(12)   NOT NULL,
    return_date        DATE          NOT NULL,
    reason             VARCHAR(100),
    return_amount      DECIMAL(12,2),
    refund_status      VARCHAR(20),
    refund_date        DATE,
    return_condition   VARCHAR(20),
    remarks            VARCHAR(MAX),
    FOREIGN KEY (order_id)    REFERENCES orders(order_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
GO