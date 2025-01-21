# cyclistic-bike-share
 
Bike Share Data Analysis

**Overview**

 This repository contains SQL scripts and RMarkdown files for analyzing bike share data from 2023. The analysis focuses on combining, cleaning, and exploring ride patterns, user behavior,   and key metrics to generate actionable insights.

**Files**

**1. **bike_share_queries**.sql**

** Description:** A collection of SQL queries for performing data cleaning, transformation, and analysis on bike share data.

**Key Features:**
 
  Combining monthly data into a single fiscal year table (2023_FY_tripdata).
  
  Cleaning the data by removing duplicates, handling missing values, and excluding invalid ride lengths.
  
  Adding day names and categorizing data for analysis.
  
  Analysis queries include:
  
  Daily ride patterns.
  
  Peak usage times.
  
  Popular routes and stations.
  
  Seasonal usage trends.
  
  Short vs. long ride analysis.
  
  Weekend vs. weekday usage.
  
  Round trip analysis.
  
  User behavior during peak/off-peak hours.

**How to Use:**

 Load the SQL file into your database tool (e.g., BigQuery, MySQL Workbench).
 
 Execute the queries step-by-step based on your analysis needs.

**2. bike_share_analysis.Rmd**

** Description: **An RMarkdown file providing an interactive and reproducible analysis of bike share data using R. It includes data exploration, visualization, and summary statistics.

**Key Features:**

 Loading and preprocessing the data.
 
 Visualization of ride patterns by user type, day, hour, and bike type.
 
 Detailed hourly, monthly, and bike type usage analysis.
 
 Exporting summary statistics to CSV.

**How to Use:**

 Open the .Rmd file in RStudio.
 
 Install required packages (tidyverse, lubridate, ggplot2).
 
 Knit the file to generate an HTML report or run chunks interactively.

**Prerequisites**

**SQL File:**

  Access to a database system that supports the SQL queries (e.g., BigQuery, MySQL).
  
  Download the data from https://divvy-tripdata.s3.amazonaws.com/index.html for the 12 months of 2023 (The data has been made available by Motivate International Inc. under this license.)

**RMarkdown File:**

  RStudio with R version 4.0 or later.
  
  Required libraries: tidyverse, lubridate, ggplot2.

**How to Run the Analysis**

**SQL Analysis:**
  
  Import the monthly bike share data into your database.
  
  Execute the bike_share_queries.sql script to clean and analyze the data.

**RMarkdown Analysis:**

  Place the cleaned data file (2023_FY_tripdata.csv) in the correct directory.
  
  Run the RMarkdown file for detailed visualizations and additional insights.

**Outputs**

SQL Outputs:

 Summary statistics and intermediate tables stored in the database.
 
 Results can be exported as CSV files for further analysis.

RMarkdown Outputs:

 Interactive HTML report with visualizations.
 
 CSV file containing summary statistics.
