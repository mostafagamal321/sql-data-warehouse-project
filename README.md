
# 🏪 Retail Sales Analytics Data Warehouse Project
Welcome to the **Retail Sales Analytics Data Warehouse Project** repository\! 🚀 This comprehensive project showcases a modern data warehousing and analytics solution, transforming raw transactional data into actionable retail insights. Designed as a key portfolio piece, it highlights expertise in industry-standard data engineering and analytical practices.

-----

## 🏗️ Data Architecture: The Medallion Approach

The data architecture adheres to the widely-adopted **Medallion Architecture**, organizing data logically into three distinct layers to ensure quality, lineage, and usability: **Bronze**, **Silver**, and **Gold**.

| Layer | Purpose | Key Processes |
| :---: | :--- | :--- |
| **Bronze** 🥉 | **Raw Ingestion** | Stores raw, untouched data directly from source systems (CSV files). The primary focus is fast, reliable ingestion into a **SQL Server Database**. |
| **Silver** 🥈 | **Cleansing & Conformity** | Data is cleansed, standardized, de-duplicated, and integrated. This layer ensures data quality and prepares it for analytical modeling. |
| **Gold** 🥇   | **Business-Ready Model** | Houses dimensional models (**Star Schema**) optimized for business intelligence, reporting, and high-performance analytical queries. |

-----

## 📖 Project Overview

This project is a complete end-to-end data solution, covering:

1.  **Data Architecture:** Designing a **Modern Data Warehouse** using the Medallion Architecture (Bronze, Silver, Gold layers).
2.  **ETL Pipelines:** Developing robust **Extract, Transform, Load (ETL)** processes to move and refine data.
3.  **Data Modeling:** Creating a **Star Schema** with Fact (Sales, Returns) and Dimension (Product, Customer, Date, Store) tables optimized for retail analytics.
4.  **BI & Analytics:** Generating **SQL-based Key Performance Indicators (KPIs)** and reports to uncover critical retail insights.

🎯 **This repository serves as an excellent demonstration of expertise in:**

  * **Data Engineering** & **ETL Pipeline Development**
  * **SQL Development** (T-SQL)
  * **Data Architecture** & **Data Modeling** (Dimensional Modeling)
  * **Data Quality** & **Data Governance** Principles
  * **Retail Data Analysis**

-----

## 🛠️ Important Links & Tools (All Free\!)

We believe in accessible learning and development\! All tools and resources used are freely available:

| Resource | Purpose |
| :--- | :--- |
| **Datasets** | Access the raw transactional and master data files (CSV files) used as source systems. |
| **SQL Server Express** | The lightweight database engine used to host the Bronze, Silver, and Gold databases. |
| **SQL Server Management Studio (SSMS)** | The essential GUI tool for managing the SQL Server and developing SQL scripts. |
| **Git & GitHub** | Used for version control, collaboration, and repository management. |
| **DrawIO (Lucidchart/Diagrams.net)** | Utilized for visually designing the data flow, architecture diagrams, and data models. |
| **Notion Project Template** | Get the detailed project roadmap, task breakdowns, and phase-specific steps for the entire project. |

-----

## 🚀 Project Requirements: The Build Phase

### Building the Data Warehouse (Data Engineering)

**Objective:** Develop a modern, performant retail data warehouse in SQL Server to consolidate sales and inventory data, enabling in-depth analytical reporting for strategic business decisions.

**Specifications:**

  * **Data Sources:** Integrate and cleanse data from multiple retail sources, including **Transaction Logs** and **Product/Customer Master Data** (provided as CSV files).
  * **Data Quality:** Implement processes in the Silver layer to handle missing values, standardize product categories, and resolve customer duplicates.
  * **Integration & Modeling:** Combine transactional data into a unified dimensional model (Star Schema) suitable for analyzing **sales trends, basket size, and popular products**.
  * **Scope:** Focus solely on the latest data load; historical data persistence (Type 2 SCDs) is not a requirement for this project scope.
  * **Documentation:** Maintain a comprehensive **Data Catalog** and **Data Model Diagram** for stakeholder alignment and analyst support.

### BI: Analytics & Reporting (Data Analysis)

**Objective:** Develop robust, performant SQL queries to calculate and deliver detailed insights into core retail metrics.

**Key Analytical Focus Areas:**

  * **Customer Behavior:** Identify top-spending customers, track purchase frequency, and calculate **Customer Lifetime Value (CLV)**.
  * **Product Performance:** Determine the best and worst-selling products, calculate **Profit Margins**, and analyze inventory turnover.
  * **Sales Trends:** Analyze sales performance by **Time (Month/Quarter)**, **Store Location**, and **Day of the Week**.

*For granular details on specific metrics and requirements, refer to `docs/requirements.md`.*

-----

## 📂 Repository Structure

The following structure ensures a clean, modular, and easy-to-navigate project:

```
retail-sales-dwh-project/
│
├── datasets/             # 📥 Raw source files (CSV) - e.g., transactions, products, customers
├── docs/                 # 📄 Project documentation and architectural details
│   ├── data_catalog.md   # Catalog of datasets, including field descriptions and metadata
│   ├── naming-conventions.md # Consistent naming guidelines for tables, columns, and files
│   └── requirements.md   # Detailed requirements for the BI and Data Engineering phases
│
├── diagrams/             # 📐 Visual documentation using DrawIO
│   ├── etl_process.drawio # Illustrates the ETL techniques and data flow steps
│   ├── dwh_architecture.drawio # Shows the Medallion Architecture setup
│   └── star_schema_model.drawio # The final dimensional model (Fact and Dimension tables)
│
├── scripts/              # 💻 SQL scripts for the entire ETL process and analysis
│   ├── bronze/           # Scripts for initial raw data loading (CREATE TABLE, BULK INSERT)
│   ├── silver/           # Scripts for data cleaning, transformation, and integration (UPDATE, MERGE, Stored Procedures)
│   ├── gold/             # Scripts for creating the final Star Schema (CREATE DIMENSION/FACT)
│   └── analysis/         # SQL scripts for final analytical queries and KPI generation
│
├── tests/                # ✅ Test scripts and data quality validation queries
├── README.md             # This project overview and instructions
├── LICENSE               # License information for the repository
└── .gitignore            # Files and directories to be ignored by Git (e.g., temporary files)
```
