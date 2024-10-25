--------------------------------------------------------------------------------
----------------------- T A B L A S --------------------------------------------
--------------------------------------------------------------------------------
----------<> MAESTROS
-- 01 Tabla: person (persona)
CREATE TABLE person (
    id integer GENERATED BY DEFAULT ON NULL AS IDENTITY,
    rol_person char(1),
    type_document char(3),
    number_document varchar2(20),
    names varchar2(60),
    last_name varchar2(90),
    cell_phone char(9),
    email varchar2(80),
    birthdate date,
    salary number(8,2),
    seller_rol varchar2(20),
    seller_user varchar2(100),
    seller_password varchar2(130),
    active char(1) DEFAULT 'A',
    CONSTRAINT person_pk PRIMARY KEY (id),
    CONSTRAINT type_document_ck CHECK (type_document IN ('DNI', 'CNE')),
    CONSTRAINT number_document_uk UNIQUE (number_document),
    CONSTRAINT email_ck CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$'))
);

-- 02 Tabla: supplier (proveedor)
CREATE TABLE supplier (
    id integer GENERATED BY DEFAULT ON NULL AS IDENTITY,
    ruc char(11),
    name_company varchar2(90),
    type_document char(3),
    number_document varchar2(20),
    names varchar2(60),
    last_name varchar2(80),
    email varchar2(90),
    cell_phone char(9),
    active char(1) DEFAULT 'A',
    CONSTRAINT supplier_pk PRIMARY KEY (id),
    CONSTRAINT type_document_supplier_ck CHECK (type_document IN ('DNI', 'CNE')),
    CONSTRAINT number_document_supplier_uk UNIQUE (number_document),
    CONSTRAINT email_supplier_ck CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$'))
);

-- 03 Tabla: category_product (categoría producto)
CREATE TABLE category_product (
    id integer GENERATED BY DEFAULT ON NULL AS IDENTITY,
    name varchar2(60),
    description varchar2(90),
    active char(1) DEFAULT 'A',
    CONSTRAINT category_product_pk PRIMARY KEY (id)
);

-- 04 Tabla: product (producto)
CREATE TABLE product (
    id integer GENERATED BY DEFAULT ON NULL AS IDENTITY,
    code char(4) UNIQUE,
    name varchar2(60),
    description varchar2(200),
    category_product_id integer,
    price_unit number(8,2),
    unit_sale varchar2(10),
    date_expiry date,
    stock number(8,2),
    active char(1) DEFAULT 'A',
    CONSTRAINT product_pk PRIMARY KEY (id),
    CONSTRAINT unit_sale_options CHECK (unit_sale IN ('Unidad', 'Kilo'))
);


-- 05 Tabla: payment_method (método de pago)
CREATE TABLE payment_method (
    id integer GENERATED BY DEFAULT ON NULL AS IDENTITY,
    name varchar2(90),
    description varchar2(100),
    active char(1) DEFAULT 'A',
    CONSTRAINT payment_method_pk PRIMARY KEY (id)
);

----------<> TRANSACCIONAL

-- 06 Tabla: purchase (compra)
CREATE TABLE purchase (
    id integer GENERATED BY DEFAULT ON NULL AS IDENTITY,
    supplier_id integer,
    seller_id integer,
    payment_method_id integer,
    total_purchase number(8,2),
    date_time DATE DEFAULT SYSDATE,
    active char(1) DEFAULT 'A',
    CONSTRAINT purchase_pk PRIMARY KEY (id)
);

-- 07 Tabla: purchase_detail (detalle de compra)
CREATE TABLE purchase_detail (
    id integer GENERATED BY DEFAULT ON NULL AS IDENTITY,
    purchase_id integer,
    product_id integer,
    price_unit number(8,2),
    amount number(8,2),
    subtotal_purchase number(8,2),
    CONSTRAINT purchase_detail_pk PRIMARY KEY (id)
);

-- 08 Tabla: sale (venta)
CREATE TABLE sale (
    id integer GENERATED BY DEFAULT ON NULL AS IDENTITY,
    seller_id integer,
    client_id integer,
    payment_method_id integer,
    total_sale number(8,2),
    date_time DATE DEFAULT SYSDATE,
    active char(1) DEFAULT 'A',
    CONSTRAINT sale_pk PRIMARY KEY (id)
);

-- 09 Tabla: sale_detail (detalle de venta)
CREATE TABLE sale_detail (
    id integer GENERATED BY DEFAULT ON NULL AS IDENTITY,
    sale_id integer,
    product_id integer,
    amount number(8,2),
    subtotal_sale number(8,2),
    CONSTRAINT sale_detail_pk PRIMARY KEY (id)
);


