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
	duration VARCHAR(12),
	listed_in VARCHAR(80),
	description	VARCHAR(270)
);

--Viewing Top 10 Rows from data
select * from netflix limit 5;

--Total Contents
select count(*)
	as Total_Contents
from netflix;

--FILLING THE NULL VALUES
update netflix
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

--CHECKING ALL THE NULL VALUES
SELECT *
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

 
