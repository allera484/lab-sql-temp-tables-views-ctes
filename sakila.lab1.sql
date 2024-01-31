---Retrieve the client_id and the total_amount_spent of those
-- clients who spent more than the average of the total_amount spent by each client. 
-- You can use subqueries to accomplish this.

WITH grouped_customer_spending AS 
(SELECT 
    payment.customer_id, SUM(amount) AS total_amount
FROM
    payment
GROUP BY customer_id),
average_amount AS 
(SELECT
AVG(total_amount)
FROM
grouped_customer_spending)

SELECT * FROM grouped_customer_spending;


SELECT payment.customer_id, SUM(payment.amount) AS total_amount
FROM payment
GROUP BY customer_id
HAVING SUM(payment.amount) > (
    SELECT AVG(subquery.amount)
    FROM (
        SELECT customer_id, SUM(amount) AS amount
        FROM payment
        GROUP BY customer_id
    ) subquery
);



WITH grouped_customer_spending_temporary_table AS 
(SELECT 
    payment.customer_id, SUM(amount) AS total_amount
FROM
    payment
GROUP BY customer_id)
DROP TABLE IF EXISTS average_amount_temporary_table;
CREATE TEMPORARY TABLE IF NOT EXISTS average_amount_temporary_table AS 
(SELECT
AVG(total_amount)AS avg_amount
FROM
grouped_customer_spending_temporary_table)

SELECT * FROM grouped_customer_spending_temporary_table
WHERE total_amount>(SELECT avg_amount FROM average_amount_temporary_table);





SELECT payment.customer_id, SUM(payment.amount) AS total_amount
FROM payment
GROUP BY customer_id
HAVING SUM(payment.amount) > (
    SELECT AVG(subquery.amount)
    FROM (
        SELECT customer_id, SUM(amount) AS amount
        FROM payment
        GROUP BY customer_id
    ) subquery
);

















----------------------------------------------------

SELECT 
    customer_id, SUM(amount)
FROM
    payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 1;



SELECT 
    customer_id, SUM(amount)
FROM
    payment
GROUP BY customer_id
HAVING SUM(amount) =
(SELECT
MAX(spent)
customer_id
FROM
(SELECT 
    customer_id, SUM(amount) AS spent
FROM
    payment
GROUP BY customer_id) AS grouped);

SELECT 
title
FROM
rental
JOIN inventory ON inventory.inventory_id=rental.inventory_id
JOIN film ON inventory.film_id=film.film_id
WHERE customer_id = (SELECT 
    customer_id
FROM
    payment
GROUP BY customer_id
HAVING SUM(amount) = 
(SELECT 
MAX(spent)
FROM
(SELECT 
    customer_id, SUM(amount) as spent
FROM
    payment
GROUP BY customer_id) as grouped));

SELECT 
title,payment.amount
FROM
rental
JOIN inventory ON inventory.inventory_id=rental.inventory_id
JOIN film ON inventory.film_id=film.film_id
JOIN payment ON rental.rental_id=payment.rental_id
WHERE rental.customer_id = (SELECT 
    customer_id
FROM
    payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 1);

