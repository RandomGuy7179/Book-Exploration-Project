/* Creating table that contains data from https://www.kaggle.com/datasets/bahramjannesarr/goodreads-book-datasets-10m */
CREATE TABLE combined (
  Title VARCHAR(255),
  pagesNumber INT,
  Publisher VARCHAR(255),
  PublishYear INT,
  Language VARCHAR(255),
  Author VARCHAR(255),
  Rating INT,
  Count_reviews FLOAT, 
  ISBN VARCHAR(255)
);

/* changing the title of language column to lang because language is a reserved row in mysql which I didn't know. */
ALTER TABLE combined
RENAME COLUMN Language TO Lang;

/* fixing incorrect headers and data types of columns from original table */
ALTER TABLE combined
RENAME COLUMN Rating TO count_reviews,
RENAME COLUMN Count_reviews TO Rating;



/* Creating table that contains data from https://www.kaggle.com/datasets/mdhamani/goodreads-books-100k */
CREATE TABLE 100k (
  author VARCHAR(255),
  bookformat VARCHAR(255),
  description VARCHAR(255),
  genre VARCHAR(255),
  img VARCHAR(255),
  isbn VARCHAR(255), 
  isbn13 VARCHAR(255),
  link VARCHAR(255),
  pages INT,
  rating FLOAT,
  reviews INT,
  title VARCHAR(255),
  totalRatings INT
);

/*EXPLORING THE DATA */

/* Created a stored procedure to get the top 10 highest rated books of an author you input */
CREATE PROCEDURE get_authors_top_10(IN auth VARCHAR(255))
BEGIN
  SELECT * 
  FROM combined 
  WHERE Author = auth AND Lang = 'eng' AND (ISBN IS NOT NULL AND LENGTH(ISBN) > 0) AND count_reviews >= 100 
  /* Note that in the WHERE clause above, I am only interested in books in English, with ISBN numbers, and more than 100 reviews. I would personally be inclined to trust the ratings where at least 100 people provided reviews. */
  /* This criteria applies to the other stored procedures below */
  ORDER BY Rating DESC
  LIMIT 10;
END;

CALL get_authors_top_10('Stephen King');

/* END OF THIS PROCEDURE */

/* Created a stored procedure to get the top 10 highest rated books of a publsher you input */
CREATE PROCEDURE get_publishers_top_10(IN pub VARCHAR(255))
BEGIN
  SELECT * 
  FROM combined 
  WHERE Publisher = pub AND Lang = 'eng' AND (ISBN IS NOT NULL AND LENGTH(ISBN) > 0) AND count_reviews >= 100
  ORDER BY Rating DESC
  LIMIT 10;
END;

CALL get_publishers_top_10('University of California Press');

/* END OF THIS PROCEDURE */


/* Create a stored procedure to get the top 10 highest rated boks of a year you input */
CREATE PROCEDURE get_year_top_10(IN yr INT)
BEGIN
  SELECT * 
  FROM combined 
  WHERE PublishYear = yr AND Lang = 'eng' AND (ISBN IS NOT NULL AND LENGTH(ISBN) > 0) AND count_reviews >= 100
  ORDER BY Rating DESC
  LIMIT 10;
END;

CALL get_year_top_10(1984);

/* END OF THIS PROCEDURE */


/* I want to now get the top 10 highest rated books based on bins for page numbers. I want the best rated books for books between 0-100 pages, 101 - 200 pages, etc.
   To do this, I first want to look at the book with the lowest/highest number of pages as well as the average number of pages for all books*/

/*book with min number of pages */
SELECT * 
FROM combined 
WHERE pagesNumber = (SELECT MIN(pagesNumber) FROM combined) AND  LENGTH(ISBN) > 0;
 /* books with 0 pages are audio books. */
 
 /*book with max number of pages */
SELECT * 
FROM combined 
WHERE pagesNumber = (SELECT MAX(pagesNumber) FROM combined) AND  LENGTH(ISBN) > 0;
/* book with biggest number of pages is '425 Heartwarmin' Expressions For Crafting, Painting, Stitching & Scrapbooking. Book # 1' with 4517845 pages! */
  
/* Average number of pages of the books in this dataset */
  
SELECT AVG(pagesNumber) FROM combined; /* The average number of pages in this dataset is about 280 pages. */
  
/* Using the knowledge above, I've decided to bin the number of pages of books into audiobooks, short books (1-279 pages), medium books (280-560 pages) long books (561+ pages) */

