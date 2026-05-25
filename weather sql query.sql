-- 1. Find total records in dataset

SELECT COUNT(*) 
FROM weather;


-- 2. Show all unique cities

SELECT DISTINCT city
FROM weather;


-- 3. Find highest temperature recorded

SELECT MAX(max) AS highest_temp
FROM weather;


-- 4. Find lowest temperature recorded

SELECT MIN(tmin) AS lowest_temp
FROM weather;


-- 5. Find average temperature of all cities

SELECT ROUND(AVG(avg),2) AS avg_temperature
FROM weather;


-- 6. Find city-wise average temperature

SELECT city,
       ROUND(AVG(avg),2) AS avg_temp
FROM weather
GROUP BY city;


-- 7. Find hottest city

SELECT city,
       ROUND(AVG(max),2) AS hottest_temp
FROM weather
GROUP BY city
ORDER BY hottest_temp DESC
LIMIT 1;


-- 8. Find coldest city

SELECT city,
       ROUND(AVG(tmin),2) AS coldest_temp
FROM weather
GROUP BY city
ORDER BY coldest_temp
LIMIT 1;


-- 9. Find total rainfall by city

SELECT city,
       SUM(Precipitation) AS rainfall
FROM weather
GROUP BY city
ORDER BY rainfall DESC;


-- 10. Find total rainy days

SELECT COUNT(*) AS rainy_days
FROM weather
WHERE Precipitation > 0;


-- 11. Find month with highest rainfall

SELECT months,
       SUM(Precipitation) AS rainfall
FROM weather
GROUP BY months
ORDER BY rainfall DESC
LIMIT 1;


-- 12. Find top 5 hottest days

SELECT dates,
       city,
       max
FROM weather
ORDER BY max DESC
LIMIT 5;


-- 13. Find average pressure city-wise

SELECT city,
       ROUND(AVG(pressure),2) AS avg_pressure
FROM weather
GROUP BY city;


-- 14. Find city with highest sunshine

SELECT city,
       AVG(tsun) AS sunshine
FROM weather
GROUP BY city
ORDER BY sunshine DESC
LIMIT 1;


-- 15. Find days where temperature exceeded 40

SELECT *
FROM weather
WHERE max > 40;


-- 16. Rank cities by average temperature

SELECT city,
       ROUND(AVG(avg),2) AS avg_temp,
       RANK() OVER(ORDER BY AVG(avg) DESC) AS ranking
FROM weather
GROUP BY city;


-- 17. Find hottest day in each city

SELECT city,
       dates,
       max
FROM weather w
WHERE max = (
    SELECT MAX(max)
    FROM weather
    WHERE city = w.city
);


-- 18. Find duplicate records

SELECT dates,
       city,
       COUNT(*) AS total
FROM weather
GROUP BY dates, city
HAVING COUNT(*) > 1;


 -- 19. Find NULL values in dataset

SELECT *
FROM weather
WHERE avg IS NULL
   OR tmin IS NULL
   OR max IS NULL
   OR city IS NULL;

-- 20. Find yearly average temperature trend

SELECT years,
       ROUND(AVG(avg),2) AS yearly_avg_temp
FROM weather
GROUP BY years
ORDER BY years;

-- 21. Rank cities by average temperature

SELECT city,
       ROUND(AVG(avg),2) AS avg_temp,
       RANK() OVER(ORDER BY AVG(avg) DESC) AS city_rank
FROM weather
GROUP BY city;


-- 22. Dense rank cities by rainfall

SELECT city,
       SUM(Precipitation) AS rainfall,
       DENSE_RANK() OVER(ORDER BY SUM(Precipitation) DESC) AS rainfall_rank
FROM weather
GROUP BY city;


-- 23. Row number for hottest days

SELECT dates,
       city,
       max,
       ROW_NUMBER() OVER(ORDER BY max DESC) AS row_num
FROM weather;


-- 24. Find hottest day in each city

SELECT city,
       dates,
       max
FROM (
    SELECT city,
           dates,
           max,
           ROW_NUMBER() OVER(PARTITION BY city ORDER BY max DESC) AS rn
    FROM weather
) t
WHERE rn = 1;


-- 25. Find second hottest day in each city

SELECT city,
       dates,
       max
FROM (
    SELECT city,
           dates,
           max,
           ROW_NUMBER() OVER(PARTITION BY city ORDER BY max DESC) AS rn
    FROM weather
) t
WHERE rn = 2;


-- 26. Running total rainfall

SELECT dates,
       city,
       Precipitation,
       SUM(Precipitation)
       OVER(ORDER BY dates) AS running_rainfall
FROM weather;


-- 27. Running average temperature

SELECT dates,
       city,
       avg,
       ROUND(
           AVG(avg) OVER(ORDER BY dates),2
       ) AS running_avg_temp
FROM weather;


-- 28. Previous day temperature using LAG()

SELECT dates,
       city,
       avg,
       LAG(avg) OVER(PARTITION BY city ORDER BY dates) AS previous_day_temp
FROM weather;


-- 29. Next day temperature using LEAD()

SELECT dates,
       city,
       avg,
       LEAD(avg) OVER(PARTITION BY city ORDER BY dates) AS next_day_temp
FROM weather;


-- 30. Temperature difference from previous day

SELECT dates,
       city,
       avg,
       avg -
       LAG(avg) OVER(PARTITION BY city ORDER BY dates)
       AS temp_difference
FROM weather;


-- 31. Find highest rainfall day per city

SELECT city,
       dates,
       Precipitation
FROM (
    SELECT city,
           dates,
           Precipitation,
           RANK() OVER(
               PARTITION BY city
               ORDER BY Precipitation DESC
           ) AS rn
    FROM weather
) t
WHERE rn = 1;


-- 32. Find top 3 hottest days overall

SELECT *
FROM (
    SELECT dates,
           city,
           max,
           DENSE_RANK() OVER(ORDER BY max DESC) AS ranking
    FROM weather
) t
WHERE ranking <= 3;


-- 33. Compare current and previous rainfall

SELECT dates,
       city,
       Precipitation,
       LAG(Precipitation)
       OVER(PARTITION BY city ORDER BY dates)
       AS previous_rainfall
FROM weather;


-- 34. Monthly temperature ranking

SELECT months,
       city,
       ROUND(AVG(avg),2) AS avg_temp,
       RANK() OVER(
           PARTITION BY months
           ORDER BY AVG(avg) DESC
       ) AS monthly_rank
FROM weather
GROUP BY months, city;


-- 35. Find city contributing highest yearly rainfall

SELECT years,
       city,
       SUM(Precipitation) AS rainfall,
       RANK() OVER(
           PARTITION BY years
           ORDER BY SUM(Precipitation) DESC
       ) AS rainfall_rank
FROM weather
GROUP BY years, city;