from pathlib import Path
import glob
import pandas as pd

DATA = Path("data")
FILES = sorted(glob.glob(str(DATA / "202406*.csv.out")))

USE_COLS = {
    'vehicle': 0, 'lat': 2, 'lon': 3, 'timestamp': 4, 'speed': 5,
}

def load_probe_file(path: str) -> pd.DataFrame:
    df = pd.read_csv(
        path, header=None,
        usecols=list(USE_COLS.values()),
        names=list(USE_COLS.keys())
    )
    df['timestamp'] = pd.to_datetime(df['timestamp'], errors='coerce')
    df['speed'] = pd.to_numeric(df['speed'], errors='coerce')

    df = df.dropna(subset=['timestamp','lat','lon','speed'])
    df = df[(df['speed'] >= 0) & (df['speed'] <= 200)]

    df['date'] = df['timestamp'].dt.floor('D')
    df['hour'] = df['timestamp'].dt.hour
    df['weekday'] = df['timestamp'].dt.day_name()
    df['is_weekend'] = df['weekday'].isin(['Saturday','Sunday'])
    return df[['vehicle','lat','lon','timestamp','speed','date','hour','weekday','is_weekend']]

def hourly_stats(df: pd.DataFrame) -> pd.DataFrame:
    return (
        df.groupby(['date','hour'])
          .agg(avg_speed=('speed','mean'), points=('speed','count'))
          .reset_index()
    )

def main():
    all_hourly = []
    for f in FILES:
        df = load_probe_file(f)
        h = hourly_stats(df)
        h['source_file'] = Path(f).name
        all_hourly.append(h)

    hourly = pd.concat(all_hourly).sort_values(['date','hour'])
    Path("exports").mkdir(exist_ok=True)
    hourly.to_csv("exports/probe_7days_hourly.csv", index=False)
    print("Saved -> exports/probe_7days_hourly.csv", hourly.shape)

if __name__ == "__main__":
    main()
