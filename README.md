# SQL Superstore Data Management and Reporting

## Overview

This repository contains SQL code for managing and analyzing data extracted from an Excel sheet for a sample superstore. The project involves transforming and loading data into MySQL tables, allowing users to create executive reports comparing sales values for the years 2020 and 2021. The executive report table includes the following columns:

- Region
- Manager
- State
- Sales (2020) $
- Sales (2021) $
- Sales 2021 Vs 2020 ($)
- KPI Participation 2020 (%)
- KPI Participation 2021 (%)
- Profit (2020) $
- Profit (2021) $

## Data Sources

The main data source for this project is an Excel sheet containing three main sheets: "Orders," "People," and "Returns." These sheets were exported to CSV files and used as the basis for creating the MySQL tables.

## Repository Contents

- **sql_superstore_2.sql**: This file contains the SQL code used to create the MySQL tables and load data from the CSV files.

## Instructions

To use this repository, follow these steps:

1. Create a MySQL database and connect to it.

2. Run the SQL code provided in `Executive_Report.sql` to set up the necessary tables and load data from the CSV files.

3. Once the data is loaded, you can run SQL queries to generate the executive report with the desired comparisons and metrics.

## Database Structure

- `superstore_data`: Contains the main data related to orders, customers, and products.
- `People`: Stores information about regional managers and regions.
- `Customers`: Maintains the mapping between alphanumeric customer IDs and integer keys.
- `Products`: Maintains the mapping between alphanumeric product IDs and integer keys.
- `Orders`: Contains order details with integer foreign keys for customer and region.
- `Order_items`: Contains data about items within orders.
- `Returns`: Stores information about returned orders.

## Executive Report

To generate the executive report comparing sales values in 2020 and 2021, the SQL code in `sql_superstore_2.sql` includes a detailed query that calculates the required metrics and organizes the data into a report format.


## Feedback and Issues

If you encounter any issues or have suggestions for improvements, please feel free to open an issue on this GitHub repository.
