
use sakila;

-- 1a. Display the first and last names of all actors from the table `actor`.

select first_name, last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.

select concat(first_name, last_name) AS 'Actor_Name' from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

select actor_id, first_name, last_name from actor where first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters `GEN`:

select first_name, last_name from actor where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:

select last_name, first_name from actor where last_name like '%LI%';

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:

select country_id, country from country where country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).

Alter Table actor 
Add Description BLOB;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
Alter Table actor 
Drop column Description;
-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name as 'Last Name', count(last_name) as 'Number' from actor group by last_name;


-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name as 'Last Name', count(last_name) as 'Number' 
from actor 
group by last_name
having count(last_name) > 1
;

-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.

UPDATE actor
SET first_name = 'Harpo'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';




-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.

UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO';


-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
describe address;

  -- Hint: [https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html](https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html)
select * from address
;
-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
select staff.first_name, staff.last_name, staff.address_id, address.address
from address
Inner join staff on
staff.address_id = address.address_id;

select * from payment;

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.

select s.first_name, s.last_name, sum(p.amount)
from staff s
inner join payment p
on s.staff_id = p.staff_id
where p.payment_date like '2005-08%'
group by p.staff_id;


-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
select title, count(actor_id) as num_actors
from film f
inner join film_actor fa
on f.film_id = fa.film_id
group by title
order by title asc;

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select title, count(inventory_id) as num_copies
from film f
inner join inventory i
on f.film_id = i.film_id
where title = 'Hunchback Impossible';


-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
select last_name, first_name, sum(amount) as total_paid
from payment p
inner join customer c 
on p.customer_id = c.customer_id
group by p.customer_id 
order by last_name asc;


select * from language;
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
select title
from film
where (title like 'K%') or (title like 'Q%') and language_id in
	(select language_id 
	from language	
    where name = 'English')
    ;


-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
select last_name, first_name
from actor
where actor_id in 
	(select actor_id
    from film_actor
    where film_id in
		(select film_id
		from film
		where title = 'Alone Trip')
        );
        
        
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select * from customer;

select c.first_name, c.last_name, c.email
from customer c
inner join address a
on c.address_id = a.address_id
inner join city ci
on a.city_id = ci.city_id
inner join country cy
on cy.country_id = ci.country_id
where country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.



select title
from film
where film_id in
	(select film_id
	from film_category
	where category_id in
		(select category_id 
		from category 
		where name = "Family")
	);    

-- 7e. Display the most frequently rented movies in descending order.
select * from film;


select i.film_id, f.title, count(r.inventory_id) as num_rentals
from inventory i
inner join rental r
on i.inventory_id = r.inventory_id
inner join film f
on i.film_id = f.film_id
group by f.film_id
order by num_rentals desc;

select * from staff;
-- 7f. Write a query to display how much business, in dollars, each store brought in.
select s.store_id, st.staff_id, sum(p.amount)
from store s
inner join staff st
on s.store_id = st.store_id
inner join payment p
on st.staff_id = p.staff_id
group by p.staff_id;




-- 7g. Write a query to display for each store its store ID, city, and country.
select * from address;

select s.store_id, city, country
from store s
inner join address a
on a.address_id = s.address_id
inner join city ci
on ci.city_id = a.city_id
inner join country cy
on cy.country_id = ci.country_id;

-- 7h. List the top five genres in gross revenue in descending order. (----Hint----: you may need to use the following tables: category, film_category, inventory, payment, and rental.)


select cat.name, sum(p.amount) as gross_rev
from category cat
inner join film_category f
on cat.category_id = f.category_id
inner join inventory i
on i.film_id = f.film_id
inner join rental r
on i.inventory_id = r.inventory_id
inner join payment p
on p.rental_id = r.rental_id
group by cat.name 
order by gross_rev desc limit 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
drop view if exists top_five;
create view top_five as
	select cat.name, sum(p.amount) as gross_rev
	from category cat
	inner join film_category f
	on cat.category_id = f.category_id
	inner join inventory i
	on i.film_id = f.film_id
	inner join rental r
	on i.inventory_id = r.inventory_id
	inner join payment p
	on p.rental_id = r.rental_id
	group by cat.name 
	order by gross_rev desc limit 5;


-- 8b. How would you display the view that you created in 8a?
select * from top_five;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
drop view top_five;
