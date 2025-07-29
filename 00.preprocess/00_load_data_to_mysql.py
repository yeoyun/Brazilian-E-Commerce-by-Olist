# load_data_to_mysql_raw.py
import pandas as pd
from sqlalchemy import create_engine
import os

# MySQL 연결 정보
user = 'root'
password = '1234'
host = 'localhost'
port = 3307  
database = 'olist_dw'

engine = create_engine(f'mysql+mysqlconnector://{user}:{password}@{host}:{port}/{database}')

# 파일명 → 테이블명 매핑
file_map = {
    #'olist_orders_dataset.csv': 'olist_orders_raw',
    #'olist_order_items_dataset.csv': 'olist_order_items_raw',
    #'olist_customers_dataset.csv': 'olist_customers_raw',
    #'olist_order_reviews_dataset.csv': 'olist_order_reviews_raw',
    #'olist_order_payments_dataset.csv': 'olist_order_payments_raw',
    #'olist_products_dataset.csv': 'olist_products_raw',
    #'product_category_name_translation.csv': 'product_category_name_translation_raw',
    #'olist_sellers_dataset.csv': 'olist_sellers_raw',
    'olist_geolocation_dataset.csv': 'olist_geolocation_raw',
    #'olist_marketing_qualified_leads_dataset.csv': 'olist_marketing_qualified_leads_raw',
    #'olist_closed_deals_dataset.csv': 'olist_closed_deals_raw'
}

# 상대 경로
data_dir = '../data'

for file_name, table_name in file_map.items():
    file_path = os.path.join(data_dir, file_name)
    print(f"[INFO] Loading {file_name} into `{table_name}`...")

    df = pd.read_csv(file_path)

    # 원본 테이블에는 PK 없이 생성했는지 확인 (중복 허용)
    try:
        df.to_sql(name=table_name, con=engine, if_exists='append', index=False, method='multi')
        print(f"[SUCCESS] {table_name} loaded with {len(df)} records.\n")
    except Exception as e:
        print(f"[ERROR] Failed to load {table_name}: {e}\n")



