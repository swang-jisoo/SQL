-- Database Management SQL hackaton 
-- Solve 5 questions in 45 min with a team
-- Use no more than 2 laptops

-- Movie Database (see DM_hackathon_database.sql)
-- 3 Tables and data are given: 
-- 	1) MOVIES: popular movies, 
-- 	2) ACTORS: actors/actresses, 
-- 	3) MOVIE_TO_ACTOR: actors/actresses appeared in the movie

-- 5 Questions
-- 1. Find the movie genre that its total revenue is over 2 billion in 
--    descending order by the total revenue
select distinct genre, sum(revenue) as totalRev
from movies
group by genre
having sum(revenue) > 2000000000
order by sum(revenue) desc;

-- 2. Find the number of actors whose average gross is higher than 'Will 
--    Smith'.
select count(*)
from actors
where (Total_Gross/Num_Movies) > (select (Total_Gross/Num_Movies) 
				  from Actors
				  where Name='Will Smith'); 

-- 3. Find the movie title with maximum revenue.
select title, revenue
from movies
where revenue = (select max(revenue) from movies);

-- 4. Find the name of actors starred in 'Catch Me If You Can'.
select name
from actors 
inner join movie_to_actor on actors.actorid = movie_to_actor.actorid 
inner join movies on movie_to_actor.movieid = movies.movieid
where title = 'Catch Me If You Can';

-- 5. Find the title of movie released in 2013 and the number of actors 
--    in the movie.
select title, count(*) as numActors
from movies
inner join movie_to_actor on movies.movieid = movie_to_actor.movieid 
inner join actors on movie_to_actor.actorid = actors.actorid
where year = 2013
group by title;
