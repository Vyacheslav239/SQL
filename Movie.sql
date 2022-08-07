drop table movie_cast;
drop table series_cast;
drop table persons cascade;
drop table movie_watched;
drop table series_watched;
drop table users;
drop table series_genre;
drop table movie_genre;
drop table genres cascade;
drop table series_episodes;
drop table series cascade;
drop table movies cascade;
drop table InitialData;
create table persons (person_id serial primary key, person_name varchar(256), birthday date);
create table movies (movie_id serial primary key, title text);
create table movie_cast (movie_id int, person_id int, profession varchar(256), foreign key (movie_id) references movies(movie_id) on delete cascade, foreign key (person_id) references persons(person_id) on delete cascade); 
create table users (user_id int primary key, user_name varchar(256));
create table movie_watched (movie_id int, user_id int, mark smallint, date_viewed date, foreign key (movie_id) references movies(movie_id) on delete cascade, foreign key (user_id) references users(user_id) on delete cascade);
create table genres (genre_id serial primary key, genre varchar(256));
create table movie_genre (movie_id int, genre_id int, foreign key (movie_id) references movies (movie_id) on delete cascade, foreign key (genre_id) references genres(genre_id) on delete cascade);
create table series (series_id serial primary key, title varchar(256));
create table series_episodes (series_id int, season smallint, episodes int, title_episode int, title varchar(256), episode_duration time, foreign key (series_id) references series(series_id) on delete cascade);
create table series_watched (series_id int, user_id int, season int, episodes int, mark smallint, date_viewed date, foreign key (series_id) references series(series_id) on delete cascade, foreign key (user_id) references users(user_id) on delete cascade);
create table series_cast (series_id int, person_id int, season int primary key, profession varchar(256), foreign key (series_id) references series(series_id) on delete cascade, foreign key (person_id) references persons(person_id) on delete cascade);
create table series_genre (series_id int, genre_id int, foreign key (series_id) references series(series_id) on delete cascade, foreign key (genre_id) references genres(genre_id) on delete cascade);
create table InitialData (Title text, Genre text, Tags text, Languages text, SeriesOrMovie text,
HiddenGemScore text, CountryAvailability text, Runtime text, Director text, Writer text,
Actors text, ViewRating text, IMDbScore text, RottenTomatoesScore text, MetacriticScore 
text, AwardsReceived text, AwardsNominatedFor text, Boxoffice text, ReleaseDate text,
NetflixReleaseDate text, ProductionHouse text, NetflixLink text, IMDbLink text, Summary 
text, IMDbVotes text, Image text, Poster text, TMDbTrailer text, TrailerSite text);
copy InitialData from 'C:\netflix1.csv' delimiter ',' csv header;
insert into movies (title) select Title from InitialData where (IMDbScore > '7') and (SeriesOrMovie = 'Movie');
insert into series (title) select Title from InitialData where (IMDbScore > '7') and (SeriesOrMovie = 'Series');
insert into persons (person_name) select REGEXP_SPLIT_TO_TABLE(actors, ', ') from InitialData where (IMDBScore > '7');
insert into persons (person_name) select REGEXP_SPLIT_TO_TABLE(Director, ', ') from InitialData where (IMDBScore > '7');
insert into persons (person_name) select REGEXP_SPLIT_TO_TABLE(Writer, ', ') from InitialData where (IMDBScore > '7');
insert into genres (genre) select REGEXP_SPLIT_TO_TABLE(genre, ', ') from InitialData where (IMDBScore > '7') and (genre is not null);
insert into movie_cast (movie_id) select movie_id from movies;
insert into movie_cast (person_id) select person_id from persons;
insert into movie_genre (movie_id, genre_id) select movie_id,genre_id from movies join genres; 
insert into movie_genre (genre_id) select genre_id from genres;
select * from movie_genre;
select * from movie_cast;
select * from InitialData;

