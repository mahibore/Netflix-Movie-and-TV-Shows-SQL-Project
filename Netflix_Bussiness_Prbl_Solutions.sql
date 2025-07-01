--NETFLIX SQL PROJECT

--Create Table Netflix
create table netflix(
	show_id varchar(10),
	type varchar(20),
	title varchar(110),
	director VARCHAR(210),
	casts VARCHAR(775),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(50),
	listed_in VARCHAR(80),
	description	VARCHAR(270)
);

--Select 5 rows from Data
select * from netflix limit 5;

--Select all from Netflix Data
select * from netflix;

--Checking for the Null values

select count(*) as null_vale_count from netflix
where show_id isnull
or type isnull
or title isnull
or director isnull
or casts isnull
or country isnull
or date_added isnull
or release_year isnull
or rating isnull
or duration isnull
or listed_in isnull
or description isnull;

--Filling the null values using update and coalesce methods

update netflix set
type=coalesce(type,'Type Not Available');

update netflix set
title=coalesce(title,'Title Not Available');

update netflix set
director=coalesce(director,'director Not Available');

update netflix set
casts=coalesce(casts,'casts Not Available');

update netflix set
country=coalesce(country,'country Not Available');

update netflix set
date_added=coalesce(date_added,'date_added Not Available');
delete from netflix where date_added='date_added Not Available';


update netflix set
duration=coalesce(duration,'duration Not Available');

update netflix set
listed_in=coalesce(listed_in,'listed_in Not Available');

update netflix set
description=coalesce(description,'description Not Available');

select * from netflix;


--Solving Bussiness Problems

--1. Count the number of Movies vs TV Shows

select type, count(type) 
as Movies_VS_TVShows 
from netflix group by type;


--2. Find the most common rating for movies and TV shows

select type,rating
from(
select 
type,rating, 
count(*),
rank()over(partition by type order by count(*)desc)
as Common_Rating
from netflix group by 1,2
) as t1 where Common_Rating=1;


--3. List all movies released in a specific year (e.g., 2020)

select title as Movies_Released_in_2020 from netflix
where type='Movie' and release_year=2020;


--4. Find the top 5 countries with the most content on Netflix

select 
UNNEST(STRING_TO_ARRAY(country, ','))as new_country,
count(show_id) as total_content
from netflix group by 1 order by 2 desc
limit 5;


--5. Identify the longest movie

select duration from netflix
where 
type='Movie'
and
duration=(select max(duration) from netflix);


--6. Find content added in the last 5 years

select * from 
netflix
where TO_DATE(date_added, 'Month DD, YYYY')>=CURRENT_DATE-INTERVAL '5 years';


--7. Find all the movies/TV shows by director ''!

select * from netflix
where director ilike'%Rajiv Chilaka%';

--8. List all TV shows with more than 5 seasons

select * from netflix
where type='TV Show' and duration>='5 Seasons';

--9. Count the number of content items in each genre

select 
unnest(STRING_TO_ARRAY(listed_in, ',')) as genre,
count(show_id) as Genre_count from netflix
group by 1 order by 2 desc;


/*10.Find each year and the average numbers of content release in India on netflix 
return top 5 year with highest avg content release!*/

select 
EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD, YYYY')) as Year,
COUNT(*) AS Yearly_Content,
ROUND(count(*)::numeric/(select count(*) from netflix where country='India')::numeric,2) * 100 as Avg_Content
from netflix
where country='India'
group by 1;

--11. List all movies that are documentaries

select * from netflix
where listed_in ilike'%documentaries%';


--12. Find all content without a director

select * from netflix 
where director='director Not Available';


--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix
where casts Ilike'%Salman Khan%'
and release_year>=EXTRACT(YEAR FROM CURRENT_DATE)-10;


--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select 
unnest(STRING_TO_ARRAY(casts,',')) as Actors,
count(show_id) as Actors_Count
from netflix where country ilike'%India%' and casts<>'casts Not Available'
group by 1 order by 2 desc 
limit 10;

/*15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.*/

with category
as(
SELECT *,
    CASE 
        WHEN description ILIKE '%kill%' 
             OR description ILIKE '%violence%' THEN 'BAD Content'
        ELSE 'GOOD Content'
    END AS content_description
FROM netflix
)
select content_description, count(*)
from category as Category_count
group by 1;




