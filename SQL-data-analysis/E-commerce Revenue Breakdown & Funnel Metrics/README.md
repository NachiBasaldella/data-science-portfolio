📊 E-commerce Revenue Breakdown & Funnel Metrics
📌 Project Description

This project aims to analyze revenue and funnel metrics in an e-commerce environment using the public Olist dataset (available on Kaggle).
https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce?resource=download
The analysis is designed to answer key business questions such as:

-What is the revenue breakdown by product category, payment method, or customer location?

-How does the customer conversion funnel behave?

-Which metrics provide insights into profitability, cancellations, and repeat purchases?

📂 Dataset: Brazilian E-Commerce Public Dataset by Olist

I chose this dataset because it is real, complete, and relational, making it an excellent resource for SQL analysis. It contains about 100,000 orders placed between 2016 and 2018 in Brazil, organized into 9 CSV tables that simulate a transactional database:

Customers → customer data (ID, city, state).

Orders → order information (status, timestamps, delivery dates).

Order Items → products within each order (price, seller, freight).

Payments → payment methods and values.

Products → product categories and attributes.

Sellers → seller information (location, ID).

Geolocation → ZIP codes, latitude, longitude, city, state.

Reviews → customer reviews and scores.

Category Translations → translations of product categories.

📌 Why this dataset?

It allows complex joins across multiple tables.

It provides a full e-commerce ecosystem: customers, orders, payments, products, sellers, reviews.

Available in CSV and SQLite, easy to integrate with SQL workflows.

🎯 Analysis Objectives

Revenue Breakdown

Total revenue by product category.

Revenue by customer state or city.

Payment method analysis.

Average Order Value (AOV).

Funnel Metrics

Conversion rates: orders created → approved → delivered.

Order cancellations and delivery delays.

Customer repeat purchase rate.

Additional Insights

Impact of reviews on sales.

Geographical distribution of customers and sellers.

Identification of most profitable and highest-rated categories.

🛠️ Tools & Technologies

SQL (PostgreSQL / SQLite / MySQL) → queries and joins across tables.

Python (Pandas, Matplotlib/Seaborn) → analysis and visualization.


🚀 Expected Outcomes

By the end of this project, we expect to:

Deliver a clear breakdown of e-commerce revenue.

Measure and visualize conversion rates in the funnel.

Identify purchase, cancellation, and satisfaction patterns.

Develop reusable SQL queries for e-commerce analytics.
<img width="763" height="783" alt="image" src="https://github.com/user-attachments/assets/bcabd6a9-e662-4274-ae58-224bef4aa0be" />

