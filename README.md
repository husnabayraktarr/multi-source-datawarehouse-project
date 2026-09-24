# Enterprise Data Warehouse & ELT Pipeline

A multi-source ELT pipeline that ingests three independent, differently-structured
data sources (SQL Server-style, ERP/CSV-style, and Oracle-style exports), lands
them in cloud storage, loads them into a cloud data warehouse, and transforms
them into three separate star-schema data marts using dbt — with automated
testing and row-level reconciliation proving data integrity end to end.

## The problem

Companies routinely inherit sales/order data spread across systems that were
never designed to talk to each other — a legacy transactional database, ERP
CSV exports, a separate supply chain system with its own naming conventions.
Without an automated pipeline, answering a simple question like "what did we
sell last month" requires manually pulling and reconciling data by hand, with
no guarantee nothing was dropped or duplicated along the way.

This project builds that pipeline for three genuinely different, publicly
available datasets, chosen specifically because their schemas, naming
conventions, and data quality issues do not match — to prove the ingestion
and cleaning logic generalizes rather than being hand-fit to one clean source.

## Live dashboards

Three interactive Tableau Public dashboards, one per source, each with 4
charts covering revenue, operations, and trend analysis:

- **AdventureWorks Overview**: https://public.tableau.com/app/profile/husna.bayraktar5324/viz/Multi-SourceDataWarehouseAdventureWorksOlistDataCoAnalytics/AdventureWorksOverview
- **Olist Overview**: https://public.tableau.com/app/profile/husna.bayraktar5324/viz/Multi-SourceDataWarehouseAdventureWorksOlistDataCoAnalytics/OlistOverview
- **DataCo Overview**: https://public.tableau.com/app/profile/husna.bayraktar5324/viz/Multi-SourceDataWarehouseAdventureWorksOlistDataCoAnalytics/DataCoOverview

Each dashboard is fully interactive — hover over any bar or line for exact
values.

## Architecture

[SQL Server-style: AdventureWorks] ─┐
[ERP-style CSV: Olist e-commerce] ─┼──> S3 (raw landing) ──> Snowflake (raw)
[Oracle-style: DataCo Supply Chain] ─┘ │
▼
dbt: staging → dimensional marts
│
┌─────────────────┬──────────┴───────┐
▼ ▼ ▼
AdventureWorks mart Olist mart DataCo mart
│ │ │
└─────────────────┴──────────────────┘
dim_date (shared)
│
dbt tests + reconciliation_check


See `lineage_graph.png` for the full auto-generated dbt lineage diagram.

## Design decision: three marts, not one merged model

AdventureWorks sells to B2B resellers, Olist sells to Brazilian e-commerce
consumers, and DataCo serves a separate, unrelated global consumer base. These
are not the same customers or products, and merging them into one fake
"unified" customer/product dimension would misrepresent the data. Instead,
each source gets its own complete star schema (dimensions + fact table), and
all three share only what is genuinely universal: a single `dim_date`
calendar dimension.

## The three sources

| Source | Style | Tables loaded | Order-line rows |
|---|---|---|---|
| AdventureWorks | SQL Server export (tab-delimited) | 7 | 57,851 |
| Olist Brazilian E-Commerce | ERP/CSV export (comma-delimited) | 9 | 112,650 |
| DataCo Smart Supply Chain | Reshaped to Oracle-style export | 1 | 180,519 |

## Real data quality issues found and fixed

- **Currency stored as text**: AdventureWorks money fields arrived as
  `"$2,024.99"` — stripped and cast to `NUMBER(18,2)` in staging.
- **Spelled-out dates**: `"Friday, August 25, 2017"` parsed into real `DATE`
  values using Snowflake's lenient format matching.
- **Wrong delimiter assumptions**: AdventureWorks files are tab-delimited,
  not comma-delimited, despite the `.csv` extension.
- **Two-digit year bug**: the DataCo Oracle-style reshaping caused Snowflake's
  date inference to interpret a 2-digit year (`18`) as year 18 AD instead of
  2018. Caught by checking actual output data after a "successful" load, not
  just trusting that the load ran without error. Fixed with
  `DATEADD(year, 2000, ...)` in staging.

## Reconciliation results

| Source | Raw rows | Fact table rows | Status |
|---|---|---|---|
| AdventureWorks | 57,851 | 57,851 | MATCH |
| Olist | 112,650 | 112,650 | MATCH |
| DataCo | 180,519 | 180,519 | MATCH |

Zero rows lost or duplicated across 351,020 combined order-line records.

## Tech stack

- **Storage**: AWS S3
- **Warehouse**: Snowflake
- **Transformation**: dbt (dbt-core + dbt-snowflake)
- **Testing**: dbt schema tests + custom reconciliation model
- **Documentation**: dbt docs (auto-generated lineage graph)
- **BI / Dashboards**: Tableau Public

## Project structure

models/
├── staging/
│ ├── adventureworks/ (7 models + sources.yml)
│ ├── olist/ (9 models + sources.yml)
│ └── dataco/ (1 model + sources.yml)
└── marts/
├── dim_date.sql
├── dim_customer_aw.sql / dim_product_aw.sql / fact_orders_aw.sql
├── dim_customer_olist.sql / dim_product_olist.sql / fact_orders_olist.sql
├── dim_customer_dataco.sql / dim_product_dataco.sql / fact_orders_dataco.sql
├── reconciliation_check.sql
└── _marts_schema.yml


## Running this project

1. Load the three raw datasets into S3 under `raw/<source_name>/`.
2. Configure `~/.dbt/profiles.yml` with your Snowflake credentials.
3. `dbt run` — builds all 28 models (17 staging + 11 marts).
4. `dbt test` — runs all 18 data tests.
5. `dbt docs generate && dbt docs serve` — view the interactive lineage graph.
