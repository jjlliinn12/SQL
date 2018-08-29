USE sakila;

SHOW COLUMNS FROM actor;

-- 1a 
SELECT `first_name`, `last_name` FROM actor;

-- 1b
SELECT CONCAT(`first_name`,' ', `last_name`) AS `Actor Name`
FROM actor;

-- 2a
SELECT * 
FROM actor
WHERE first_name = 'JOE';

-- 2b
SELECT * FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c
SELECT last_name, first_name FROM actor 
WHERE last_name LIKE '%LI%'
ORDER BY last_name;

-- 2d
SELECT country_id, country
FROM   country
WHERE  country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor 
ADD COLUMN middle_name VARCHAR(45) AFTER first_name;

-- 3b
ALTER TABLE actor 
MODIFY middle_name blob;

-- 3c
ALTER TABLE actor 
DROP COLUMN middle_name;

-- 4a
SELECT last_name, COUNT(*)
  FROM actor
  GROUP BY last_name
  HAVING COUNT(*) >= 1;
  
  -- 4b
  SELECT last_name, COUNT(*)
  FROM actor
  GROUP BY last_name
  HAVING COUNT(*) >= 2;
  
-- 4c
UPDATE actor
SET first_name='HARPO' WHERE first_name='GROUCHO';
-- Testing to see if the first name is changed
select * FROM actor
WHERE last_name='WILLIAMS';

-- 4d UNSURE
UPDATE actor
SET first_name='GROUCHO' 
WHERE first_name='HARPO';

-- 5a
SHOW CREATE TABLE address; 
DESCRIBE address;
SHOW COLUMNS FROM address;
SHOW COLUMNS FROM staff;

-- 6a
SELECT staff.first_name, staff.last_name
FROM staff
LEFT JOIN address
ON staff.address_id = address.address_id;
SELECT * FROM staff JOIN address on staff.address_id = address.address_id;
SELECT * FROM staff;

-- 6b

SELECT payment.staff_id, staff.first_name, staff.last_name, payment.amount, payment.payment_date FROM staff
INNER JOIN payment ON
staff.staff_id = payment.staff_id;

-- 6c
SHOW COLUMNS FROM film;
SELECT * FROM film_actor;
SELECT title, count(actor_id) FROM film
INNER JOIN film_actor ON
film.film_id = film_actor.film_id
GROUP BY title;


-- 6d Only know how to find the film_id first and use film_id value for a filtered COUNT(*) 
-- SELECT * FROM film JOIN inventory on film.film_id = inventory.film_id;
-- SELECT * FROM inventory;
SELECT * FROM film
WHERE title='Hunchback Impossible';
SELECT COUNT(*) FROM inventory WHERE film_id=439;
-- 6 copies of Hunback Impossible


-- 6e.
SELECT * FROM payment;
SELECT * FROM customer;

SELECT first_name, last_name, amount FROM customer
INNER JOIN payment ON
customer.customer_id = payment.customer_id
GROUP BY first_name, last_name
ORDER BY last_name;

-- 7a
SELECT title, language_id from film
Where language_id IN(
	SELECT language_id
	FROM language
	WHERE name IN ('English')
	AND title LIKE ('Q%') or title LIKE ('K%'));
    
-- 7b
SELECT * FROM actor;
SELECT * FROM film_actor;
SELECT * FROM film;

SELECT first_name, last_name from actor
Where actor_id IN(
	SELECT actor_id
	FROM film_actor
	WHERE film_id IN(
		SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
        )
	);
    
-- 7c
SELECT * FROM country;
SELECT * FROM city;
SELECT * FROM address;
SELECT * FROM customer;

SELECT first_name, last_name, email from customer
where address_id IN(
	SELECT address_id
    FROM address
    WHERE city_id IN(
		SELECT city_id
        FROM city
        WHERE country_id IN(
			SELECT country_id
            FROM country
            WHERE country = 'Canada'
            )
		)
	);
    
-- 7d
SELECT * FROM film;
SELECT * FROM film_category;
SELECT * FROM category;

SELECT title from film
WHERE film_id IN(
	SELECT film_id
	FROM film_category
	WHERE category_id IN(
		SELECT category_id
        FROM category
        WHERE name = 'Family'
        )
	);
    
-- 7e
SELECT * FROM film;
SELECT * FROM inventory;
SELECT * FROM rental;

SELECT film.title, count(rental.rental_id) AS total_rentals from film
INNER JOIN inventory ON
film.film_id = inventory.film_id
INNER JOIN rental ON
inventory.inventory_id = rental.inventory_id
GROUP BY title
ORDER BY total_rentals DESC;

-- 7f
SELECT staff_id AS store, sum(amount) AS dollars from payment
GROUP BY store;

-- 7g
SELECT * from store;
SELECT * FROM address;
SELECT * FROM city;
SELECT * FROM country;

SELECT store.store_id, city.city, country.country from store
INNER JOIN address ON
store.address_id = address.address_id
INNER JOIN city ON
address.city_id = city.city_id
INNER JOIN country ON
city.country_id = country.country_id;

-- 7h
SELECT * FROM category;
SELECT * FROM film_category;
SELECT * FROM inventory;
SELECT * FROM rental;
SELECT * FROM payment;

SELECT category.name AS genre, sum(payment.amount) AS revenue from category
INNER JOIN film_category ON
category.category_id = film_category.category_id
INNER JOIN inventory ON
film_category.film_id = inventory.film_id
INNER JOIN rental ON
inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON
rental.rental_id = payment.rental_id
GROUP BY name
ORDER BY revenue DESC;

-- 8a

CREATE VIEW top_5_genres AS
SELECT category.name AS genre, sum(payment.amount) AS revenue from category
INNER JOIN film_category ON
category.category_id = film_category.category_id
INNER JOIN inventory ON
film_category.film_id = inventory.film_id
INNER JOIN rental ON
inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON
rental.rental_id = payment.rental_id
GROUP BY name
ORDER BY revenue DESC
LIMIT 5;

-- 8b
SELECT * FROM top_5_genres;

-- 8c
DROP VIEW top_5_genres;

