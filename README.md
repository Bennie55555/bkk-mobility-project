# Bangkok Traffic - 7 Day GPS Probe Analysis

![Python](https://img.shields.io/badge/Python-3.11-blue)
![Pandas](https://img.shields.io/badge/Pandas-Used-informational)
![SQLite](https://img.shields.io/badge/SQLite-DB-green)
![Power%20BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow)
![Jupyter](https://img.shields.io/badge/Jupyter-Notebook-orange)

**Goal**  
Turn raw Longdo probe logs into hourly mobility metrics for Bangkok and visualize peak congestion patterns.

## Data
- 7 daily files: `data/20240601.csv.out` … `20240607.csv.out`
- Parsed columns: `vehicle_id, lat, lon, timestamp, speed`
- Total rows: {'slowest_hour': 3, 'slowest_speed_kmh': 6.34, 'fastest_hour': 14, 'fastest_speed_kmh': 15.38, 'busiest_hour': 16, 'busiest_points': 677165, 'weekday_speed': 12.42, 'weekend_speed': 13.17, 'delta_weekend_minus_weekday': 0.75}
- Time window: 1–7 Jun 2024

## Pipeline
1. **ETL (Python/Pandas)** — parse, clean (0–200 km/h), engineer `date`, `hour`, `weekday`, `is_weekend`.
2. **Aggregation** — `date × hour` → `avg_speed (km/h)`, `points` (density).
3. **SQLite** — store tidy table as `traffic_hourly` in `traffic.db` for SQL analysis.
4. **Analysis** — KPIs + charts, weekend vs weekday.
5. **BI** — import tidy CSVs into Power BI.

## Key Insights (7 days)
- Slowest hour: **H=<slowest_hour>**, avg **≈ <slowest_speed_kmh> km/h**
- Fastest hour: **H=<fastest_hour>**, avg **≈ <fastest_speed_kmh> km/h**
- Busiest hour: **H=<busiest_hour>**, **≈ <busiest_points>** points
- Weekend vs Weekday speed: **<weekend_speed> vs <weekday_speed> km/h** (Δ **≈ <delta_weekend_minus_weekday> km/h**)

## Outputs
- **Tidy data**: `exports/probe_7days_hourly.csv`
- **SQL DB**: `traffic.db` (table: `traffic_hourly`)
- **SQL exports**: `exports/sql_hourly_avg_speed.csv`, etc.
- **Charts**:  
  - `exports/images_avg_speed_by_hour.png`  
  - `exports/images_points_by_hour.png`  
  - `exports/images_speed_weekday_weekend.png`
- **Power BI**: dashboard file (optional): `bkk_traffic.pbix`

## 📊 Dashboard Preview

### Overall Dashboard
![Dashboard Overview](screenshots/dashboard_overview.png)

### Hourly Traffic Trends
![Hourly Trends](screenshots/hourly_trends.png)


## How to Reproduce
```bash
python -m venv venv
venv\Scripts\activate      # (Windows)
pip install -r requirements.txt  # pandas, matplotlib, folium (optional)
# open traffic_analysis.ipynb and Run All
