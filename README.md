# Product Scrap & Manufacturing Quality Analysis

## Project Overview
This project is a root cause analysis of product defects (scrap) at the manufacturing plant. The main goal was to look past the general numbers, find out exactly why quality drops happen, and see how team leaders affect the process.

## Tech Stack
* **SQL:** Extracted and aggregated production data from SAP ERP.
* **Python (Pandas):** Cleaned the data and prepared it for analysis.
* **Data Visualization (Matplotlib & Seaborn):** Created charts to compare performance and track monthly trends.

## Key Insights (Short Summary)
* **Main Issue:** Over 55% of all scrap is caused by `scrap_softness_pct` (softness defects), and around 22% comes from `scrap_overlap_pct`. Fixing these two will eliminate almost 77% of all waste.
* **Team Leaders (Final Stage):** On the final assembly and check stage (`df_productivity`), both Alex and John perform equally well, keeping the scrap rate stable around 1%.
* **The Root Cause:** The anomaly analysis (`df_anomaly`) showed that raw materials produced by **Alex's shift** (as `scan_leader`) end up in heavily defective orders 2-3 times more often than John's. The quality issue starts earlier in the process—at the raw material preparation stage.

## Repository Structure
* 📁 **data/** — Raw CSV files extracted from SAP.
* 📁 **sql_queries/** — SQL scripts used for data aggregation.
* 📄 **analysis.ipynb** — Main Jupyter notebook with Python code, charts, and comments.