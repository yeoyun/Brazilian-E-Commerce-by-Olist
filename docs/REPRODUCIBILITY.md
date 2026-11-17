# 환경 준비와 재현 안내

[README](../README.md) · [분석 코드 안내](ANALYSIS_GUIDE.md) · [지표 근거](METRICS_AND_LIMITATIONS.md)

이 저장소는 종료된 프로젝트의 SQL·노트북·시각화 작업 기록입니다. 아래는 현재 파일을 기준으로 한 준비 순서입니다. 과거 정제 DB 스냅샷, 고정 패키지 버전, 전체 자동 실행 파이프라인이 포함돼 있지 않아 저장 출력과 정확히 같은 결과를 즉시 보장하지는 않습니다.

## 분석을 실행하지 않고 시각화 보기

발표 그래프는 [시각화 문서](VISUALIZATIONS.md)에서, 저장된 Plotly 출력 48개는 [인터랙티브 뷰어](visualizations/index.html)에서 확인할 수 있습니다. 저장소를 다운로드해 `docs/visualizations/index.html`을 Chrome·Edge에서 엽니다. DB·Python·인터넷 연결 없이 동작하며, GitHub 웹에서는 HTML 소스가 표시됩니다.

원본 노트북의 저장 출력을 바꾼 뒤에는 다음 명령으로 차트 데이터 묶음을 다시 내보냅니다. 분석 코드를 실행하지 않으며 Python 표준 라이브러리만 사용합니다.

```bash
python scripts/export_plotly_gallery.py
```

발표 PNG 원본의 위치는 [이미지 목록](assets/manifest.json), Plotly 원본 셀과 출력 번호는 [차트 목록](visualizations/manifest.json)에 기록했습니다.

## 1. 원본 데이터

