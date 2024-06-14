COPY customer
FROM 'C:\Users\Balaji Bharadwaj\Downloads\Customer.csv'
DELIMITER ','
CSV HEADER;

COPY customer_account
FROM 'C:\Users\Balaji Bharadwaj\Downloads\Customer_Account.csv'
DELIMITER ','
CSV HEADER;

COPY customer_identity
FROM 'C:\Users\Balaji Bharadwaj\Downloads\Customer_Identity.csv'
DELIMITER ','
CSV HEADER;

COPY employee
FROM 'C:\Users\Balaji Bharadwaj\Downloads\Employee.csv'
DELIMITER ','
CSV HEADER;

COPY crm
FROM 'C:\Users\Balaji Bharadwaj\Downloads\CRM.csv'
DELIMITER ','
CSV HEADER;

COPY transactions
FROM 'C:\Users\Balaji Bharadwaj\Downloads\Transactions.csv'
DELIMITER ','
CSV HEADER;