# Jeff_portfolio
Analytics portfolio
# 🏦 Bank Marketing Campaign Analysis

This project explores a Portuguese bank's marketing campaign data to understand customer behavior and improve deposit conversion rates. 
The goal was to clean the data, explore relationships through SQL queries, and create visual dashboards in Tableau.

---

## 📑 Table of Contents
- [Project Background](#project-background)
- [Tools Used](#tools-used)
- [Data Cleaning & Preparation](#data-cleaning--preparation)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Key Insights](#key-insights)
- [Recommendations](#recommendations)
- [Files Included](#files-included)
- [Dataset Source](#dataset-source)

---

## 📌 Project Background

The bank conducted direct marketing campaigns via phone calls to promote term deposits.
This project analyzes customer responses to help identify the best timing, contact method, and target demographics for future campaigns.

---

## 🛠 Tools Used

- **SQL** – Data extraction, cleaning, joins, and aggregation
- **Excel** – Additional data validation and export
- **Tableau** – Interactive visual dashboards

---

## 🧹 Data Cleaning & Preparation

- Split raw data into separate `customers`, `campaign`, and `outcomes` tables
- Used `JOIN` operations in SQL to reconstruct the full dataset
- Removed null values and standardized categorical variables
- Used `CASE` statements to group age ranges and classify contact types

---

## 📊 Exploratory Data Analysis

- Segmented customers by age group and contact method
- Analyzed conversion rates by month, campaign count, and previous interactions
- Built views for Tableau to visualize key metrics

---

## 🔍 Key Insights

- **Conversion Rate by Age Group**:  
  The **30–39** and **60+** groups had the highest conversion rate at **36%**.  
  However, **60+** also had the **highest number of unsuccessful conversions** (11%).

- **Most Effective Contact Method**:  
  **Cellular** contact had an impressive **83% success rate**.

- **Best Month for Campaigns**:  
  **May** showed the strongest performance with a **17% conversion rate**.

---

## ✅ Recommendations

- Focus marketing campaigns on customers aged **30–39** for higher conversion potential.
- Prioritize **cellular contact methods** over telephone or unknown methods.
- Increase campaign activity in **Q2**, especially **May**, based on past success.

---

## 📂 Files Included

- `bank_db.sql` – Creates normalized customer, campaign, and outcomes tables, contains grouped age analysis, merges tables and cleans data contact method success, and monthly trends
- `bank.twbx` – Tableau workbook with key insights and visualizations
- `bank_copy (version 1).xlsx` – Cleaned dataset in Excel format

---

## 📈 Dashboard Preview
*(Insert image if available)*
```markdown
![Dashboard Screenshot](images/bank_dashboard.png)
