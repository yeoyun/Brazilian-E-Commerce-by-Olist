"""Export saved Plotly notebook outputs without executing analysis code.

Run from any directory: python scripts/export_plotly_gallery.py
Only the Python standard library is required. The gallery's bundled Plotly.js
and map assets are maintained separately under docs/visualizations/vendor/.
"""

import base64
import gzip
import hashlib
import json
import re
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "docs" / "visualizations"
GROUPS = {
    "01_RFM": "RFM·고객 행동",
    "04_Olist": "매출·카테고리",
    "05_region": "지역·배송",
}
FEATURED = {
    ("매출구조분석", 14, 0): ("sales-treemap", "카테고리별 매출 트리맵", 8),
    ("매출구조분석", 33, 0): ("sales-vs-price", "매출과 평균 단가", 8),
    ("매출구조분석", 35, 0): ("category-volume", "카테고리별 판매수량", 8),
    ("seller_customer", 16, 0): ("seller-network", "판매자–고객 지역 네트워크", 9),
    ("seller_customer", 11, 1): ("local-trades", "로컬·원거리 거래 구조", None),
    ("seller_customer", 5, 1): ("trade-sankey", "지역 간 거래 흐름", None),
    ("배송성능", 8, 1): ("delivery-map", "지역별 배송 성능", None),
    ("배송비", 6, 1): ("shipping-heatmap", "지역·카테고리 배송비 효율성", None),
    ("배송성능", 7, 1): ("delivery-surface", "거리·주문가치별 배송 지연률", None),
    ("행동인사이트", 29, 0): ("customer-radar", "고객군별 상품군 소비 레이더", None),
    ("클러스터링", 8, 0): ("rfm-3d", "RFM 고객 군집 3D", None),
}


def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    manifest = []
    payloads = {}
    for notebook in sorted((ROOT / "01.analysis").rglob("*.ipynb")):
        if ".ipynb_checkpoints" in notebook.parts:
            continue
        document = json.loads(notebook.read_text(encoding="utf-8"))
        for cell_index, cell in enumerate(document.get("cells", [])):
            for output_index, output in enumerate(cell.get("outputs", [])):
                figure = output.get("data", {}).get("application/vnd.plotly.v1+json")
                if not figure:
                    continue
                featured = FEATURED.get((notebook.stem, cell_index, output_index))
                chart_id = featured[0] if featured else f"chart-{len(manifest) + 1:02d}"
                title = figure.get("layout", {}).get("title", {})
                title = title.get("text", "") if isinstance(title, dict) else title
                title = re.sub(r"<[^>]+>", " ", title or "").strip()
                title = featured[1] if featured else title or f"{notebook.stem} · 차트 {cell_index + 1}"
                raw = json.dumps(figure, ensure_ascii=False, separators=(",", ":")).encode("utf-8")
                payloads[chart_id] = base64.b64encode(gzip.compress(raw, mtime=0)).decode("ascii")
                group = GROUPS.get(notebook.parent.name, notebook.parent.name)
                manifest.append({
                    "id": chart_id,
                    "title": title,
                    "group": group,
                    "source": notebook.relative_to(ROOT).as_posix(),
                    "cell": cell_index,
                    "output": output_index,
                    "types": sorted({trace.get("type", "scatter") for trace in figure.get("data", [])}),
                    "pptPage": featured[2] if featured else None,
                    "pptContextOnly": bool(notebook.stem == "매출구조분석" and cell_index in (14, 35)),
                    "sha256": hashlib.sha256(raw).hexdigest(),
                })

    bundle = {"charts": manifest, "payloads": payloads}
    (OUTPUT / "figures.js").write_text(
        "// Generated from saved notebook outputs; do not edit by hand.\n"
        + "window.OLIST_GALLERY = " + json.dumps(bundle, ensure_ascii=False, separators=(",", ":")) + ";\n",
        encoding="utf-8",
    )
    (OUTPUT / "manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(f"Exported {len(manifest)} saved Plotly figures.")
    print(dict(Counter(chart["group"] for chart in manifest)))
    print(f"Compressed figure bundle: {(OUTPUT / 'figures.js').stat().st_size:,} bytes")


if __name__ == "__main__":
    main()
