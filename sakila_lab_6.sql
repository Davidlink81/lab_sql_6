----------------
-- LAB 6 SQL --
---------------- 

use sakila;

/* 1. Rank films by length (filter out the rows with nulls or zeros in length column). Select only columns title, 
length and rank in your output.*/

select title, length, rank() over (order by length asc) as ranking
from film
where length is not null and length > 0;

/* 2. Rank films by length within the `rating` category (filter out the rows with nulls or zeros in length column). 
In your output, only select the columns title, length, rating and rank.*/

select title, length, rating, rank() over (partition by rating order by length desc) as ranking
from sakila.film
where length is not null and length > 0;

/* 3. How many films are there for each of the categories in the category table? 
**Hint**: Use appropriate join between the tables "category" and "film_category".*/

select c.name as category_name, count(fc.film_id) as movie_count
from category c
join film_category fc on c.category_id = fc.category_id
group by c.name
order by movie_count;

/* 4. Which actor has appeared in the most films? 
**Hint**: You can create a join between the tables "actor" and "film actor" and count the number of times an actor appears.*/


select a.actor_id, a.first_name, a.last_name, count(fa.film_id) as film_count
from actor a
join film_actor fa on a.actor_id = fa.actor_id
group by a. actor_id, a.first_name, a.last_name
order by film_count desc
limit 1;


/* 5. Which is the most active customer (the customer that has rented the most number of films)? 
**Hint**: Use appropriate join between the tables "customer" and "rental" and count the `rental_id` for each customer.*/

select c.customer_id, c.first_name, c.last_name, count(r.rental_id) as rental_count
from customer c
join rental r on c.customer_id = r.customer_id
group by c.customer_id, c.first_name, c.last_name
order by rental_count desc
limit 1;

/* 6. List the number of films per category.*/

select c.name as category_name, count(fc.film_id) as movie_count
from category c
join film_category fc on c.category_id = fc.category_id
group by c.name
order by movie_count;

-- 7. Display the first and the last names, as well as the address, of each staff member.

select first_name, last_name, address_id
from staff;

-- 8. Display the total amount rung up by each staff member in August 2005.

select s.staff_id, s.first_name, s.last_name, sum(p.amount) as total_amount_rung
from staff s
join payment p on s.staff_id = p.staff_id
where date_format(p.payment_date,'%Y-%m')= '2005-08'
group by s.staff_id, s.first_name, s.last_name; 

-- 9. List all films and the number of actors who are listed for each film.

select f.title, count(fa.actor_id) as total_actors
from film f
join film_actor fa on f.film_id = fa.film_id
group by f.title;

-- 10. Using the payment and the customer tables as well as the JOIN command, list the total amount paid by each customer. List the customers alphabetically by their last names./*

select c.last_name, sum(p.amount) as total_amount
from customer c
join payment p on c.customer_id = p.customer_id
group by c.last_name
order by c.last_name;

-- 11. Write a query to display for each store its store ID, city, and country.

select * from store;
select * from address;
select * from city;
select * from country;

select s.store_id, ci.city, co.country
from store s
inner join address a on s.address_id = a.address_id
inner join city ci on a.city_id = ci.city_id
inner join country co on ci.country_id = co.country_id;

-- 12. Write a query to display how much business, in dollars, each store brought in.

select s.store_id, sum(p.amount) as total_amount
from store s
join staff st on s.store_id = st.store_id
join payment p on st.staff_id = p.staff_id
group by s.store_id;


-- 13. What is the average running time of films by category?
select * from sakila.category;
select c.name as category, avg(f.length) as average_running_time
from category c
join film_category fc on c.category_id = fc.category_id
join film f on fc.film_id = f.film_id
group by c.name;

-- 14. Which film categories are longest?
select c.name as category, avg(f.length) as average_running_time
from category c
join film_category fc on c.category_id = fc.category_id
join film f on fc.film_id = f.film_id
group by c.name
order by avg(f.length) desc
limit 1;

-- 15. Display the most frequently rented movies in descending order.
select f.title as movie_title, count(r.rental_id) as rental_count
from film f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
group by f.title
order by rental_count desc;

-- 16. List the top five genres in gross revenue in descending order.
select c.name as genre, sum(p.amount) as gross_revenue
from category c
join film_category fc on c.category_id = fc.category_id
join film f on fc.film_id = f.film_id
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join payment p on r.rental_id = p.rental_id
group by c.name
order by sum(p.amount) desc
limit 5;

-- 17. Is "Academy Dinosaur" available for rent from Store 1?
select count(*) as avaible, f.title
from film f
join inventory i on f.film_id = i.film_id
join store s on i.store_id = s.store_id
where f.title = "ACADEMY DINOSAUR" and s.store_id = 1;