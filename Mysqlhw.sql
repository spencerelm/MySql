#1a. Display the first and last names of all actors from the table actor.
select
a.first_name, a.last_name
from sakila.actor a;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

select  
a.first_name, a.last_name, concat_ws(" ", a.first_name, a.last_name) as Actor_Name 
from sakila.actor a

group by 1,2;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

select actor_id, first_name, last_name
from sakila.actor
where first_name = 'Joe';

#2b. Find all actors whose last name contain the letters GEN:

select actor_id, first_name, last_name
from sakila.actor
where last_name like '%gen%';

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

select actor_id, first_name, last_name
from sakila.actor
where last_name like '%li%'
order by 3,2;

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

select country_id, country from sakila.country
where country in ( 'Afghanistan', 'Bangladesh','China')
group by 2; 

#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).

ALTER TABLE sakila.actor
ADD column description blob after last_update;

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.

ALTER TABLE sakila.actor
DROP COLUMN description;

#4a. List the last names of actors, as well as how many actors have that last name.

select last_name, count(*)
from sakila.actor
group by 1 
order by 1;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.

select last_name, count(*) as name_count
from sakila.actor
group by 1 
having name_count > 1
order by 2;

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the recor
update sakila.actor set first_name='HARPO' where first_name='GROUCHO';

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
update sakila.actor set first_name='GROUCHO' where first_name='HARPO';

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

CREATE SCHEMA address;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

select s.first_name, s.last_name, a.address from staff s
left join address a on (a.address_id = s.address_id);

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select p.staff_id, sum(p.amount) as total, p.payment_date from staff s
join payment p on (s.staff_id = p.staff_id);

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select f.film_id, f.title, count(*) from film f 
inner join film_actor fa on (f.film_id = fa.film_id)
group by 1,2;
#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select count(inventory_id) from inventory I
left join film f on ( f.film_id = I.film_id)
where title ='HUNCHBACK IMPOSSIBLE' ;

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select c.first_name, c.last_name, sum(p.amount) as total from customer c
left join payment p on(c.customer_id = p.customer_id) 
group by 1,2
order by 2;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

select f.title from film f 
where language_id = (select language_id from language where name = 'English')
and title like 'Q%' or title like 'K%';

#7b. Use subqueries to display all actors who appear in the film Alone Trip.

select first_name, last_name 
from actor 
where actor_id = ANY(select fa.actor_id from film_actor fa left join film f on (fa.film_id = f.film_id) where f.title = 'ALONE TRIP');

#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

select c.first_name, c.last_name, c.email from customer ct
left join address a on ( ct.address_id = a.address_id)
left join city c on (a.city_id = c.city_id) 
left join country ctry on (ctry.country_id = c.country_id) 
where ctry.country = 'Canada';

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

select title, c.name from film f 
join film_category fc on (f.film_id = fc.film_id)
join category c on (fc.category_id = c.category_id)
where c.name = 'family';

#7e. Display the most frequently rented movies in descending order.

select title , length from film
group by 2
order by 2 desc;

#7f. Write a query to display how much business, in dollars, each store brought in.

select s.store_id, sum(p.amount) as total from store s
join staff sf on (s.store_id = sf.store_id)
join payment p on (sf.staff_id = p.staff_id)
group by 1;

#7g. Write a query to display for each store its store ID, city, and country.

select s.store_id, cty.city , c.country 
from store s 
join address a on (s.address_id = a.address_id)
join city cty on(a.city_id = cty.city_id)
join country c on (c.country_id = cty.country_id);

#7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

select c.name, sum(p.amount) as revenue
from category c 
join film_category fc on (c.category_id = fc.category_id) 
join inventory I on ( fc.film_id = I.film_id)
join rental r on (I.inventory_id = r.inventory_id) 
join payment p on (p.rental_id = r.rental_id) 
group by 1
order by 2 desc
limit 5 ;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you havent solved 7h, you can substitute another query to create a view.

create view Top5 as select c.name, sum(p.amount) as revenue
from category c 
join film_category fc on (c.category_id = fc.category_id) 
join inventory I on ( fc.film_id = I.film_id)
join rental r on (I.inventory_id = r.inventory_id) 
join payment p on (p.rental_id = r.rental_id) 
group by 1
order by 2 desc
limit 5;

#8b. How would you display the view that you created in 8a?

SHOW CREATE VIEW Top5;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top5;
