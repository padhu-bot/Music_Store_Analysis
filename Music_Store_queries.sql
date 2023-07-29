/* Q1: Who is the senior most employee based on job title? */

SELECT CONCAT(first_name,last_name) FROM employee 
ORDER BY levels DESC
LIMIT 1;


/* Q2: Which countries have the most Invoices? */

SELECT billing_country,COUNT(*) as total_invoice FROM invoice
GROUP BY billing_country
ORDER BY total_invoice desc;


/* Q3: What are top 3 values of total invoice? */

SELECT * FROM invoice
ORDER BY total DESC
LIMIT 3;


/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

SELECT billing_city,SUM(total) as Total_invoice from invoice
group by billing_city
order by Total_invoice desc
LIMIT 1;


/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

SELECT * FROM customer 
WHERE customer_id=(SELECT customer_id FROM invoice
GROUP BY customer_id
ORDER BY SUM (total) DESC
LIMIT 1);


/* Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

SELECT DISTINCT email,first_name,last_name FROM customer c
INNER JOIN invoice i on i.customer_id=c.customer_id
INNER JOIN invoice_line il on il.invoice_id=i.invoice_id
INNER JOIN track t on t.track_id=il.track_id where t.genre_id='1'
ORDER BY email;


/* Q7: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

SELECT a.*,COUNT(t.track_id) as Total_tracks FROM artist a
INNER JOIN album al on a.artist_id=al.artist_id
INNER JOIN track t on t.album_id=al.album_id
INNER JOIN genre g on g.genre_id=t.genre_id WHERE g.name='Rock'
GROUP BY a.artist_id
ORDER BY Total_tracks desc
LIMIT 10;


/* Q8: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

SELECT name, milliseconds
FROM track
WHERE milliseconds>(SELECT AVG(milliseconds) FROM track)
ORDER BY milliseconds DESC;


/* Q9: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

SELECT CONCAT(c.first_name,c.last_name) as Customer_name,a.name as Artist_name,a.artist_id, SUM(il.quantity * il.unit_price) as total_spent FROM customer c
INNER JOIN invoice i on i.customer_id=c.customer_id
INNER JOIN invoice_line il on il.invoice_id=i.invoice_id
INNER JOIN track t on t.track_id=il.track_id 
INNER JOIN album al on al.album_id=t.album_id
INNER JOIN artist a on a.artist_id=al.artist_id
GROUP BY c.first_name,c.last_name,a.name,a.artist_id
ORDER BY Total_spent desc;


/* Q10: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

SELECT * FROM ( SELECT billing_country as country,g.name,RANK() OVER(PARTITION BY i.billing_country ORDER BY COUNT(*) DESC) Rank FROM invoice i 
INNER JOIN invoice_line il on il.invoice_id=i.invoice_id
INNER JOIN track t on t.track_id=il.track_id 
INNER JOIN genre g on g.genre_id=t.genre_id 
GROUP BY g.name,billing_country
ORDER BY billing_country ASC,COUNT(*) DESC)  as result
WHERE rank=1;


/* Q11: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

SELECT c.first_name,c.last_name, billing_country, total_amt FROM (SELECT customer_id,billing_country,SUM(total) as total_amt, RANK() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC ) FROM invoice
GROUP BY customer_id,billing_country) as result
INNER JOIN customer c on c.customer_id=result.customer_id
WHERE rank=1
ORDER BY billing_country


