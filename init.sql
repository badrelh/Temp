-- Movies Interface Database Schema and Sample Data
-- Run this file to initialize your database

-- Create database
CREATE DATABASE IF NOT EXISTS movies_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE movies_db;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(80) NOT NULL UNIQUE,
    display_name VARCHAR(120) NOT NULL,
    password_hash VARCHAR(256) NOT NULL
);

-- Create movies table
CREATE TABLE IF NOT EXISTS movies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    year INT NOT NULL,
    genre VARCHAR(100) NOT NULL,
    director VARCHAR(150) NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review TEXT,
    imdb_link VARCHAR(300),
    poster_url VARCHAR(500),
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Insert sample user (password: 'password123')
-- Hash generated with Werkzeug's generate_password_hash
INSERT INTO users (username, display_name, password_hash) VALUES
('badr', 'Badr', 'scrypt:32768:8:1$qd4fH95Yl7v7dYYw$ff439df859893b0397ec6a6652f2c0c0b02a19a5c84df6ac533c17fa5b98a50238cdbf8b6211cda3d0a48bf76c2fb5e21bec36a196f56c981754dd1ab43870a6');

-- Note: To create your own user with a different password, generate a hash using Python:
-- from werkzeug.security import generate_password_hash
-- print(generate_password_hash('your_password'))

-- Insert sample movies for user badr (user_id = 1)
INSERT INTO movies (title, year, genre, director, rating, review, imdb_link, poster_url, user_id) VALUES
('Inception', 2010, 'Sci-Fi', 'Christopher Nolan', 5, 'Chef-d''œuvre absolu ! Nolan au sommet de son art', 'https://www.imdb.com/title/tt1375666/', 'https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_SX300.jpg', 1),

('Interstellar', 2014, 'Sci-Fi', 'Christopher Nolan', 5, 'Émotionnellement puissant, visuellement époustouflant', 'https://www.imdb.com/title/tt0816692/', 'https://m.media-amazon.com/images/M/MV5BZjdkOTU3MDktN2IxOS00OGEyLWFmMjktY2FiMmZkNWIyODZiXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SX300.jpg', 1),

('Parasite', 2019, 'Thriller', 'Bong Joon-ho', 5, 'Palme d''Or méritée, critique sociale brillante', 'https://www.imdb.com/title/tt6751668/', 'https://m.media-amazon.com/images/M/MV5BYWZjMjk3ZTItODQ2ZC00NTY5LWE0ZDYtZTI3MjcwN2Q5NTVkXkEyXkFqcGdeQXVyODk4OTc3MTY@._V1_SX300.jpg', 1),

('Good Will Hunting', 1997, 'Drama', 'Gus Van Sant', 5, 'Robin Williams exceptionnel, très touchant', 'https://www.imdb.com/title/tt0119217/', 'https://m.media-amazon.com/images/M/MV5BOTI0MzcxMTYtZDVkMy00NjY1LTgyMTYtZmUxN2M3NmQ2NWJhXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_SX300.jpg', 1),

('Your Name', 2016, 'Animation', 'Makoto Shinkai', 5, 'Animation magnifique, histoire émouvante', 'https://www.imdb.com/title/tt5311514/', 'https://m.media-amazon.com/images/M/MV5BODRmZDVmNzUtZDA4ZC00NjhkLWI2M2UtN2M0ZDIzNDcxYThjL2ltYWdlXkEyXkFqcGdeQXVyNTk0MzMzODA@._V1_SX300.jpg', 1),

('Top Gun: Maverick', 2022, 'Action', 'Joseph Kosinski', 4, 'Suite réussie, Tom Cruise toujours au top', 'https://www.imdb.com/title/tt1745960/', 'https://m.media-amazon.com/images/M/MV5BZWYzOGEwNTgtNWU3NS00ZTQ0LWJkODUtMmVhMjIwMjA1ZmQwXkEyXkFqcGdeQXVyMjkwOTAyMDU@._V1_SX300.jpg', 1),

('John Wick', 2014, 'Action', 'Chad Stahelski', 4, 'Action chorégraphiée à la perfection', 'https://www.imdb.com/title/tt2911666/', 'https://m.media-amazon.com/images/M/MV5BMTU2NjA1ODgzMF5BMl5BanBnXkFtZTgwMTM2MTI4MjE@._V1_SX300.jpg', 1),

('Breaking Bad', 2008, 'Crime', 'Vince Gilligan', 5, 'LA série parfaite, Walter White iconique', 'https://www.imdb.com/title/tt0903747/', 'https://m.media-amazon.com/images/M/MV5BMjhiMzgxZTctNDc1Ni00OTIxLTlhMTYtZTA3ZWFkODRkNmE2XkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_SX300.jpg', 1),

('Sherlock', 2010, 'Crime', 'Mark Gatiss', 5, 'Benedict Cumberbatch parfait en Holmes', 'https://www.imdb.com/title/tt1475582/', 'https://m.media-amazon.com/images/M/MV5BMWY3NTljMjEtYzRiMi00NWM2LTkzNjItZTVmZjE0MTdjMjJhL2ltYWdlL2ltYWdlXkEyXkFqcGdeQXVyNTQ4NTc5OTU@._V1_SX300.jpg', 1),

('Dans leur regard', 2019, 'Crime', 'Ava DuVernay', 5, 'Série bouleversante sur l''injustice raciale', 'https://www.imdb.com/title/tt7909314/', 'https://m.media-amazon.com/images/M/MV5BZmJjYWMwNDMtZGEzNy00OTkyLTgyNzktOTUxMWEzMGYyZWYzXkEyXkFqcGdeQXVyMjM4NTM5NDY@._V1_SX300.jpg', 1),

