# Book-Exploration-Project

Using Python,SQL, and Tableau to explore datasets about books from goodreads.

## Table of Contents
  - [Introduction](#Introduction)
  - [Set Up](#Set-Up)
  - [Data Exploration](#Data-Exploration)
  - [Tableau](#Tableau)

## Introduction
For this project, I wanted to explore datasets on books and see which books, authors, types of books, etc. were the highest ranked based on criteria such as rating, number of books, and 
number of pages. Doing this would provide me insightful information that I could use when picking my next book to read. For this project I used datasets from Kaggle that contain hundreds of thousands of rows of data for books from goodreads. These datasets contained information such as the name of the book, IBSN, author, number of pages, genre, rating, etc. I used python to concat the data by combining over 20 csv files into one big datset with over 800k rows. I then used SQL to explore the data. Finally, I visualized interesting information about the dataset in a tableau dashboard that focues on showing the top N books/authors/types of books by its rating/number of pages/number of books.

## Set Up
I used datasets from https://www.kaggle.com/datasets/mdhamani/goodreads-books-100k and https://www.kaggle.com/datasets/b2dde9353c9d10c36e4d6b593a74c109dbaca6393a1ca0f2c7abafeba7633641 to create a consolidated dataset for the SQL portion on my project. In order to do this, I first needed to concat 23 csv files, each with hundreds of thousands of rows into one dataset. Using Python, I wrote code that looped through every csv file in a folder and checked to see if they met criteria for the columns I wanted to extract from them. If they did, I kept those tables and combined them at the end to make one large dataset with over 800k rows of data. You can view the code [here](https://github.com/RandomGuy7179/Book-Exploration-Project/blob/main/csv_concat.ipynb). From here, I moved onto 
SQL where I loaded in the table I had created as well as another one from Kaggle that I would use to join the the table I created later on.

## Data Exploration
For my data exploration, I used several stored procedure to have reusable code that I could use in the future to get quick information about a specific author, publisher, and year. My stored procedures queried that data to return the top 10 book (based on rating and the number of reviews for the book being more than 100) for every author, publisher, and year in the dataset. For example, say you wanted to see the top  10 highest rated books by Stephen King. Using "CALL get_authors_top_10('Stephen King') would allow you to see a query of the number of pages, publisher, publish year, rating, and number of reviews of the top 10 highest rated books by Stephen King in the dataset.

  I also wanted to explore the dataset based on type of book. I used a CASE statement to create a new column in the dataset that would bin a book into "Audiobook", "Short Read", "Medium Read" and "Long Read" based on the number of pages of the book. With this new column, I was able to see the highest rated books in the dataset by the type of read. In the future I can now pick a highly rated book to read based on whether I want to listen to an audiobook or read a lengthy book.
  
  I was interested in also average book ratings based on a criteria. Therfore, I queried the dataset to gather insights on columns such as the average book rating for publishers and the average rating of types of books. With these queries, I saw how publishers or types of books compared against each other. I applied other similar types of queries to gather more insights on different facets of the data based on book ratings. You can view my SQL code [here](https://github.com/RandomGuy7179/Book-Exploration-Project/blob/main/Books.sql)
  
  Finally, I wanted to use a dataset that contained information on genres and join it to the big dataset that I had created with python. By joining on ISBN number, I obtained a new [table](https://github.com/RandomGuy7179/Book-Exploration-Project/blob/main/ISBN_only.xlsx) that contained 8392 books with valid IBSNs and genres. Using this new table, I went back to Python and created a new [table](https://github.com/RandomGuy7179/Book-Exploration-Project/blob/main/genre_count.xlsx) that contains a column of all the unique genres found in the dataset and another column with the number of times that genre was found. You can view the code used to create the table [here](https://github.com/RandomGuy7179/Book-Exploration-Project/blob/main/data_prep_for_tableau.ipynb). This table and the table created with 8392 books were used to create a Tableau dashboard.

## Tableau

With the tables I created I moved onto Tableau and created a dashboard that allows the user to filter the visuals by the top genres,books, and authors. I used visual such as a piechart, barcharts, packed bubbles, and treemap to allow viewers to easily see what book or author was rated higher based on a criteria. You can view the dashboard [here](https://public.tableau.com/app/profile/hector.penado.jr/viz/BookDashboard_16825705155710/Dashboard1).
