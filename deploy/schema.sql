-- Tables used by the app and scrapers (from sprint1 create-db scripts and auth/create_auth_db.py).
-- Database names must match DB_NAME_JCDECAUX, DB_NAME_WEATHER and DB_NAME_AUTH in the env file.

CREATE DATABASE IF NOT EXISTS local_databasejcdecaux;
CREATE DATABASE IF NOT EXISTS local_databaseopenweather;
CREATE DATABASE IF NOT EXISTS dublin_bikes_auth DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE local_databasejcdecaux;

CREATE TABLE IF NOT EXISTS station (
    number INTEGER NOT NULL PRIMARY KEY,
    address VARCHAR(256),
    banking INTEGER,
    bike_stands INTEGER,
    name VARCHAR(256),
    position_lat FLOAT,
    position_lng FLOAT,
    status VARCHAR(256)
);

CREATE TABLE IF NOT EXISTS availability (
    number INTEGER NOT NULL,
    available_bikes INTEGER,
    available_bike_stands INTEGER,
    last_update DATETIME NOT NULL,
    status VARCHAR(256),
    PRIMARY KEY (number, last_update)
);

USE local_databaseopenweather;

CREATE TABLE IF NOT EXISTS current (
    dt DATETIME NOT NULL,
    feels_like FLOAT,
    humidity INTEGER,
    pressure INTEGER,
    sunrise DATETIME,
    sunset DATETIME,
    temp FLOAT,
    weather_id INTEGER,
    wind_speed FLOAT,
    wind_gust FLOAT,
    rain_1h FLOAT,
    snow_1h FLOAT,
    PRIMARY KEY (dt)
);

CREATE TABLE IF NOT EXISTS hourly (
    dt DATETIME NOT NULL,
    future_dt DATETIME NOT NULL,
    feels_like FLOAT,
    humidity INTEGER,
    pop FLOAT,
    pressure INTEGER,
    temp FLOAT,
    weather_id INTEGER,
    wind_speed FLOAT,
    wind_gust FLOAT,
    rain_3h FLOAT,
    snow_3h FLOAT,
    PRIMARY KEY (dt, future_dt)
);

USE dublin_bikes_auth;

CREATE TABLE IF NOT EXISTS users (
    id            INT          NOT NULL AUTO_INCREMENT,
    full_name     VARCHAR(120) NOT NULL,
    email         VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
