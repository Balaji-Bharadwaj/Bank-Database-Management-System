CREATE TABLE customer (
  customer_id INTEGER PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  age INTEGER NOT NULL,
  email VARCHAR(100) NOT NULL,
  gender VARCHAR(20) NOT NULL,
  occupation VARCHAR(120),
  marital_status VARCHAR(20),
  education varchar(20),
  phone VARCHAR(20) NOT NULL,
  address VARCHAR(200) NOT NULL,
  transaction_count VARCHAR(20)
);

CREATE TABLE customer_identity (
  customer_identity_id Integer PRIMARY KEY,
  customer_id Integer REFERENCES customer(customer_id),
  id_type VARCHAR(20),
  id_number VARCHAR(20)
);

CREATE TABLE customer_account (
  customer_account_id Integer PRIMARY KEY,
  customer_id Integer REFERENCES customer(customer_id),
  account_type VARCHAR(20),
  opened_on DATE,
  closed_on DATE default NULL,
  balance VARCHAR(20)
);

CREATE TABLE employee (
  employee_id Integer PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  date_of_joining DATE,
  age VARCHAR(3),
  address VARCHAR(200),
  job_title VARCHAR(120) NOT NULL
);


CREATE TABLE transactions (
  transaction_id VARCHAR PRIMARY KEY,
  customer_id Integer REFERENCES customer(customer_id),
  transaction_time TIMESTAMP,
  transaction_made_at VARCHAR(50),
  approved_by Integer References employee(employee_id)
);

CREATE TABLE crm (
  crm_id Integer PRIMARY KEY,
  customer_id Integer REFERENCES customer(customer_id),
  employee_id Integer References employee(employee_id),
  customer_priority Integer
);