# Netflix Movies and TV Shows Data Analysis using SQL

![](https://github.com/mahibore/Netflix-Movie-and-TV-Shows-SQL-Project/blob/main/Netflix%20Logo.jpg)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Schema

```sql
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```
## Viewing Top 5 Rows from data
```sql 
select * from netflix limit 5;
```

## Total Contents
```sql
select count(*) as Total_Contents from netflix;
```

## FILLING THE NULL VALUES
```sql update netflix
set type=coalesce(type, 'Not Available');

select * from netflix;
select type,count(*) as unique_count from netflix group by type;

update netflix
set title=coalesce(title, 'Title Not Available');

update netflix
set director=coalesce(director, 'Director Not Available');

update netflix
set casts=coalesce(casts, 'Casts Not Available');

update netflix
set country=coalesce(country, 'Country Not Available');

update netflix
set listed_in=coalesce(listed_in, 'Listed in Not Available');

update netflix
set description=coalesce(description, 'Description Not Available');

select * from netflix;

select * from netflix where rating isnull;
select * from netflix where date_added isnull;

update netflix set
date_added=coalesce(date_added,'Date is Not Available');

update netflix set rating='TV-MA' where rating isnull;

select rating, count(*) as rating_count from netflix group by rating order by 2 desc;
```

## CHECKING ALL THE NULL VALUES
```sql SELECT *
FROM netflix
WHERE director IS NULL
   OR casts IS NULL
   OR country IS NULL
   OR date_added IS NULL
   OR rating IS NULL
   OR listed_in IS NULL
   OR type IS NULL
   OR title IS NULL
   OR description IS NULL
   OR duration IS NULL;
```

## Solving Bussiness Problems

### 1. Count the number of Movies vs TV Shows
```sql
select type, count(type) 
as Movies_VS_TVShows 
from netflix group by type;
```
**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the most common rating for movies and TV shows
```sql
select type,rating
from(
select 
type,rating, 
count(*),
rank()over(partition by type order by count(*)desc)
as Common_Rating
from netflix group by 1,2
) as t1 where Common_Rating=1;
```
**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List all movies released in a specific year (e.g., 2020)
```sql
select title as Movies_Released_in_2020 from netflix
where type='Movie' and release_year=2020;
```
**Objective:** Retrieve all movies released in a specific year.

### 4. Find the top 5 countries with the most content on Netflix
```sql
select 
UNNEST(STRING_TO_ARRAY(country, ','))as new_country,
count(show_id) as total_content
from netflix group by 1 order by 2 desc
limit 5;
```
**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the longest movie
```sql
select duration from netflix
where 
type='Movie'
and
duration=(select max(duration) from netflix);
```
**Objective:** Find the movie with the longest duration.

### 6. Find content added in the last 5 years
```sql
select * from 
netflix
where TO_DATE(date_added, 'Month DD, YYYY')>=CURRENT_DATE-INTERVAL '5 years';
```
**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find all the movies/TV shows by director ''!
```sql
select * from netflix
where director ilike'%Rajiv Chilaka%';
```
**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List all TV shows with more than 5 seasons
```sql
select * from netflix
where type='TV Show' and duration>='5 Seasons';
```
**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the number of content items in each genre
```sql
select 
unnest(STRING_TO_ARRAY(listed_in, ',')) as genre,
count(show_id) as Genre_count from netflix
group by 1 order by 2 desc;
```
**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix return top 5 year with highest avg content release!
```sql
select 
EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD, YYYY')) as Year,
COUNT(*) AS Yearly_Content,
ROUND(count(*)::numeric/(select count(*) from netflix where country='India')::numeric,2) * 100 as Avg_Content
from netflix
where country='India'
group by 1;
```
**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List all movies that are documentaries
```sql
select * from netflix
where listed_in ilike'%documentaries%';
```
**Objective:** Retrieve all movies classified as documentaries.


### 12. Find all content without a director
```sql
select * from netflix 
where director='director Not Available';
```
**Objective:** List content that does not have a director.


### 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
```sql
select * from netflix
where casts Ilike'%Salman Khan%'
and release_year>=EXTRACT(YEAR FROM CURRENT_DATE)-10;
```
**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
```sql
select 
unnest(STRING_TO_ARRAY(casts,',')) as Actors,
count(show_id) as Actors_Count
from netflix where country ilike'%India%' and casts<>'casts Not Available'
group by 1 order by 2 desc 
limit 10;
```
**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.*/
```sql 
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
```
**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution    :** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings          :** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights   :** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization  :** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

### Stay Updated and Join the Community

For more content on SQL, data analysis, and other data-related topics, make sure to follow me on social media and join our community:

- **Instagram**: [Follow me for daily tips and updates](https://www.instagram.com/zero_analyst/)
- **LinkedIn**: [Connect with me professionally]((https://www.linkedin.com/in/maheshbore03/))

Thank you for your support, and I look forward to connecting with you!
