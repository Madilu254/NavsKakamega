CREATE DATABASE IF NOT EXISTS studentperformance;

USE studentperformance;

CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    firstname VARCHAR(100),
    lastname VARCHAR(100),
    email VARCHAR(150),
    username VARCHAR(100) UNIQUE,
    password VARCHAR(100)
);
