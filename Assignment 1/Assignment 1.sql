/* =========================================================
   1. Get all customers whose first name starts with 'J'
      and who are active
   ---------------------------------------------------------
   - LIKE 'J%' finds names starting with J
   - active = 1 filters only active customers
   ========================================================= */
SELECT *
FROM customer
WHERE first_name LIKE 'J%'
  AND active = 1;


/* =========================================================
   2. Find all films where:
      - title contains 'ACTION'
      OR
      - description contains 'WAR'
   ---------------------------------------------------------
   - % allows matching anywhere in the text
   - OR returns rows if either condition is true
   ========================================================= */
SELECT *
FROM film
WHERE title LIKE '%ACTION%'
   OR description LIKE '%WAR%';


/* =========================================================
   3. List customers whose:
      - last name is NOT 'SMITH'
      - first name ends with 'a'
   ---------------------------------------------------------
   - <> means not equal
   - '%a' matches names ending with 'a'
   ========================================================= */
SELECT *
FROM customer
WHERE last_name <> 'SMITH'
  AND first_name LIKE '%a';


/* =========================================================
   4. Get all films where:
      - rental rate is greater than 3.0
      - replacement cost is NOT NULL
   ---------------------------------------------------------
   - IS NOT NULL checks for existing values
   - NULL cannot be compared using '='
   ========================================================= */
SELECT *
FROM film
WHERE rental_rate > 3.0
  AND replacement_cost IS NOT NULL;


/* =========================================================
   5. Count how many active customers exist in each store
   ---------------------------------------------------------
   - WHERE filters rows before grouping
   - GROUP BY store_id groups customers per store
   - COUNT(*) counts customers in each group
   ========================================================= */
SELECT store_id,
       COUNT(*) AS active_customers
FROM customer
WHERE active = 1
GROUP BY store_id;


/* =========================================================
   6. Show distinct film ratings available
   ---------------------------------------------------------
   - DISTINCT removes duplicate ratings
   ========================================================= */
SELECT DISTINCT rating
FROM film;


/* =========================================================
   7. Find number of films per rental duration
      where average film length is greater than 100
   ---------------------------------------------------------
   - GROUP BY creates groups by rental_duration
   - AVG(length) calculates average per group
   - HAVING filters aggregated results
   ========================================================= */
SELECT rental_duration,
       COUNT(*) AS film_count
FROM film
GROUP BY rental_duration
HAVING AVG(length) > 100;


/* =========================================================
   8. List payment dates and total amount paid per date
      Include only days with more than 100 payments
   ---------------------------------------------------------
   - DATE(payment_date) removes time part
   - SUM(amount) totals payments per day
   - HAVING filters grouped results
   ========================================================= */
SELECT DATE(payment_date) AS payment_day,
       SUM(amount) AS total_amount,
       COUNT(*) AS payment_count
FROM payment
GROUP BY DATE(payment_date)
HAVING COUNT(*) > 100;


/* =========================================================
   9. Find customers whose:
      - email is NULL
      OR
      - email ends with '.org'
   ---------------------------------------------------------
   - IS NULL checks missing emails
   - '%.org' matches .org domains
   ========================================================= */
SELECT *
FROM customer
WHERE email IS NULL
   OR email LIKE '%.org';


/* =========================================================
   10. List films with rating 'PG' or 'G'
       ordered by rental rate descending
   ---------------------------------------------------------
   - IN simplifies multiple OR conditions
   - ORDER BY DESC sorts highest first
   ========================================================= */
SELECT *
FROM film
WHERE rating IN ('PG', 'G')
ORDER BY rental_rate DESC;


/* =========================================================
   11. Count films for each length where:
       - title starts with 'T'
       - count is greater than 5
   ---------------------------------------------------------
   - WHERE filters rows before grouping
   - HAVING filters groups after aggregation
   ========================================================= */
SELECT length,
       COUNT(*) AS film_count
FROM film
WHERE title LIKE 'T%'
GROUP BY length
HAVING COUNT(*) > 5;


/* =========================================================
   12. List actors who have appeared in more than 10 films
   ---------------------------------------------------------
   - film_actor is a bridge table
   - JOIN connects actors to films
   - COUNT counts films per actor
   ========================================================= */
SELECT a.actor_id,
       a.first_name,
       a.last_name,
       COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa
  ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(fa.film_id) > 10;


/* =========================================================
   13. Top 5 films with highest rental rate
       and longest length
   ---------------------------------------------------------
   - ORDER BY applies priority sorting
   - LIMIT restricts result size
   ========================================================= */
SELECT *
FROM film
ORDER BY rental_rate DESC, length DESC
LIMIT 5;


/* =========================================================
   14. Show all customers with total rentals made
       ordered from most to least rentals
   ---------------------------------------------------------
   - LEFT JOIN keeps customers with zero rentals
   - COUNT(rental_id) counts rentals per customer
   ========================================================= */
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       COUNT(r.rental_id) AS total_rentals
FROM customer c
LEFT JOIN rental r
  ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_rentals DESC;


/* =========================================================
   15. List film titles that have never been rented
   ---------------------------------------------------------
   - LEFT JOIN keeps all films
   - Missing rentals produce NULL values
   - IS NULL identifies never-rented films
   ========================================================= */
SELECT f.title
FROM film f
LEFT JOIN inventory i
  ON f.film_id = i.film_id
LEFT JOIN rental r
  ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;
