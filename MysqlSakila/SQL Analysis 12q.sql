#  10 Advanced SQL Queries ==  Data Analysis ==

SELECT * FROM sakila.film;

-- 1) All films with PG-13 films with rental rate of 2.99 or lower 

select * from sakila.film f
where f.rating = 'PG-13' and f.rental_rate <= 2.99;

-- 2) All films that have deleted scenes

select * from sakila.film f
where f.special_features like '%deleted Scenes%';

# 3) All active customers

select count(*) as Total_no_customers_in_Active from sakila.customer
where active = 1;

select count(active) as Total_no_customers_in_Active from sakila.customer
where active = 1;

-- 4) Names of customers who rented a movie on 26th July 2005

select r.rental_date,r.rental_id, concat(c.first_name , ' ' ,c.last_name)as 'Full Name'
from sakila.rental r
join customer c on c.customer_id = r.customer_id
where date(r.rental_date)= '2005-07-26';

select * from customer;
-- 5) Distinct names of customers who rented a movie on 26th July 2005

select distinct r.customer_id, concat(c.first_name , ' ' ,c.last_name)as 'Full Name' from sakila.rental r
join customer c on c.customer_id = r.customer_id
where date(r.rental_date)= '2005-07-26';

-- Distinct LastName
select distinct r.customer_id ,c.last_name from sakila.rental r
join customer c on c.customer_id = r.customer_id
where date(r.rental_date)= '2005-07-26';

-- 6) How many rentals we do on each day?                                  Group By

select date(r.rental_date) date, count(*) as No_of_rental 
from sakila.rental r
group by date(r.rental_date);

-- what is thr busiest day so far?

select date(r.rental_date) date, count(*) as Counts  from sakila.rental r
group by date(r.rental_date)
order by Counts desc ;


-- 7) All Sci-fi films in our catalogue

select cy.category_id,cy.name,fc.film_id,f.title,f.rating
from sakila.category cy 
join sakila.film_category fc
on  cy.category_id= fc.category_id
join sakila.film f
on f.film_id =fc.film_id
where cy.category_id=14;

-- 8) Customers and how many movies they rented from us so far?
select c.customer_id,c.first_name,c.email,count(*) as No_of_times
from sakila.customer c
inner join sakila.rental r
on c.customer_id = r.customer_idinventory
group by r.customer_id
order by No_of_times desc; 


-- 9) Which movies should we discontinue from our catalogue (less than 1 lifetime rentals)
select inventory_id,count(*)
from rental r
group by r.inventory_id
order by count(*) asc;

select inventory_id,count(inventory_id)
from rental r
group by r.inventory_id
having count(*) <=1 ;

-- CTE
 With Low_ratingMovie as
 (
	 select inventory_id,count(inventory_id)
	from rental r
	group by r.inventory_id
	having count(*) <=1 
)
select i.inventory_id,f.film_id,f.title from Low_ratingMovie
join inventory i on i.inventory_id= Low_ratingMovie.inventory_id
join film f on f.film_id = i.film_id;


-- 10) Which movies are not returned yet?

Select r.rental_id,r.inventory_id,r.customer_id,r.rental_date,f.film_id,f.title from rental r 
join inventory i on i.inventory_id =r.inventory_id
join film f on f.film_id= i.film_id
where r.return_date is Null
order by title ;



-- H1) How many distinct last names we have in the data?
Select *  from sakila.customer;
Select last_name, count(last_name) from sakila.customer
group by last_name;
select distinct first_name, count(first_name) from sakila.customer
group by first_name;

-- H2) How much money and rentals we make for Store 1 by day?  
select s.manager_staff_id,
		sf.first_name,
		p.amount,
        p.rental_id from store s
join staff sf on sf.store_id = s.store_id
join payment p on p.staff_id = sf.staff_id
join rental r on r.rental_id = p.rental_id
where s.store_id=1
;

select P.rental_id,sum(p.amount) as TotalPayment
from Store s
join staff sf on sf.store_id = s.store_id
join payment p on p.staff_id = sf.staff_id
join rental r on r.rental_id = p.rental_id
where s.store_id=1
GROUP BY p.rental_id
order by TotalPayment desc limit 10;

-- What are the three top earning days so far?

select date(r.rental_date) date, count(*) as Counts  from sakila.rental r
group by date(r.rental_date)
order by Counts desc 
limit 3;