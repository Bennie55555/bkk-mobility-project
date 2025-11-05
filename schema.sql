-- schema.sql — SQLite schema for Bangkok Mobility
PRAGMA foreign_keys = ON;

-- Raw import table (column names aligned with sample CSV)
CREATE TABLE IF NOT EXISTS traffic_raw (
    date TEXT NOT NULL,           -- YYYY-MM-DD
    hour INTEGER NOT NULL,        -- 0-23
    area TEXT,                    -- optional area/segment label
    congestion_index REAL,        -- 0-100 (or dataset's scale)
    travel_time_min REAL,         -- optional
    avg_speed_kmh REAL            -- optional
);

-- Derived: hourly city-level aggregates
CREATE TABLE IF NOT EXISTS congestion_hourly AS
SELECT
    date,
    hour,
    CASE CAST( strftime('%w', date) AS INTEGER )
        WHEN 0 THEN 'Sun' WHEN 1 THEN 'Mon' WHEN 2 THEN 'Tue'
        WHEN 3 THEN 'Wed' WHEN 4 THEN 'Thu' WHEN 5 THEN 'Fri'
        ELSE 'Sat' END AS weekday,
    CASE WHEN CAST(strftime('%w', date) AS INTEGER) IN (0,6) THEN 1 ELSE 0 END AS weekend_flag,
    AVG(congestion_index) AS congestion_index,
    AVG(travel_time_min) AS travel_time_min,
    AVG(avg_speed_kmh) AS avg_speed_kmh
FROM traffic_raw
GROUP BY date, hour;

-- Optional segments metadata
CREATE TABLE IF NOT EXISTS segments (
    segment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    area TEXT
);

-- Derived: per-segment hourly
CREATE TABLE IF NOT EXISTS congestion_segment_hourly AS
SELECT
    COALESCE(seg.segment_id, NULL) AS segment_id,
    tr.date,
    tr.hour,
    AVG(tr.congestion_index) AS congestion_index,
    AVG(tr.avg_speed_kmh) AS avg_speed_kmh,
    AVG(tr.travel_time_min) AS travel_time_min
FROM traffic_raw tr
LEFT JOIN segments seg
  ON seg.name = tr.area
GROUP BY seg.segment_id, tr.date, tr.hour;
