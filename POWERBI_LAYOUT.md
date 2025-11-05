# Power BI Layout — Bangkok Mobility Dashboard

## Page 1 — Overview
- KPI cards: Avg Congestion Index, Peak Hour (AM/PM), Worst Day, Best Day
- Line chart: Congestion by hour (24h)
- Column chart: Congestion by day of week
- Slicer: Weekday vs Weekend

## Page 2 — Peak Hours
- Heatmap: Hour (x) × Day of Week (y) → Avg Congestion
- Bar chart: Top 10 peak hours by congestion
- Trend line: AM vs PM comparison (overlay)

## Page 3 — Segments / Areas
- Map visual: Avg congestion by area/segment
- Bar chart: Top 10 most congested segments
- Table: Segment, Avg Speed (km/h), Travel Time (min), Congestion Index

## Page 4 — Insights
- Text boxes with bullet insights and recommendations
- (Optional) Rain vs clear day comparison visuals if weather added

## Data Model (recommended tables)
- `congestion_hourly` (city, date, hour, weekday, weekend_flag, congestion_index, avg_speed_kmh, travel_time_min)
- `segments` (segment_id, name, area)
- `congestion_segment_hourly` (segment_id, date, hour, congestion_index, avg_speed_kmh)

> Keep measures simple: average, rank, diff AM/PM.
