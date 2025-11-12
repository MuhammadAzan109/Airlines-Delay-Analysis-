✈️ Airline Flight Delay Analysis — Power BI Dashboard
📘 Project Overview

Flight delays are a significant challenge in the aviation industry — affecting passengers, operational efficiency, and overall costs.
This project explores U.S. airline flight delay data to uncover patterns, delay causes, and economic impact using SQL Server for data preparation and Power BI for visualization.

The goal was to build an interactive dashboard that helps identify:

Which airlines and airports experience the most delays

What causes those delays

How delay trends evolve across months and years

The financial impact of these delays

🎯 Business Objectives

Analyze flight delay trends and identify top contributors (airlines & airports).

Understand delay causes (carrier, weather, NAS, security, or late aircraft).

Quantify the economic impact of delays.

Discover time-based patterns — monthly and yearly trends.

Present findings through an interactive Power BI dashboard.

🧩 Dataset Description

Table Name: Cleaned_flights

Column	Description
year, month	Time of flight
carrier_name	Airline name
airport_name	Airport name
arr_flights	Total arriving flights
arr_del15	Flights delayed by 15+ minutes
arr_cancelled, arr_diverted	Canceled or diverted flights
carrier_delay, weather_delay, nas_delay, security_delay, late_aircraft_delay	Delay minutes by cause
arr_delay	Total delay minutes
🛠️ Tools & Technologies
Tool	Purpose
SQL Server	Data cleaning and transformation
Power BI	Dashboard design and visualization
Excel	Data exploration and formatting
DuckDB (Optional)	Lightweight SQL analysis in Python
DAX	KPIs and calculated measures
📊 Key Insights
🧮 KPI Summary

Total Flights: 32 Million

Delayed Flights: 6 Million

Overall Delay Percentage: 18.1%

Most Cancelled Flights: Southwest (75K), SkyWest (69K)

Highest Economic Impact: Southwest Airlines – $5 Billion (13.47%)

Most Diverted Flights: SkyWest – 1,149

⚙️ Performance & Delay Causes

Southwest Airlines shows the highest delay percentage (0.17).

Late Aircraft Delays are the most frequent cause — dominating 13 times more than others.

2019 recorded the highest total delay count — 19.4M delays.

🛫 Airport Insights

El Paso International (TX) ranks among the top 10 worst airports (173 delayed out of 381 flights).

Sanford FL (Orlando Sanford) has the longest average delay duration (203 mins).

July and August show the highest weather-related delays.

📈 Dashboard Pages Overview
Page	Description	Visual Types
1. KPI Overview	Summary of flights, delays, and costs	KPI cards, Donut charts
2. Performance & Delay Causes	Delay breakdown by carrier and cause	Bar chart, Composition Tree
3. Key Contributors	Top 10 worst airports, dominant delay types	Bubble chart, Column chart
4. Time Series Analysis	Delay trends by month/year	Line chart, Heatmap
5. Navigation Page	Overview & navigation buttons	Background image with bookmarks
🎨 Dashboard Highlights

Airline-themed background visuals and clean Power BI design

Interactive filtering by carrier, airport, and delay cause

Use of modern visuals: Composition Tree, Bubble Chart, KPI Cards, and Trend Lines

Dynamic tooltips and color-coded delay types

💡 Key Learnings

Designed SQL queries to uncover actionable insights from raw data.

Created dynamic measures and KPIs using DAX.

Applied data storytelling and visualization best practices in Power BI.

Integrated performance, time, and financial analysis into one cohesive dashboard.

📁 Project Files

flight_delay_queries.sql — All SQL queries used for analysis

Cleaned_flights.csv — Clean dataset (sample)

Flight_Delay_Dashboard.pbix — Power BI dashboard file

README.md — Project documentation

🧠 Future Improvements

Incorporate real-time flight data using APIs

Predict delays using machine learning models

Add regional/geospatial analysis via Power BI maps
