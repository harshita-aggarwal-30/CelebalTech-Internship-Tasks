# ServiceTrack Final Project
# 🚀 ServiceTrack: Job Tracking & Customer Visit Analytics Pipeline

## 📌 Project Overview

ServiceTrack is an end-to-end Batch Data Engineering project developed as part of the **Celebal Technologies Data Engineering Internship**.

The project follows the **Medallion Architecture (Bronze → Silver → Gold)** to transform raw service center data into clean, analytics-ready datasets. The processed data is then visualized through an interactive **Power BI Dashboard** to provide meaningful business insights.

This project demonstrates the complete data engineering workflow, including data ingestion, cleaning, transformation, analytics, and visualization.



# 🏢 Organization

**Celebal Technologies**

**Internship Domain:** Data Engineering



# 🎯 Project Objectives

- Build an end-to-end data pipeline using Databricks.
- Implement Medallion Architecture.
- Clean and transform raw service center data.
- Generate business-ready Gold tables.
- Visualize insights using Power BI.
- Understand real-world Data Engineering concepts.



# 🛠 Technology Stack

| Technology | Purpose |
|------------|----------|
| Databricks | Data Engineering Platform |
| PySpark | Data Processing |
| Delta Lake | Storage Layer |
| SQL | Business Analytics |
| Power BI | Dashboard & Visualization |
| Git & GitHub | Version Control |


# 📂 Project Folder Structure


Final_Project
│
├── Dashboard
│   └── ServiceTrack_Dashboard.pbix
│
├── Data
│   ├── customers.csv
│   ├── devices.csv
│   └── service_jobs.csv
│
├── Databricks
│   ├── Bronze_Notebook.py
│   ├── Silver_Notebook.py
│   └── Gold_Notebook.py
│
├── Report
│   └── ServiceTrack_Project_Report.docx
│
├── Screenshots
│   ├── Bronze_Layer.png
│   ├── Silver_Layer.png
│   ├── Gold_Layer.png
│   ├── Dashboard.png
│   └── Architecture_Diagram.png
│
├── requirements.txt
│
└── README.md




# 🏗 Project Architecture


                 Raw CSV Files
                        │
                        ▼
              Bronze Layer (Raw Data)
                        │
                        ▼
          Silver Layer (Data Cleaning)
                        │
                        ▼
       Gold Layer (Business Analytics)
                        │
                        ▼
         Power BI Interactive Dashboard
                        │
                        ▼
              Business Insights




# 🥉 Bronze Layer

The Bronze layer stores the raw data exactly as received.

### Tasks Performed

- Read CSV files
- Load raw datasets into Databricks
- Save data as Delta Tables
- Preserve original records



# 🥈 Silver Layer

The Silver layer performs data cleaning and transformation.

### Tasks Performed

- Removed duplicate records
- Handled missing values
- Converted date columns
- Joined customer, device and service datasets
- Created repair_duration column
- Created delivery_status column
- Created warranty_status column
- Saved cleaned dataset as Delta Table



# 🥇 Gold Layer

The Gold layer contains business-ready analytical tables.

### Gold Tables Created

- gold_business_summary
- gold_brand_analysis
- gold_city_analysis
- gold_delay_analysis
- gold_issue_analysis
- gold_job_status
- gold_monthly_repairs
- gold_repeat_customers
- gold_repair_cost
- gold_repair_duration
- gold_technician_performance
- gold_technician_workload
- gold_warranty_analysis



# 📊 Power BI Dashboard

An interactive dashboard was created using Power BI.

### Dashboard Features

- KPI Cards
- Monthly Repair Trend
- Jobs by Status
- Jobs by Brand
- Delivery Status
- Technician Performance
- Top Reported Issues
- Repairs by City
- Average Repair Duration
- Interactive Filters



# 📈 Key Business Insights

- Identified technician performance based on completed jobs.
- Analyzed repair turnaround time.
- Studied brand-wise repair trends.
- Found repeat customers.
- Compared delivery status.
- Evaluated warranty-covered repairs.
- Monitored repair cost trends.
- Generated monthly repair reports.



# ⭐ Project Features

- End-to-End Data Engineering Pipeline
- Medallion Architecture Implementation
- Delta Lake Storage
- PySpark Transformations
- SQL-Based Analytics
- Interactive Power BI Dashboard
- Clean Folder Structure
- GitHub Version Control



# 📸 Project Screenshots

The repository includes screenshots of:

- Bronze Layer
- Silver Layer
- Gold Layer
- Power BI Dashboard
- Architecture Diagram



# ▶️ How to Run

1. Upload the CSV files to Databricks.
2. Execute the Bronze Notebook.
3. Run the Silver Notebook.
4. Execute the Gold Notebook.
5. Verify all Gold tables.
6. Connect Power BI to Databricks.
7. Refresh the dashboard.



# 🚀 Future Improvements

- Implement real-time streaming using Apache Kafka.
- Add automated data quality validation.
- Build an alerting system for delayed repairs.
- Deploy the pipeline using Azure Data Factory.
- Schedule notebook execution using Databricks Workflows.



# 📚 Learning Outcomes

Through this project, I learned:

- Medallion Architecture
- Databricks
- PySpark Transformations
- Delta Lake
- SQL Analytics
- Power BI Dashboard Development
- GitHub Project Management



# 👩‍💻 Author

**Harshita Aggarwal**

B.Tech Computer Science Engineering

Data Engineering Intern

Celebal Technologies


# 🙏 Acknowledgement

This project was completed as part of the **Celebal Technologies Data Engineering Internship Program**. It provided valuable hands-on experience in building an end-to-end data engineering pipeline using modern tools and industry practices.



⭐ If you found this project helpful, feel free to explore the repository and provide your feedback.
