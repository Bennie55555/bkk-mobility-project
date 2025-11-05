-- queries.sql — analysis queries

-- 1) Peak hour by day (city-level)
SELECT weekday, hour, AVG(congestion_index) AS avg_cong
FROM congestion_hourly
GROUP BY weekday, hour
ORDER BY weekday,
         CASE WHEN hour BETWEEN 6 AND 10 THEN 0
              WHEN hour BETWEEN 16 AND 20 THEN 1
              ELSE 2 END, avg_cong DESC;

-- 2) Weekday vs Weekend comparison
SELECT weekend_flag,
       AVG(congestion_index) AS avg_congestion,
       AVG(avg_speed_kmh) AS avg_speed
FROM congestion_hourly
GROUP BY weekend_flag;

-- 3) Top 10 most congested hours overall
SELECT hour, AVG(congestion_index) AS avg_cong
FROM congestion_hourly
GROUP BY hour
ORDER BY avg_cong DESC
LIMIT 10;

-- 4) Segment ranking (if segments exist)
SELECT s.name AS segment,
       AVG(csh.congestion_index) AS avg_cong,
       AVG(csh.avg_speed_kmh) AS avg_speed
FROM congestion_segment_hourly csh
JOIN segments s ON s.segment_id = csh.segment_id
GROUP BY s.name
ORDER BY avg_cong DESC
LIMIT 10;

-- 5) AM vs PM difference
WITH hourly AS (
  SELECT hour,
         AVG(congestion_index) AS avg_cong
  FROM congestion_hourly
  GROUP BY hour
)
SELECT
  AVG(CASE WHEN hour BETWEEN 6 AND 10 THEN avg_cong END) AS am_peak,
  AVG(CASE WHEN hour BETWEEN 16 AND 20 THEN avg_cong END) AS pm_peak;