CREATE TABLE reservation (
    id integer GENERATED BY DEFAULT ON NULL AS IDENTITY,          -- Unique ID for the reservation
    seller_id integer,                                            -- Seller's ID
    client_id integer,                                            -- Client's ID making the reservation
    payment_method_id integer,                                    -- Payment method ID used
    total_reservation number(8,2),                                -- Total amount of the reservation
    reservation_date TIMESTAMP,                                  -- Reservation date and time
    active char(1) DEFAULT 'A',                                   -- Status of the reservation (Active/Inactive)
    CONSTRAINT reservation_pk PRIMARY KEY (id)                    -- Primary key
);


CREATE TABLE reservation_detail (
    id integer GENERATED BY DEFAULT ON NULL AS IDENTITY,             -- Unique ID for the reservation detail
    reservation_id integer,                                          -- Associated reservation ID
    product_id integer,                                              -- Reserved product ID
    amount number(8,2),                                            -- Quantity of the reserved product
    subtotal_reservation number(8,2),                                -- Subtotal (quantity * product price)
    CONSTRAINT reservation_detail_pk PRIMARY KEY (id)
);


--------------------------------------------------------------------------------
---------------------------- R E L A C I O N E S -------------------------------
--------------------------------------------------------------------------------

-- 1. Una categoría de producto puede estar en uno o varios productos
ALTER TABLE product ADD CONSTRAINT product_category_product
    FOREIGN KEY (category_product_id)
    REFERENCES category_product (id);

-- 2. Una persona (cliente) puede estar en una o muchas ventas
ALTER TABLE sale ADD CONSTRAINT sale_client
    FOREIGN KEY (client_id)
    REFERENCES person (id);
   
-- 3. Una persona (vendedor) puede realizar una o muchas ventas
ALTER TABLE sale ADD CONSTRAINT sale_seller
    FOREIGN KEY (seller_id)
    REFERENCES person (id);
    
-- 4. Un método de pago puede estar en una o muchas ventas
ALTER TABLE sale ADD CONSTRAINT sale_payment_method
    FOREIGN KEY (payment_method_id)
    REFERENCES payment_method (id);

-- 5. Un proveedor puede realizar una o varias compras
ALTER TABLE purchase ADD CONSTRAINT purchase_supplier
    FOREIGN KEY (supplier_id)
    REFERENCES supplier (id);

-- 6. Una persona (vendedor) puede realizar una o muchas compras
ALTER TABLE purchase ADD CONSTRAINT purchase_seller
    FOREIGN KEY (seller_id)
    REFERENCES person (id);
    
-- 7. Una compra puede tener uno o muchos detalles de compra
ALTER TABLE purchase_detail ADD CONSTRAINT purchase_detail_purchase
    FOREIGN KEY (purchase_id)
    REFERENCES purchase (id);

-- 8. Un método de pago puede estar en una o muchas compras
ALTER TABLE purchase ADD CONSTRAINT purchase_payment_method
    FOREIGN KEY (payment_method_id)
    REFERENCES payment_method (id);

-- 9. Un producto puede estar en uno o muchos detalles de compra
ALTER TABLE purchase_detail ADD CONSTRAINT purchase_detail_product
    FOREIGN KEY (product_id)
    REFERENCES product (id);
    
-- 10. Una venta puede tener uno o muchos detalles de venta
ALTER TABLE sale_detail ADD CONSTRAINT sale_detail_sale
    FOREIGN KEY (sale_id)
    REFERENCES sale (id);
    
-- 11. Un producto puede estar en uno o muchos detalles de venta
ALTER TABLE sale_detail ADD CONSTRAINT sale_detail_product
    FOREIGN KEY (product_id)
    REFERENCES product (id);

-- 12. A person (client) can make one or many reservations
ALTER TABLE reservation ADD CONSTRAINT reservation_client
    FOREIGN KEY (client_id)
    REFERENCES person (id);

-- 13. A person (seller) can make one or many reservations
ALTER TABLE reservation ADD CONSTRAINT reservation_seller
    FOREIGN KEY (seller_id)
    REFERENCES person (id);

-- 14. A payment method can be used in one or many reservations
ALTER TABLE reservation ADD CONSTRAINT reservation_payment_method
    FOREIGN KEY (payment_method_id)
    REFERENCES payment_method (id);

-- 15. A reservation can have one or many reservation details
ALTER TABLE reservation_detail ADD CONSTRAINT reservation_detail_reservation
    FOREIGN KEY (reservation_id)
    REFERENCES reservation (id);

-- 16. A product can appear in one or many reservation details
ALTER TABLE reservation_detail ADD CONSTRAINT reservation_detail_product
    FOREIGN KEY (product_id)
    REFERENCES product (id);

--Si no se cambia la fecha de la hora--
ALTER SESSION SET TIME_ZONE = 'America/Lima';
SELECT SESSIONTIMEZONE FROM dual;
