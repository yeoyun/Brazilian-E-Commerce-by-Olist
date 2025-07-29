import pandas as pd
from sqlalchemy import create_engine

df = pd.read_csv('../data/olist_geolocation_dataset.csv')

user = 'root'
password = '1234'
host = 'localhost'
port = 3307
database = 'olist_dw'

engine = create_engine(f"mysql+mysqlconnector://{user}:{password}@{host}:{port}/{database}")

try:
    df.to_sql(
        name='olist_geolocation_raw',
        con=engine,
        if_exists='append',
        index=False,
        method='multi',
        chunksize=10000
    )
    print(f"[SUCCESS] olist_geolocation_raw 적재 완료 — {len(df):,}건\n")
except Exception as e:
    print(f"[ERROR] 적재 실패: {e}")