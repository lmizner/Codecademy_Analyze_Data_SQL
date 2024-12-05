CREATE TABLE friends(
  id INTEGER,
  name TEXT,
  birthday DATE
);

INSERT INTO friends (id, name, birthday)
VALUES (1, 'Ororo Munroe', '1940-05-30');

SELECT * 
FROM friends;

INSERT INTO friends (id, name, birthday)
VALUES (2, 'Lauren Mizner', '1994-05-08');

INSERT INTO friends (id, name, birthday)
VALUES (3, 'Brandon Hong', '1995-11-16');

SELECT *
FROM friends;

UPDATE friends
SET name = 'Storm'
WHERE id = 1;

SELECT * 
FROM friends;

ALTER TABLE friends
ADD COLUMN email TEXT;

UPDATE friends
SET email = 'storm@codecademy.com'
WHERE id = 1;

UPDATE friends
SET email = 'lmizner@123.com'
WHERE id = 2;

UPDATE friends 
SET email = 'bhong@123.com'
WHERE id = 3;

SELECT *
FROM friends;

DELETE FROM friends
WHERE id = 1;

SELECT *
FROM friends;
