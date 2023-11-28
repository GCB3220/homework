show databases;
use dvdrental;
show tables;
-- select
SELECT * FROM film;
SELECT actor_id,first_name,last_name FROM actor;
SELECT actor_id AS id, first_name AS "first name", last_name
FROM actor;
SELECT actor_id, first_name,last_name
FROM actor
LIMIT 5;
SELECT film_id title, length, 10 +rental_duration*2 AS cost
FROM film
LIMIT 5;
SELECT payment_date, payment_date + interval 3 day AS payment_duration
FROM payment;
SELECT DISTINCT rating
FROM film;
SELECT *
FROM film
ORDER BY rental_duration DESC
LIMIT 5;
SELECT title, rental_rate, language_id, rating
FROM film
ORDER BY rental_rate DESC, language_id, rating;
SELECT *
FROM payment
WHERE amount>=5
AND NOT staff_id=2;
SELECT *
FROM customer
WHERE last_name IN ("Harris", "White");
SELECT *
FROM customer
WHERE last_name LIKE "J%";
SELECT rating, MIN(length)
FROM film
GROUP BY rating;
SELECT rating, MIN(length) AS min_Length
FROM film
GROUP BY rating
HAVING min_Length >46;
SELECT *
FROM city
INNER JOIN country ON
city.country_id=country.country_id;
SELECT film.film_id, film.title, inventory_id
FROM film
LEFT OUTER JOIN inventory ON film.film_id = inventory.film_id
WHERE inventory.film_id IS NULL
ORDER BY film.title DESC;
-- no full outer join
SELECT *
FROM rental, staff
WHERE rental.staff_id = staff.staff_id
    AND store_id = 1
    AND first_name LIKE 'M%'
ORDER BY address_id;
SELECT film_id, title,rental_rate
FROM film
WHERE rental_rate > ( 
    SELECT AVG(rental_rate) 
    FROM film);
SELECT film_id,title
FROM film
WHERE (film_id,title) NOT IN ( 
    SELECT DISTINCT inventory.film_id,title 
    FROM inventory 
    INNER JOIN film ON film.film_id = inventory.film_id
);

-- task: find out the actor (id,first_name,last_name) with most films
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id = (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 1
);
SELECT actor_id, COUNT(film_id) AS film_num
FROM film_actor
GROUP BY actor_id
ORDER BY film_num DESC;

/* find out the rental events for customer first/last name, phone, film title and return_date 
that returned before 2005-06-01. */
SELECT
customer.first_name, customer.last_name,
address.phone, film.title, rental.return_date
FROM rental
INNER JOIN customer ON rental.customer_id=customer.customer_id
INNER JOIN address ON customer.address_id=address.address_id
INNER JOIN inventory ON rental.inventory_id=inventory.inventory_id
INNER JOIN film ON inventory.film_id=film.film_id
WHERE rental.return_date < "2005-06-01"; 

/* Task 18: get the films (id and title) that are not in the ‘inventory’. 
NOTE ‘inventory’ has only ‘id’ but title is in ‘film’. */
SELECT film.film_id, title
FROM film
WHERE film_id NOT IN (
    SELECT inventory.film_id
    FROM inventory
    INNER JOIN film ON inventory.film_id = film.film_id
);

-- Task 17: Find out the film_id of the film with length < 60
-- and category belongs to ‘Action’ type.
SELECT film_id
FROM film
WHERE film.length < 60 AND film_id IN (
    SELECT film_id
    from film_category
    WHERE category_id = 1
);
SELECT film_id
FROM film
WHERE length < 60 AND film_id IN (
    SELECT film_id FROM film_category 
    WHERE category_id = ( 
        SELECT category_id 
        FROM category WHERE name="Action"
    )
);

-- Task 16:to get films (id and title) that have the returned date 
-- between 2005-05-29 and 2005-05-30
SELECT film_id, title
FROM film
WHERE film_id IN (
    SELECT inventory.film_id
    FROM rental
    INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
    WHERE return_date BETWEEN '2005-05-29' AND '2005-05-30'
);

-- Task 15: Find out the customer information (id, first_name,
-- last_name, email, amount) and his/her payment
-- information (amount, payment_date) for those
-- customers whose first_name starts with A. 
SELECT
customer.customer_id,
customer.first_name,
customer.last_name,
customer.email,
payment.amount,
payment.payment_date
FROM customer
INNER JOIN payment ON
customer.customer_id=payment.customer_id
WHERE first_name LIKE "A%";