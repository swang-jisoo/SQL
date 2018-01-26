1. 
select distinct genre, sum(revenue) as totalRev
from movies
group by genre
having sum(revenue)>2000000000
order by sum(revenue) desc;

2.
select count(*)
	from Actors
	Where (Total_Gross/Num_Movies)>(select (Total_Gross/Num_Movies)
		from Actors
		where Name='Will Smith'); 


3.
select title, revenue
from movies
where revenue = (select max(revenue) from movies);


4.
select name
from actors inner join movie_to_actor on actors.actorid=movie_to_actor.actorid inner join movies on movie_to_actor.movieid = movies.movieid
where title = 'Catch Me If You Can';

select *
from actors
where actorid = (select actorid from movie_to_actor where movieid = (select movieid from movies where title = 'Catch Me If You Can'));

5. 
select title, count(*)
from movie left outer join movie_to_actor left outer join actors
group by year
where movie.year=2013;
