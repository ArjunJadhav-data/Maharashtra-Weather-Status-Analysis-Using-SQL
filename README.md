# 🌦️ Maharashtra Weather Analysis — SQL Project

<div align="center">

```
  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
  ░░  DECODING THE SKIES OF MAHARASHTRA  ░░░░░░░░
  ░░  One SQL query at a time.           ░░░░░░░░
  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
```

![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Window%20Functions-orange?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge)
![Domain](https://img.shields.io/badge/Domain-Weather%20Analytics-blue?style=for-the-badge)

</div>

---

## ☁️ What Is This Project?

A deep-dive into Maharashtra's climate data using **pure SQL**.  
No Python. No dashboards. Just well-crafted queries that tell the story of Maharashtra's weather — city by city, month by month, day by day.

> *"Give me a SQL query and I'll tell you if it's going to rain in Pune."*

---

## 📦 Dataset at a Glance

| Column | Type | Description |
|--------|------|-------------|
| `dates` | DATE | Weather record date |
| `city` | TEXT | Maharashtra city name |
| `avg` | FLOAT | Average temperature (°C) |
| `tmin` | FLOAT | Minimum temperature (°C) |
| `max` | FLOAT | Maximum temperature (°C) |
| `precipitation` | FLOAT | Rainfall amount (mm) |
| `windSpeed` | FLOAT | Wind speed |
| `pressure` | FLOAT | Atmospheric pressure |
| `tsun` | FLOAT | Sunshine duration |
| `years` | INT | Year |
| `months` | INT | Month (1–12) |
| `days` | INT | Day |

---

## 🔍 Analysis Breakdown

### 🧱 Foundation Queries (1–17)
> *Know your data before you ask it anything.*

```sql
-- Total records
SELECT COUNT(*) AS total_records FROM weather;

-- Hottest ever recorded
SELECT MAX(max) AS highest_temp FROM weather;

-- Coldest ever recorded
SELECT MIN(tmin) AS lowest_temp FROM weather;

-- Average temperature across Maharashtra
SELECT ROUND(AVG(avg), 2) AS avg_temp FROM weather;

-- Days above 40°C 🔥
SELECT dates, city, max FROM weather WHERE max > 40;
```

---

### 🏙️ City-Level Insights (6–15)

```sql
-- 🔥 Hottest city
SELECT city, ROUND(AVG(max), 2) AS avg_max_temp
FROM weather
GROUP BY city
ORDER BY avg_max_temp DESC
LIMIT 1;

-- 🌧️ City with most rainfall
SELECT city, ROUND(SUM(precipitation), 2) AS total_rain
FROM weather
GROUP BY city
ORDER BY total_rain DESC;

-- ☀️ City with most sunshine
SELECT city, ROUND(AVG(tsun), 2) AS avg_sunshine
FROM weather
GROUP BY city
ORDER BY avg_sunshine DESC;
```

---

### 📊 Data Quality Checks (15–16)

```sql
-- 🔁 Detect duplicates
SELECT dates, city, COUNT(*) AS cnt
FROM weather
GROUP BY dates, city
HAVING COUNT(*) > 1;

-- 🚫 NULL value check
SELECT * FROM weather
WHERE avg IS NULL OR max IS NULL OR precipitation IS NULL;
```

---

### 🪟 Window Functions Magic (17–31)

The star of the show. Here's where SQL gets *powerful*.

```sql
-- 🏆 Rank cities by average temperature
SELECT city,
       ROUND(AVG(avg), 2) AS avg_temp,
       RANK() OVER (ORDER BY AVG(avg) DESC) AS temp_rank
FROM weather
GROUP BY city;

-- 🥇🥈🥉 Top 3 hottest days ever
SELECT dates, city, max,
       DENSE_RANK() OVER (ORDER BY max DESC) AS heat_rank
FROM weather;

-- 🔥 Hottest day per city
SELECT * FROM (
  SELECT dates, city, max,
         ROW_NUMBER() OVER (PARTITION BY city ORDER BY max DESC) AS rn
  FROM weather
) ranked
WHERE rn = 1;

-- 📈 Running total rainfall
SELECT dates, city, precipitation,
       SUM(precipitation) OVER (ORDER BY dates) AS running_total
FROM weather;

-- ↩️ Compare today vs yesterday (temperature)
SELECT dates, city, avg,
       LAG(avg) OVER (PARTITION BY city ORDER BY dates) AS prev_day_temp,
       avg - LAG(avg) OVER (PARTITION BY city ORDER BY dates) AS temp_change
FROM weather;

-- ↪️ Peek at tomorrow's temperature
SELECT dates, city, avg,
       LEAD(avg) OVER (PARTITION BY city ORDER BY dates) AS next_day_temp
FROM weather;
```

---

## 🏅 Window Functions Used

| Function | Purpose |
|----------|---------|
| `RANK()` | City rankings with gaps |
| `DENSE_RANK()` | Rankings without gaps |
| `ROW_NUMBER()` | Unique row ordering |
| `LAG()` | Access previous row value |
| `LEAD()` | Access next row value |
| `SUM() OVER()` | Running totals |
| `AVG() OVER()` | Rolling averages |
| `PARTITION BY` | Group-within-group analysis |

---

## 🗺️ Key Insights Uncovered

```
  ┌──────────────────────────────────────────────────────┐
  │  🌡️  Identified the HOTTEST & COLDEST cities         │
  │  🌧️  Mapped rainfall distribution across cities      │
  │  📅  Found peak rainfall months                      │
  │  📉  Tracked daily temperature shifts using LAG()    │
  │  📈  Built running totals for cumulative analysis    │
  │  🔁  Detected & flagged duplicate records            │
  │  🏆  Ranked cities monthly, yearly & overall         │
  └──────────────────────────────────────────────────────┘
```

---

## 🛠️ Tech Stack

```
  MySQL  ──────────────────────────►  Query Engine
  SQL    ──────────────────────────►  Core Language
  Window Functions  ───────────────►  Advanced Analytics
  Aggregate Functions  ────────────►  Summary Statistics
  Subqueries  ─────────────────────►  Multi-step Logic
```

---

## 💡 Skills Demonstrated

- ✅ Writing clean, optimized SQL queries
- ✅ Applying Window Functions (`RANK`, `DENSE_RANK`, `ROW_NUMBER`, `LAG`, `LEAD`)
- ✅ Running cumulative & rolling calculations
- ✅ City-wise and month-wise partitioned analysis
- ✅ Data cleaning: NULL detection, duplicate handling
- ✅ Deriving meaningful climate insights from raw data
- ✅ Trend analysis across time and geography

---

## 📁 Project Structure

```
maharashtra-weather-sql/
│
├── 📄 README.md                   ← You are here
├── 🗄️ dataset/
│   └── maharashtra_weather.csv    ← Raw weather data
├── 📝 queries/
│   ├── 01_basic_analysis.sql      ← Foundation queries
│   ├── 02_city_insights.sql       ← City-level analysis
│   ├── 03_data_quality.sql        ← Cleaning & checks
│   └── 04_window_functions.sql    ← Advanced analytics
└── 📊 insights/
    └── key_findings.md            ← Summary of findings
```

---

## 🧠 How to Run

```sql
-- Step 1: Create the database
CREATE DATABASE maharashtra_weather;
USE maharashtra_weather;

-- Step 2: Import your dataset
LOAD DATA INFILE 'maharashtra_weather.csv'
INTO TABLE weather
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Step 3: Run any query from the queries/ folder
-- Start with 01_basic_analysis.sql and work your way up!
```

---

## 🎯 Conclusion

This project proves that **SQL alone** — no external tools, no fancy libraries — is powerful enough to:

- Analyze thousands of real-world weather records
- Rank, compare, and trend cities across Maharashtra  
- Detect data quality issues
- Generate climate insights that matter

> *The weather may be unpredictable. The SQL is not.*

---

<div align="center">

**Made with ☕ + 🧠 + a lot of SQL**

*If you found this useful, drop a ⭐ on the repo!*

</div>
