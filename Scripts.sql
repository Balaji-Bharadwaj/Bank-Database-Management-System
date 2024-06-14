-- Trigger Implementation

CREATE OR REPLACE FUNCTION update_transaction_count()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE customer
  SET transaction_count = transaction_count + 1
  WHERE customer.customer_id = NEW.customer_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER increment_transaction_count
AFTER INSERT ON transactions
FOR EACH ROW
EXECUTE FUNCTION update_transaction_count();


-- Insert Queries

INSERT INTO customer (customer_id, first_name, last_name, age, email, gender,occupation, marital_status,
					  education, phone, address)
VALUES (53226, 'Wynn', 'Egglestone', 81, 'wegglestone0@redcross.org', 'Female', 'Database Administrator I',
		'Divorced', 'Doctoral degree', '999-745-1176', '808 Dahle Street')	


INSERT INTO customer_identity (customer_identity_id, customer_id, id_type, id_number)
VALUES (139068, 53226, 'SSN', '98562547291');

INSERT INTO customer_account (customer_account_id, customer_id, account_type, opened_on, closed_on, balance)
VALUES (743281, 70983, 'Saving', '08-02-99', '10/15/2003', '711031');

INSERT INTO employee (employee_id, first_name, last_name, date_of_joining, age, address, job_title)
VALUES (12325, 'Mabelle	Hilldrop', '8/15/2014', 53, '40 Sutherland Street', 'IT');

INSERT INTO transactions (transaction_id, customer_id, transaction_time, transaction_made_at, approved_by)
VALUES ('3663302025', 53226, '2023-05-06 12:30:00', 'New York', 90374);

INSERT INTO crm (crm_id, customer_id, employee_id, customer_priority)
VALUES (407953705, 53226, 12325, 1);



-- Sample Queries

-- Retrieving a customer's last name, email, account types and their balances whose first name is Wynn
SELECT c.first_name, c.last_name, c.email, ca.account_type, ca.balance
FROM customer c
JOIN customer_account ca ON c.customer_id = ca.customer_id 
WHERE first_name = 'Wynn';

-- Getting the total transaction count for each customer, ordered by the highest transaction count limit 10
SELECT c.customer_id, c.first_name, c.last_name, COUNT(t.transaction_id) AS total_transactions
FROM customer c
LEFT JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_transactions DESC Limit 10;

-- Getting the customer's first name, last name, and transaction count, 
-- where the transaction count is greater than the average transaction count:
SELECT c.first_name, c.last_name, COUNT(t.transaction_id) AS transaction_count
FROM customer c
LEFT JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(t.transaction_id) > (SELECT AVG(transaction_count) FROM customer);

-- Retrieving the customer's first name, last name, and account balance
-- where the account balance is greater than 800000:
SELECT c.first_name, c.last_name, ca.balance
FROM customer c
JOIN customer_account ca ON c.customer_id = ca.customer_id
WHERE ca.balance::INTEGER > 800000;

-- Getting the customer's first name, last name, and transaction count, where first name starts with "J":
SELECT first_name, last_name, 
(SELECT COUNT(transaction_id) FROM transactions WHERE customer_id = c.customer_id) AS transaction_count
FROM customer c
WHERE first_name LIKE 'J%';

-- Retrieve the customer's first name, last name, and transaction time, 
-- where the transaction time is the latest for each customer:
SELECT c.first_name, c.last_name, t.transaction_time
FROM customer c
JOIN transactions t ON c.customer_id = t.customer_id
WHERE t.transaction_time = (SELECT MAX(transaction_time) FROM transactions WHERE customer_id = c.customer_id);


-- Get the customer's first name, last name, and account count, 
-- along with their corresponding account count, ordered by the highest account count:
SELECT c.first_name, c.last_name, COUNT(ca.customer_account_id) AS account_count
FROM customer c
LEFT JOIN customer_account ca ON c.customer_id = ca.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY account_count DESC;

-- Retrieving the first name, last name of employees who have the job title containing the word "t"
-- and the total number of CRM records associated with each employee
SELECT e.first_name, e.last_name, COUNT(c.crm_id) AS total_crm_count, e.job_title
FROM employee e
LEFT JOIN crm c ON e.employee_id = c.employee_id
WHERE e.job_title LIKE '%t%'
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY total_crm_count DESC;



-- Function Implementation
CREATE OR REPLACE FUNCTION track_transaction_counts(p_customer_id INTEGER, p_start_date DATE, p_end_date DATE)
RETURNS TABLE (customer_id INTEGER, transaction_count BIGINT) AS $$
BEGIN
  RETURN QUERY
  SELECT p_customer_id, COUNT(*) AS transaction_count
  FROM transactions
  WHERE transactions.customer_id = p_customer_id
    AND transactions.transaction_time >= p_start_date
    AND transactions.transaction_time < (p_end_date + INTERVAL '1 DAY')
  GROUP BY p_customer_id;

  RETURN;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM track_transaction_counts(53226, '2021-01-01', '2024-01-31');


-- Index Implemention

-- #1
CREATE INDEX idx_transactions_customer_id ON transactions (customer_id);

-- Getting the customer's first name, last name, and transaction count, where first name starts with "J":
SELECT first_name, last_name, 
(SELECT COUNT(transaction_id) FROM transactions WHERE customer_id = c.customer_id) AS transaction_count
FROM customer c
WHERE first_name LIKE 'J%';

DROP INDEX IF EXISTS idx_transactions_customer_id;


-- #2
CREATE INDEX idx_transactions_customer_id ON transactions (customer_id);

-- Retrieve the customer's first name, last name, and transaction time, 
-- where the transaction time is the latest for each customer:
SELECT c.first_name, c.last_name, t.transaction_time
FROM customer c
JOIN transactions t ON c.customer_id = t.customer_id
WHERE t.transaction_time = (SELECT MAX(transaction_time) FROM transactions WHERE customer_id = c.customer_id);







