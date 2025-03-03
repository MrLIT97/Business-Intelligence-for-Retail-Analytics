
# Optimizing Business Intelligence for Retail Analytics
 
This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse, streamlining data to creating actionable dashboards to drive decision-making. It highlights the industry-standard practices in data engineering and analytics to help an organization enhance its analytics capabilities to gain better insights into sales trends, inventory 
management, and customer behaviour across multiple locations.

### Objectives:
1. Consolidate and optimize data storage by integrating existing [datasets](datasets/) into a centralized data warehouse.
2. Develop ETL pipelines to ensure smooth data extraction, transformation, and loading from various sources.
3. Design interactive dashboards to visualize key performance indicators (KPIs) such as monthly sales, product performance, and customer demographics.
4. Document the steps taken to achieve the tasks in a PowerPoint presentation.

---
## 📖 Project Outline

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating Power BI dashboards and Powerpoint Presentation for actionable insights.

🎯 Expertise Showcased:
- SQL Development
- Data Architect
- Data Engineering  
- ETL Pipeline Development  
- Data Modeling  
- Data Analytics and Visualization
- Data Communication

---

## 🚀 Project Stages

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications
- **Data Sources**: Import data from two source systems provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

### BI: Analytics & Reporting (Data Analysis)

#### Objective
Develop Power BI Dashboard to deliver detailed insights into:
- **Customer Behavior**
- **Product Performance**
- **Sales Trends**

These insights empower stakeholders with key business metrics, enabling strategic decision-making.  

---
## 🏗️ Data Architecture

The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:
![data_processing_architecture](https://github.com/user-attachments/assets/81aabff0-84f0-4a9e-a351-ce6401a81af6)

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.

Data Model
![data_model](https://github.com/user-attachments/assets/ea40203c-cf3d-4757-845f-4853b66f3972)


---
## 📊 Dashboard
![Dashboard](https://github.com/user-attachments/assets/aeb75da9-a886-44f3-95c2-9e04a91bc6e0)

## 📂 Repository Structure
```
Optimizing Business Intelligence for Retail Analytics/
│
├── datasets/                           # Raw datasets used for the project
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting, loading raw data and testing the data quality
│   ├── silver/                         # Scripts for cleaning, transforming data and testing the data quality
│   ├── gold/                           # Scripts for creating analytical models
│
│
├── README.md                           # Project overview
```