/*creating a new column type_of_read which will contain info on whether a book is an audiobook, short read, medium read, or long read. */
ALTER TABLE combined
ADD COLUMN type_of_read VARCHAR(50);

UPDATE combined
SET type_of_read = CASE
  WHEN pagesNumber = 0 THEN 'Audiobook'
  WHEN pagesNumber >= 1 AND pagesNumber <= 279 THEN 'Short Read'
  WHEN pagesNumber >= 280 AND pagesNumber <= 560 THEN 'Medium Read'
  ELSE 'Long Read'
END; /* CASE statement checks the number of pages in each book in the dataset to determine in which of the 4 categories it belongs in. */

/* Now I can looks at ratings based on the length of a book. */
 SELECT * 
 FROM combined 
 WHERE type_of_read = 'Medium Read' AND count_reviews >= 100 AND Lang = 'eng'
 ORDER BY Rating DESC 
 LIMIT 50;
 
 
 /* With this query I am able to look at the top 10 higest rated books for each of the 4 types of reads in the type_of_read column */
 SELECT type_of_read, Title, Rating, row_num
 FROM (SELECT type_of_read, Title, Rating, ROW_NUMBER() OVER(PARTITION BY type_of_read ORDER BY Rating DESC) as row_num
       FROM combined
       WHERE Lang = 'eng' AND count_reviews >= 100  AND (ISBN IS NOT NULL AND LENGTH(ISBN) > 0)
       ) AS c
 WHERE row_num <= 10;

/* This query lets me see the average rating of each type_of_read */
SELECT type_of_read, AVG(Rating) AS average_rating
FROM combined
WHERE count_reviews >= 100  AND (ISBN IS NOT NULL AND LENGTH(ISBN) > 0)
GROUP BY type_of_read
ORDER BY average_rating DESC

/* Deleted 'The Montauk File: Unearthing the Phoenix Conspiracy ,192' because it had a rating of 1561840000 which is incorrect */
DELETE FROM combined WHERE Title = 'The Montauk File: Unearthing the Phoenix Conspiracy ,192';

/*This query lets me see the average rating of books for every year in the PublishYear column */
SELECT PublishYear, AVG(Rating) AS average_rating
FROM combined
WHERE count_reviews >= 100  AND (ISBN IS NOT NULL AND LENGTH(ISBN) > 0)
GROUP BY PublishYear
ORDER BY average_rating DESC

/* With this query I can see the top 5 highest rating books (in descending order) for every year in the PublishYear column. */
SELECT PublishYear, Title,Rating, row_num
FROM(
  SELECT *, ROW_NUMBER() OVER(PARTITION BY PublishYear ORDER BY Rating DESC) AS row_num
  FROM combined
  WHERE Lang = 'eng' AND count_reviews >= 100  AND (ISBN IS NOT NULL AND LENGTH(ISBN) > 0)
  ) AS c
WHERE row_num <= 5
ORDER BY PublishYear, Rating DESC


 

/*This query allows me to see a list of authors with an average rating of at least 4 from highest rated to lowest rated */
SELECT Author, ROUND(AVG(Rating),2) AS average_rating
FROM combined
WHERE Lang = 'eng' AND count_reviews >= 100  AND (ISBN IS NOT NULL AND LENGTH(ISBN) > 0)
GROUP BY Author
HAVING average_rating >= 4.0
ORDER BY average_rating DESC


/* want to create views where books without ISBNs are ommited */

CREATE OR REPLACE VIEW combined_ISBN_only AS (
  SELECT * FROM combined WHERE LENGTH(ISBN) > 0
  )
  
CREATE OR REPLACE VIEW 100k_ISBN_only AS (
  SELECT * FROM 100k WHERE LENGTH(isbn) > 0
  ) 

/*There are 8392 books that are found in both the combined and 100k datasets based on ISBN and book title */
CREATE TABLE ISBN_only AS(
  SELECT 100k_isbn_only.*, combined_isbn_only.Lang, combined_isbn_only.count_reviews, combined_isbn_only.type_of_read, combined_isbn_only.Rating as Rating2
  FROM 100k_isbn_only
  JOIN combined_isbn_only ON 100k_isbn_only.isbn = combined_ISBN_only.ISBN AND 100k_isbn_only.title = combined_isbn_only.Title
  )
  
 /*This is the table I am going to use to create visuals in Tableau */
 SELECT * FROM ISBN_only
 
