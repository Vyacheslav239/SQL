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
drop table data_m;
drop table data_s;

-- Таблицы из второго дз
create table persons (person_id serial primary key, person_name varchar(256), birthday date);
create table movies (movie_id serial primary key, title text);
create table movie_cast (movie_id int, person_id int, profession varchar(256), foreign key (movie_id) references movies(movie_id) on delete cascade, foreign key (person_id) references persons(person_id) on delete cascade); 
create table users (user_id int primary key, user_name varchar(256));
create table movie_watched (movie_id int, user_id int, mark smallint, date_viewed date, foreign key (movie_id) references movies(movie_id) on delete cascade, foreign key (user_id) references users(user_id) on delete cascade);
create table genres (genre_id serial primary key, genre varchar(256));
create table movie_genre (movie_id int, genre_id int, foreign key (movie_id) references movies (movie_id) on delete cascade, foreign key (genre_id) references genres(genre_id) on delete cascade);
create table series (series_id serial primary key, title varchar(256));
create table series_episodes (series_id int, season smallint, episodes int, title_episode varchar(256), title varchar(256), episode_duration varchar(256), foreign key (series_id) references series(series_id) on delete cascade);
create table series_watched (series_id int, user_id int, season int, episodes int, mark smallint, date_viewed date, foreign key (series_id) references series(series_id) on delete cascade, foreign key (user_id) references users(user_id) on delete cascade);
create table series_cast (series_id int, person_id int, season smallint, profession varchar(256), foreign key (series_id) references series(series_id) on delete cascade, foreign key (person_id) references persons(person_id) on delete cascade);
create table series_genre (series_id int, genre_id int, foreign key (series_id) references series(series_id) on delete cascade, foreign key (genre_id) references genres(genre_id) on delete cascade);

-- Создаем таблицу для наших данных и импортируем данные из csv в таблицу
create table InitialData (Title text, Genre text, Tags text, Languages text, SeriesOrMovie text,
HiddenGemScore text, CountryAvailability text, Runtime text, Director text, Writer text,
Actors text, ViewRating text, IMDbScore text, RottenTomatoesScore text, MetacriticScore 
text, AwardsReceived text, AwardsNominatedFor text, Boxoffice text, ReleaseDate text,
NetflixReleaseDate text, ProductionHouse text, NetflixLink text, IMDbLink text, Summary 
text, IMDbVotes text, Image text, Poster text, TMDbTrailer text, TrailerSite text);
copy InitialData from 'C:\netflix1.csv' delimiter ',' csv header;

-- Создаем две вспомогательные таблицы, одну для фильмов, другую для сериалов, чтобы было легче работать с movie_id и series_id
create table data_m (index_ serial , Title text, Genre text, Tags text, Languages text, SeriesOrMovie text,
HiddenGemScore text, CountryAvailability text, Runtime text, Director text, Writer text,
Actors text, ViewRating text, IMDbScore text, RottenTomatoesScore text, MetacriticScore 
text, AwardsReceived text, AwardsNominatedFor text, Boxoffice text, ReleaseDate text,
NetflixReleaseDate text, ProductionHouse text, NetflixLink text, IMDbLink text, Summary 
text, IMDbVotes text, Image text, Poster text, TMDbTrailer text, TrailerSite text);
create table data_s (index_ serial , Title text, Genre text, Tags text, Languages text, SeriesOrMovie text,
HiddenGemScore text, CountryAvailability text, Runtime text, Director text, Writer text,
Actors text, ViewRating text, IMDbScore text, RottenTomatoesScore text, MetacriticScore 
text, AwardsReceived text, AwardsNominatedFor text, Boxoffice text, ReleaseDate text,
NetflixReleaseDate text, ProductionHouse text, NetflixLink text, IMDbLink text, Summary 
text, IMDbVotes text, Image text, Poster text, TMDbTrailer text, TrailerSite text);
insert into data_s (Title, Genre, Runtime, Director, Writer, Actors, ReleaseDate, IMDbScore) select Title, Genre, Runtime, Director, Writer, Actors, ReleaseDate, IMDbScore from InitialData where (IMDBScore > '7') and (SeriesOrMovie = 'Series');
insert into data_m (Title, Genre, Runtime, Director, Writer, Actors, ReleaseDate, IMDbScore) select Title, Genre, Runtime, Director, Writer, Actors, ReleaseDate, IMDbScore from InitialData where (IMDBScore > '7') and (SeriesOrMovie = 'Movie');

-- Начинаем заполнять наши таблицы 
-- Добавляем информацию о названиях фильмов и сериалов
insert into movies (title) select Title from data_m;
insert into series (title) select Title from data_s;

-- Отдельно добавляем актеров, режиссеров и сценаристов фильмов
insert into persons (person_name) select REGEXP_SPLIT_TO_TABLE(actors, ', ') from InitialData where (IMDBScore > '7');
insert into persons (person_name) select REGEXP_SPLIT_TO_TABLE(Director, ', ') from InitialData where (IMDBScore > '7');
insert into persons (person_name) select REGEXP_SPLIT_TO_TABLE(Writer, ', ') from InitialData where (IMDBScore > '7');

-- Добавляем информацию о жанрах
insert into genres (genre) select distinct REGEXP_SPLIT_TO_TABLE(genre, ', ') from InitialData where (IMDBScore > '7') and (genre is not null);

-- Также отдельно добавляем актеров, режиссеров и сценаристов в таблицу с кастом фильмов 
insert into movie_cast (movie_id, person_id, profession) select index_, person_id, 'actor' from (select index_, REGEXP_SPLIT_TO_TABLE(actors, ', ') as n from data_m) as v inner join persons on v.n = persons.person_name;
insert into movie_cast (movie_id, person_id, profession) select index_, person_id, 'director' from (select index_, REGEXP_SPLIT_TO_TABLE(director, ', ') as n from data_m) as v inner join persons on v.n = persons.person_name;
insert into movie_cast (movie_id, person_id, profession) select index_, person_id, 'writer' from (select index_, REGEXP_SPLIT_TO_TABLE(writer, ', ') as n from data_m) as v inner join persons on v.n = persons.person_name;

-- Добавляем жанры фильмов 
insert into movie_genre (movie_id,genre_id) select index_, genre_id from (select index_, REGEXP_SPLIT_TO_TABLE(genre, ', ') as n from data_m) as v inner join genres on v.n = genres.genre;

-- Добавляем информацию о структуре сериала 
insert into series_episodes (series_id, season, episodes, title_episode, title, episode_duration) select index_, 1, 1, title, title, runtime from data_s;

-- Добавляем актеров, режиссеров и сценаристов сериалов 
insert into series_cast (series_id, person_id, season, profession) select index_, person_id, 1, 'actor' from (select index_, REGEXP_SPLIT_TO_TABLE(actors, ', ') as n from data_s) as v inner join persons on v.n = persons.person_name;
insert into series_cast (series_id, person_id, season, profession) select index_, person_id, 1, 'director' from (select index_, REGEXP_SPLIT_TO_TABLE(director, ', ') as n from data_s) as v inner join persons on v.n = persons.person_name;
insert into series_cast (series_id, person_id, season, profession) select index_, person_id, 1, 'writer' from (select index_, REGEXP_SPLIT_TO_TABLE(writer, ', ') as n from data_s) as v inner join persons on v.n = persons.person_name;

-- Добавляем жанры сериалов 
insert into series_genre (series_id, genre_id) select index_, genre_id from (select index_, REGEXP_SPLIT_TO_TABLE(genre, ', ') as n from data_s) as v inner join genres on v.n = genres.genre;


