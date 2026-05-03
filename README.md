# Data Warehousing Portfolio – SQL Server

## Overview
A hands-on project demonstrating the construction of a robust Data Warehouse. This project covers the full lifecycle of data modeling, from source system analysis to the final analytical layer.

## Tech Stack
*   **Database:** SQL Server
*   **Key Features:**
    *  Designed and implemented a Star Schema architecture.
    *  Developed **ETL (Extract, Transform, Load)** processes to handle data cleaning and integration.
    *  Created Fact and Dimension tables to optimize query performance for BI tools.
    *  **Relational Data Modeling:** Establishing logical schemas and table integration to ensure seamless data flow and referential integrity.



## Data Pipeline & Methodology
In this project, i follows a structured **Medallion Architecture** to ensure data integrity, traceability, and high-quality analytical output. The workflow is divided into three distinct layers:
*  Bronze (Raw Layer): Serves as the landing zone for raw, unaltered source data.
*  Silver (Refined Layer): Contains cleansed and standardized data. In this stage, data is transformed from its raw state into a structured format.
*  Gold (Curated Layer): The final presentation layer. This database contains high-performance, business-ready datasets optimized for reporting and BI tools.

**Implementation Workflow**
For every layer in the pipeline, a consistent three-step process was applied:
*  Table Initialization (Create): Defining and scripting the physical schema and table structures.
*  Data Transformation & Refinement (Modeling): Implementing logic to ensure data quality and consistency. Key operations include:
   *  Deduplication: Identifying and removing duplicate records.
   *  Schema Integration: Mapping and connecting relational values between tables.
   *  Logic Standardization: Handling date formatting and integer logic to ensure mathematical accuracy.
*  Data Loading (Insert): Executing the final ETL scripts to populate the modeled tables with validated data.


## Acknowledgement
Special thanks to **Baraa** from the [Data with Baraa YouTube Channel](https://www.youtube.com/@DataWithBaraa) for the excellent training materials and dataset that made this project possible.