[이커머스 데이터](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)와 [마케팅 퍼널 데이터](https://www.kaggle.com/datasets/olistbr/marketing-funnel-olist)를 준비하고, 저장소 루트의 `data/`에 다음 이름으로 배치합니다.

```text
data/
├── olist_orders_dataset.csv
├── olist_order_items_dataset.csv
├── olist_customers_dataset.csv
├── olist_order_payments_dataset.csv
├── olist_order_reviews_dataset.csv
├── olist_products_dataset.csv
├── olist_sellers_dataset.csv
├── olist_geolocation_dataset.csv
├── product_category_name_translation.csv
├── olist_marketing_qualified_leads_dataset.csv
└── olist_closed_deals_dataset.csv
```

`data/`는 Git 추적에서 제외돼 있습니다. 파생 CSV도 기본적으로 이 폴더에 저장합니다. 현재 로컬에 파일이 있다는 사실과 GitHub에서 내려받을 수 있다는 사실을 구분해야 합니다.

## 2. Python 환경

```bash
python -m venv .venv
```

Windows PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
```

macOS·Linux:

```bash
source .venv/bin/activate
```

가상환경에서 분석에 쓰인 주요 패키지를 설치합니다. 아래는 버전을 고정한 과거 환경 복원이 아니라 의존 패키지 목록입니다.

```bash
python -m pip install pandas numpy sqlalchemy pymysql mysql-connector-python matplotlib seaborn plotly networkx scikit-learn nltk wordcloud jupyter
python -m nltk.downloader stopwords
```

여러 노트북의 한글 폰트는 `Pretendard`로 지정돼 있습니다. 설치된 한글 폰트로 바꾸거나 해당 폰트를 준비합니다. Plotly 정적 이미지 저장 기능은 사용한 저장 방식에 맞는 추가 의존성을 확인합니다.

## 3. MySQL 준비

루트에서 실행합니다.

```bash
docker compose up -d
docker compose ps
```

[Compose](../docker-compose.yml)의 기존 설정은 MySQL 8.0, DB `olist_dw`, 호스트 `localhost`, 로컬 포트 `3307`입니다. 계정 설정은 Compose와 코드에서 일치시킵니다. 컨테이너의 `3306` 포트와 로컬 접속 `3307`을 구분합니다.

`db/init.sql`은 빈 MySQL 데이터 볼륨을 처음 초기화할 때 실행됩니다. 기존 볼륨에는 파일 수정이 자동 반영되지 않습니다. 이 안내에서는 기존 볼륨이나 데이터를 삭제하지 않습니다.

## 4. 원천 적재와 정제 테이블

다음은 실행 전 대조가 필요한 부분입니다.

| 파일·구성 | 현재 상태 | 실행 시 확인 |
| --- | --- | --- |
| [초기 스키마](../db/init.sql) | 접미사 없는 기본 테이블 정의 | 후속 SQL과 필요한 컬럼·키 대조. 계약 테이블 정의에는 `mql_id`가 빠져 있음 |
| [일반 적재](../00.preprocess/00_load_data_to_mysql.py) | `_raw` 대상으로 적재, 활성 매핑은 계약 CSV 한 종 | 나머지 CSV 매핑을 준비하고 적재 결과 확인 |
| [대용량 좌표 적재](../00.preprocess/00_load_date_single.py) | 지리정보 CSV를 청크 단위 적재 | 동일 파일의 중복 적재 여부 확인 |
| [테이블별 SQL](../00.preprocess/DW_query/) | 점검·정제 SQL과 여러 테이블 정의 포함 | `_raw`·`_row` 등 이름, 컬럼, 정제 순서를 실제 스키마와 대조 |
| 리뷰 키 | 초기 정의는 `review_id`를 단독 PK로 사용 | 원본에서 중복되므로 보존·중복 처리 기준 결정 |
| [초기 데이터마트 SQL](../00.preprocess/olist_data_marts.sql) | 고객별 마트 일부가 `customer_id` 기준 | 이후 `customer_unique_id` 기반 분석과 집계 단위를 구분 |

적재 코드는 `append` 방식입니다. 같은 입력을 반복 실행하면 중복 적재될 수 있습니다. 테이블별 적재 행 수와 키의 고유 개수를 함께 확인합니다.

상대경로 `../data`를 사용하는 적재 코드는 `00.preprocess/`를 작업 디렉터리로 실행합니다. 현재 활성 매핑을 확인한 후 실행할 명령은 다음과 같습니다.

```bash
cd 00.preprocess
python 00_load_data_to_mysql.py
```

위 명령 하나로 모든 원천 적재·정제가 완료되는 구성은 아닙니다. 특히 접미사 없는 초기 테이블 생성과 `_raw` 적재는 별도 단계입니다. 노트북이 참조하는 최종 정제 테이블의 스키마와 행 수를 확인한 후 분석으로 넘어갑니다.

## 5. 분석과 파생 파일 의존성

각 노트북이 있는 폴더에서 실행하고 DB 연결과 상대경로를 확인합니다. 원본 CSV를 직접 읽는 노트북은 주로 `../../data/`를 사용합니다.

| 분석 | 필요한 입력·선행 결과 |
| --- | --- |
| RFM·코호트·고객 EDA | 정제 주문·고객·상품·결제·리뷰와 분석별 마트 |
| 리뷰 분석·감정 예측 | 텍스트가 있는 리뷰, NLTK 포르투갈어 불용어, 정제 DB |
| 고객 시나리오 | 같은 폴더의 `comprehensive_conversion_analysis.csv`. 감정 예측 후속 셀에서 생성 |
| DB 기반 셀러 분석 | MQL·계약·주문상품·판매자 테이블, `mql_id`·`seller_id` |
| CSV 기반 셀러 예측 | 원본 MQL·계약·주문상품·판매자 CSV |
| BI 데이터 추출 | [추출 노트북](../02.ad_hoc/00.데이터마트생성.ipynb)의 선행 정제 테이블·쿼리, 출력 경로 `../data` |
| KPI·What-if | [대시보드 폴더](../03.dashboard/) 각 셀의 DB·CSV 입력 |

감정 예측의 평가 셀에는 `y_pred` 선행 정의가 누락돼 있고, 고객 시나리오에는 `retention_uplift`를 정의하기 전에 사용하는 셀이 있습니다. 새 커널에서 위에서 아래로 실행하면 보완이 필요한 작업 기록임을 유의합니다. 이번 문서 정리는 기존 분석 코드를 변경하지 않았습니다.

BI 추출 노트북은 쿼리·문자열 형식 처리 오류가 기록돼 있어 전체 저장 성공을 확인해야 합니다. 결과 파일 유무와 함수의 완료 메시지만 보지 말고 파일별 행 수·키·분모·오류 로그를 확인합니다.

### Tableau 워크북

[storyboard_.twb](../03.dashboard/storyboard_.twb)는 대시보드 2개와 워크시트 8개를 포함합니다. 공개본의 CSV·Hyper 연결은 `../data/` 기준 상대경로로 정리했습니다. Tableau에서 열 때 현재 원본 CSV에 재연결하거나 필요한 추출을 다시 생성합니다. `.twb`에 CSV·Hyper 데이터 자체는 포함돼 있지 않습니다. 발표 시점의 화면은 [KPI Overview 이미지](assets/tableau-kpi-overview.png)에서 확인할 수 있습니다. 현재 환경에서 Tableau 앱 실행·데이터 연결·공개 배포 동작까지 검증하지는 않았습니다.

## 6. DB 없이 원본 지표 확인

다음 Python 코드는 저장소 루트에서 원본 CSV만으로 고객·셀러 수를 확인합니다. 과거 정제본을 복원하는 코드는 아닙니다. Python 표준 라이브러리만 사용합니다.

```python
import csv
from collections import Counter
from pathlib import Path

data = Path("data")

def read_csv(filename):
    with (data / filename).open(encoding="utf-8-sig", newline="") as file:
        return list(csv.DictReader(file))

customers = read_csv("olist_customers_dataset.csv")
orders = read_csv("olist_orders_dataset.csv")
leads = read_csv("olist_marketing_qualified_leads_dataset.csv")
deals = read_csv("olist_closed_deals_dataset.csv")
items = read_csv("olist_order_items_dataset.csv")
customer_keys = {row["customer_id"]: row["customer_unique_id"] for row in customers}
allowed = {"delivered", "shipped", "processing"}
counts = Counter(
    customer_keys[row["customer_id"]]
    for row in orders if row["order_status"] in allowed
)
contracted = {row["seller_id"] for row in deals}
observed = contracted & {row["seller_id"] for row in items}

print("원본 주문:", len(orders))
print("선택 주문 상태의 고유 고객:", len(counts))
print("1회 구매:", sum(value == 1 for value in counts.values()))
print("2회 이상 구매:", sum(value > 1 for value in counts.values()))
print("리드:", len(leads))
print("계약 판매자:", len(contracted))
print("주문상품에서 거래가 관측된 계약 판매자:", len(observed))
```

검토 당시 결과는 주문 99,441건, 선택 상태 고유 고객 94,686명, 1회 91,814명, 2회 이상 2,872명, 리드 8,000건, 계약 판매자 842명, 거래 관측 판매자 380명이었습니다. 셀러 집계에는 계약일 이후 기간 조건을 적용하지 않았습니다.

## 7. 이번 문서 정리의 검증 범위

- 발표 PDF 31쪽의 텍스트와 핵심 페이지 시각 확인.
- 연결된 GitHub 저장소의 최신 README·커밋 이력과 로컬 분석 파일 대조.
- 원본 CSV 행 수, 고유 고객의 주문 횟수, 리드·계약·판매자 거래 연결 재집계.
- 후보·통합 결과 CSV의 고유 ID, 결측, 완전 중복 행 확인.
- 노트북 코드·저장 출력, 모델 학습 순서, 시나리오 산식, ETL 로그 확인.

DB 적재·전체 노트북 실행·모델 재학습·Tableau 공개 대시보드 동작 검증은 수행하지 않았습니다. 저장 결과의 정확한 재현은 스키마·정제 규칙과 선행 셀을 정리한 다음 단계의 작업입니다.
