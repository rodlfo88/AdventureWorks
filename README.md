I’d like to share a personal project I worked on using the Microsoft AdventureWorks database, which simulates a wholesale bicycle business model. The goal was to build a complete data analysis pipeline using SQL, Python (NumPy and Pandas), and Power BI.

I started with SQL to explore the database, understand its structure and the underlying business logic. I wrote a wide range of queries:

Business logic queries to understand relationships between tables and segment information by product, sales region, etc.

Analytical queries to analyze historical data, identify trends, outliers, and extract strategic insights.

Then, I moved to Jupyter Notebook with Python, using NumPy and Pandas to:

Detect outliers in sales and pricing.

Analyze trends and seasonality.

Build a simple automated data cleaning pipeline (clean, filter, transform).

After that, I used Power BI for data modeling and visualization:

I created DAX measures such as Total Sales Amount, Total Cost, Gross Profit, and Sales Year to Date.

I also applied transformations in Power Query (M) like:

Removing null values.

Adding conditional columns.

Extracting the year from date columns.

Combining name fields.

Finally, I created a Power BI report with five main pages:

Tab	Content	Type of Visualizations
Overview	General KPIs: total sales, margin	Cards, bar chart, line chart
Sales by Product	Ranking, sales and margin by product	Table, bar chart, scatter plot
Sales Trends	Trend and YoY growth analysis	Line charts, year slicers
Region Analysis	Sales and margin by geographic region	Maps, column charts
Reseller Segment	Reseller segmentation and sales	Slicers, tables, bar charts

This project allowed me to develop end-to-end data analysis skills — from exploration to storytelling — and to strengthen both my technical and analytical abilities.

While I’m not an expert yet and I don’t know every line of code by heart, I do understand the logic behind each step: how to clean, transform, and analyze the data to generate business insights.
