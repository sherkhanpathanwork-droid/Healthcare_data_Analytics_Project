# Healthcare-data-Analytics-Project
Healthcare Data Analytics Project using SQL, MySQL, Data Warehousing (Star Schema) and Power BI.

# Project Overview
– Analyzed a relational healthcare dataset containing 5 interconnected tables, 50 patients, and 200+
appointment and billing records using SQL to generate business insights.

– Developed 19+ analytical SQL queries covering Exploratory Data Analysis (EDA), patient segmentation, doctor
workload, appointment trends, treatment performance, and revenue analysis using JOINs, CTEs, CASE,
Aggregate Functions, and Window Functions.

– Identified key findings including Pediatrics as the highest-demand specialization (98 appointments),
Chemotherapy contributing 23.38% of treatment revenue, and significant appointment no-shows and
pending payments affecting operational efficiency.

– Provided data-driven recommendations to improve patient acquisition, optimize doctor workload, reduce
appointment no-shows, strengthen billing efficiency, and support hospital decision-making through business
intelligence.

---

# Tech Stack

- SQL (MySQL)
-MySQL Workbench
-Power BI Desktop
-DAX
-Data Warehouse
-Star Schema
-Git & GitHub

---
# Dataset Information

The project consists of five relational tables:

- Patients
- Doctors
- Appointments
- Treatments
- Billing

---
# Features & Highlights

- Data Exploration (EDA)
- Patient Demographics Analysis
- Doctor Performance Analysis
- Appointment Analysis
- Treatment Analysis
- Revenue Analysis
- Billing Performance Analysis
- Business Insights Generation
- SQL Aggregations
- GROUP BY & HAVING
- CASE Statements
- Window Functions
- Common Table Expressions (CTEs)
- Ranking Functions
- Percentage Calculations
- Data Filtering & Sorting
- Business Reporting
- KPI Development
- Interactive Dashboard
- Data Modeling
- Relationship Management
- Star Schema Design
- Data Visualization
  
---
# Business Questions Answered

## Exploratory Data Analysis

- How many patients are registered?
- How many doctors are available?
- Which medical specializations are available?

## Patient Analysis

- How many patients registered in the last 30 days?
- Which location has the highest number of patients?
- What is the patient age distribution?
- Which email domain is most commonly used?
- Monthly Patient Registration Trend?


## Doctor Analysis

- Which doctor has the highest experience?
- How many senior and junior doctors are available?
- Which specialization has the highest appointment demand?
- How is doctor workload distributed?
- Which doctors have the highest utilization rate?

## Appointment Analysis

- What is the appointment status distribution?
- How many appointments occurred in the last 7 days?
- Date-wise Appointment Status Trend?
- cancellation rate?

## Treatment Analysis

- Which treatments are performed most frequently?
- What are the minimum, maximum, and average treatment costs?
- Which treatments generate the highest revenue?

## Billing & Revenue Analysis

- What is the payment status distribution?
- What is the total hospital revenue?
- Who are the top 10% highest-spending patients?

---

# Key Business Insights

- Identified patient registration trends and demographic distribution.
- Evaluated doctor workload and utilization.
- Measured specialization-wise appointment demand.
- Identified high-demand medical treatments.
- Analyzed treatment cost distribution.
- Determined revenue contribution by treatment.
- Evaluated billing efficiency and payment status.
- Identified high-value patients for retention strategies.

---
# Business Recommendations

- Improve patient acquisition through awareness campaigns.
- Balance doctor workload across departments.
- Recruit junior doctors to support long-term workforce planning.
- Reduce appointment no-shows using automated reminders.
- Increase investment in high-demand medical services.
- Improve billing efficiency by reducing pending and failed payments.
- Monitor KPIs regularly using interactive dashboards.

---
# SQL Concepts Used

- SELECT
- WHERE
- ORDER BY
- GROUP BY
- HAVING
- Aggregate Functions
- CASE WHEN
- JOINS
- Subqueries
- Common Table Expressions (CTEs)
- Window Functions
- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- Percentage Calculations
- Date Functions

---
# Data Warehouse

A Star Schema data model was designed to improve analytical performance and simplify reporting.

Dimension Tables
- Dim Patient
- Dim Doctor
- Dim Treatment
- Dim Date
Fact Table
- Fact Healthcare
---
# Power BI Dashboard
An interactive Power BI dashboard was developed to visualize healthcare KPIs and business insights.
Dashboard Highlights
- Total Patients
- Total Doctors
- Total Appointments
- Total Revenue
- Total Treatments
- Cancellation Rate
- Appointment Status Analysis
- Monthly Revenue Trend
- Top Doctors
- Revenue by Treatment
- Specialization Demand
- Interactive Filters & Slicers
---
# DAX Measures
Key DAX measures were created for dashboard KPIs.
- Total Patients
- Total Doctors
- Total Appointments
- Total Revenue
- Total Treatments
- Average Bill Amount
- Cancellation Rate

--- 
# Dashboard Preview
![Dashboard](Images/Dashboard_Overview.png)

--- 
# Star Schema
![Star Schema](Images/Star_Schema.png)