('Dark', 2017, 'Sci-Fi', 'Baran bo Odar', 5, 'Complexe et brillant, meilleure série Netflix', 'https://www.imdb.com/title/tt5753856/', 'https://m.media-amazon.com/images/M/MV5BOTk2NzUyOTctZDVjNy00OWQ0LWJhYWYtMDk1YjhmZjE5YTdhXkEyXkFqcGdeQXVyMjg1NDcwNjM@._V1_SX300.jpg', 1),

('Dexter', 2006, 'Crime', 'James Manos Jr.', 4, 'Concept unique, Michael C. Hall excellent', 'https://www.imdb.com/title/tt0773262/', 'https://m.media-amazon.com/images/M/MV5BZjkxM2JkNzMtMGFhYi00N2UyLWJmMWEtOTcyZGI0OWJhNmE0XkEyXkFqcGdeQXVyMTY3MDMxMzU@._V1_SX300.jpg', 1),

('Daredevil', 2015, 'Action', 'Drew Goddard', 5, 'Meilleure série Marvel, très sombre', 'https://www.imdb.com/title/tt3322312/', 'https://m.media-amazon.com/images/M/MV5BODcwOTg1Njk2NV5BMl5BanBnXkFtZTgwNTA2NDE0NzM@._V1_SX300.jpg', 1),

('The Last of Us', 2023, 'Horror', 'Craig Mazin', 5, 'Adaptation fidèle et émouvante du jeu', 'https://www.imdb.com/title/tt3581920/', 'https://m.media-amazon.com/images/M/MV5BZGUzYTI3M2EtZmM0Yy00NGUyLWI4ODEtN2Q3ZGJlYzhhZjU3XkEyXkFqcGdeQXVyNTM0OTY1OQ@@._V1_SX300.jpg', 1),

('Prison Break', 2005, 'Action', 'Paul Scheuring', 4, 'Première saison excellente, puis déclin', 'https://www.imdb.com/title/tt0455275/', 'https://m.media-amazon.com/images/M/MV5BMTg3NTkwNzAxOF5BMl5BanBnXkFtZTcwMjM1NjI5MQ@@._V1_SX300.jpg', 1),

('Narcos', 2015, 'Crime', 'Chris Brancato', 4, 'Wagner Moura incroyable en Escobar', 'https://www.imdb.com/title/tt2707408/', 'https://m.media-amazon.com/images/M/MV5BMTU0ODQ4NDg2OF5BMl5BanBnXkFtZTgwNzczNTE4OTE@._V1_SX300.jpg', 1),

('Suits', 2011, 'Drama', 'Aaron Korsh', 4, 'Dialogues percutants, Harvey et Mike duo parfait', 'https://www.imdb.com/title/tt1632701/', 'https://m.media-amazon.com/images/M/MV5BNmVmMmM5ZmItZDg0OC00NTFiLWIxNzctZjNmYTY5OTU3ZWU3XkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_SX300.jpg', 1),

('Peaky Blinders', 2013, 'Crime', 'Steven Knight', 4, 'Cillian Murphy charismatique, ambiance unique', 'https://www.imdb.com/title/tt2442560/', 'https://m.media-amazon.com/images/M/MV5BZjYzZDgzMmYtYjY5Zi00YTk1LThhMDYtNjFlNzM4MTZhYzgyXkEyXkFqcGdeQXVyMTE5NDQ1MzQ3._V1_SX300.jpg', 1),

('Bodyguard', 2018, 'Thriller', 'Jed Mercurio', 4, 'Tension constante, Richard Madden excellent', 'https://www.imdb.com/title/tt7493974/', 'https://m.media-amazon.com/images/M/MV5BOTZlMWI3ZDctOWFiMy00MjE5LWE0NzgtMzc1NzNlYWE2YTNkXkEyXkFqcGdeQXVyMTkxNjUyNQ@@._V1_SX300.jpg', 1),

('Presumed Innocent', 2024, 'Crime', 'David E. Kelley', 4, 'Jake Gyllenhaal solide, intrigue bien menée', 'https://www.imdb.com/title/tt15398776/', 'https://m.media-amazon.com/images/M/MV5BM2YzNzlhMmEtOWY1Ni00ZWFkLWJjOWEtYTVlMWFiMGE0YjdmXkEyXkFqcGdeQXVyMTY3ODkyNDkz._V1_SX300.jpg', 1),

('Les Soprano', 1999, 'Crime', 'David Chase', 5, 'En cours de visionnage (S1E4)', 'https://www.imdb.com/title/tt0141842/', 'https://m.media-amazon.com/images/M/MV5BZGJjYzhjYTYtMDBjYy00OWU1LTg5OTYtNmYwOTZmZjE3ZDdhXkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_SX300.jpg', 1),

('Ted Lasso', 2020, 'Comedy', 'Bill Lawrence', 4, 'En cours de visionnage (S2E2)', 'https://www.imdb.com/title/tt10986222/', 'https://m.media-amazon.com/images/M/MV5BMDVjNjIwOGUtNDE3Ni00ODE0LWE2MTEtZmY4YjQyZGJjMzhhXkEyXkFqcGdeQXVyMTM1MTE1NDMx._V1_SX300.jpg', 1),

('Arrow', 2012, 'Action', 'Greg Berlanti', 4, 'En cours de visionnage (S7E1)', 'https://www.imdb.com/title/tt2193021/', 'https://m.media-amazon.com/images/M/MV5BMTQ5MzAzOTIxM15BMl5BanBnXkFtZTgwMjcwNzM0NzM@._V1_SX300.jpg', 1);
