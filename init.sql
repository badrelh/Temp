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
('Inception', 2010, 'Sci-Fi', 'Christopher Nolan', 5, 'Chef-d''œuvre absolu', 'https://www.imdb.com/title/tt1375666/', 'https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_.jpg', 1),
('The Dark Knight', 2008, 'Action', 'Christopher Nolan', 5, 'Le meilleur film de super-héros', 'https://www.imdb.com/title/tt0468569/', 'https://m.media-amazon.com/images/M/MV5BMTMxNTMwODM0NF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_.jpg', 1),
('Interstellar', 2014, 'Sci-Fi', 'Christopher Nolan', 5, 'Une expérience cinématographique inoubliable', 'https://www.imdb.com/title/tt0816692/', 'https://m.media-amazon.com/images/M/MV5BZjdkOTU3MDktN2IxOS00OGEyLWFmMjktY2FiMmZkNWIyODZiXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_.jpg', 1),
('Pulp Fiction', 1994, 'Crime', 'Quentin Tarantino', 5, 'Dialogues exceptionnels', 'https://www.imdb.com/title/tt0110912/', 'https://m.media-amazon.com/images/M/MV5BNGNhMDIzZTUtNTBlZi00MTRlLWFjM2ItYzViMjE3YzI5MjljXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_.jpg', 1),
('The Shawshank Redemption', 1994, 'Drama', 'Frank Darabont', 5, 'Un classique intemporel', 'https://www.imdb.com/title/tt0111161/', 'https://m.media-amazon.com/images/M/MV5BNDE3ODcxYzMtY2YzZC00NmNlLWJiNDMtZDViZWM2MzIxZDYwXkEyXkFqcGdeQXVyNjAwNDUxODI@._V1_.jpg', 1);
