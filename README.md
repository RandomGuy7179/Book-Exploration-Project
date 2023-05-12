# Book-Exploration-Project

Using Python,SQL, and Tableau to explore datasets about books from goodreads.

## Table of Contents
  - [Introduction](#Introduction)
  - [Set Up](#Set-Up)
  - [Data Exploration](#Data-Exploration)
  - [Tableau](#Tableau)

## Introduction
For this project, I wanted to explore datasets on books and see which books, authors, types of books, etc. were the highest ranked than others based on criteria such as rating, number of books, and 
number of pages. Doing this would provide me insightful information that I could use when picking my next book to read. For this project I used datasets from Kaggle that contain hundreds of thousands of rows of data for books from goodreads. These datasets contained information such as the name of the book, IBSN, author, number of pages, genre, rating, etc. I used python to concat the data by combining over 20 csv files into one big datset with over 800k rows. I then used SQL to explore the data. Finally, I visualized interesting information about the dataset in a tableau dashboard that focues on showing the top N books/authors/types of books by its rating/number of pages/number of books.

## Set Up
I used datasets from https://www.kaggle.com/datasets/mdhamani/goodreads-books-100k and      https://www.kaggle.com/datasets/b2dde9353c9d10c36e4d6b593a74c109dbaca6393a1ca0f2c7abafeba7633641 to create a consolidated datasets for the SQL portion on my project. In order to do this, I first needed to concat 23 csv files, each with hundreds of thousands of rows into one dataset. Using Python, I wrote code that looped through every csv file in a folder and checked to see if they met criteria for the columns I wanted to extract from them. If they did, I kept those tables and combined them at the end to make one large dataset with over 800k rows of data. You can view the code [here](https://github.com/RandomGuy7179/Book-Exploration-Project/blob/main/csv_concat.ipynb). From here, I moved onto SQL where I loaded in the table I had created as well as another one from Kaggle that I would use to join the the table I created later on.
## Data Exploration

## Tableau
