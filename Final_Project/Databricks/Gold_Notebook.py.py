# Databricks notebook source
# MAGIC %md
# MAGIC # **Phase 4 – Gold Layer (Business Analytics)**

# COMMAND ----------

# MAGIC %md
# MAGIC **Read the Silver Table**

# COMMAND ----------

silver_df = spark.table("workspace.default.silver_service_track")  

# COMMAND ----------

# MAGIC %md
# MAGIC **Create a Temporary SQL View**

# COMMAND ----------

silver_df.createOrReplaceTempView("service_data")

# COMMAND ----------

# MAGIC %sql
# MAGIC
# MAGIC SELECT *
# MAGIC FROM service_data
# MAGIC LIMIT 10;

# COMMAND ----------

# MAGIC %md
# MAGIC **Technician Performance**
# MAGIC Q1. Which technician completed the highest number of service jobs?

# COMMAND ----------

from pyspark.sql.functions import count

technician_performance = silver_df.groupBy("technician_name") \
    .agg(
        count("job_id").alias("total_jobs")
    ) \
    .orderBy("total_jobs", ascending=False)

display(technician_performance)

# COMMAND ----------

# MAGIC %sql
# MAGIC
# MAGIC SELECT
# MAGIC technician_name,
# MAGIC COUNT(job_id) AS total_jobs
# MAGIC
# MAGIC FROM service_data
# MAGIC
# MAGIC GROUP BY technician_name
# MAGIC
# MAGIC ORDER BY total_jobs DESC;

# COMMAND ----------

# MAGIC %md
# MAGIC **Save GOLD table**

# COMMAND ----------

technician_performance.write \
.format("delta") \
.mode("overwrite") \
.saveAsTable("workspace.default.gold_technician_performance")

# COMMAND ----------

display(
spark.table("workspace.default.gold_technician_performance")
)

# COMMAND ----------

# MAGIC %md
# MAGIC Technician Performance Analysis
# MAGIC
# MAGIC This report calculates the total number of service jobs handled by each technician. The results help identify the most active technicians and can be used to evaluate workload distribution within the service center.

# COMMAND ----------

# MAGIC %md
# MAGIC **Job Status Analysis**
# MAGIC Q2.How many jobs are:
# MAGIC
# MAGIC Completed
# MAGIC Pending
# MAGIC Cancelled

# COMMAND ----------

from pyspark.sql.functions import count

job_status = silver_df.groupBy("job_status") \
    .agg(
        count("job_id").alias("total_jobs")
    )

display(job_status)

# COMMAND ----------

# MAGIC %sql
# MAGIC
# MAGIC SELECT
# MAGIC
# MAGIC job_status,
# MAGIC
# MAGIC COUNT(job_id) AS total_jobs
# MAGIC
# MAGIC FROM service_data
# MAGIC
# MAGIC GROUP BY job_status;

# COMMAND ----------

job_status.write \
.format("delta") \
.mode("overwrite") \
.saveAsTable("workspace.default.gold_job_status")

# COMMAND ----------

# MAGIC %md
# MAGIC Job Status Analysis
# MAGIC
# MAGIC This report summarizes the number of service jobs according to their current status. It provides a quick overview of completed, pending, and cancelled jobs, helping management monitor the service workflow.

# COMMAND ----------

# MAGIC %md
# MAGIC **Delay Analysis**
# MAGIC Q3. how many jobs are completed:
# MAGIC ON TIME 
# MAGIC DElay

# COMMAND ----------

delay_analysis = silver_df.groupBy(
    "delivery_status"
).count()

display(delay_analysis)

# COMMAND ----------

# MAGIC %sql
# MAGIC
# MAGIC SELECT
# MAGIC
# MAGIC delivery_status,
# MAGIC
# MAGIC COUNT(*) AS total_jobs
# MAGIC
# MAGIC FROM service_data
# MAGIC
# MAGIC GROUP BY delivery_status;

# COMMAND ----------

delay_analysis.write \
.format("delta") \
.mode("overwrite") \
.saveAsTable("workspace.default.gold_delay_analysis")

# COMMAND ----------

# MAGIC %md
# MAGIC Delay Analysis
# MAGIC
# MAGIC This report compares the number of jobs completed on time with those delivered after the promised date. It helps evaluate service efficiency and customer satisfaction.

# COMMAND ----------

# MAGIC %md
# MAGIC **Repeat Customers**
# MAGIC Q4. Which customers have visited the service center more than once?

# COMMAND ----------

from pyspark.sql.functions import count

repeat_customers = silver_df.groupBy(
    "customer_id",
    "customer_name"
).agg(
    count("job_id").alias("total_visits")
).filter("total_visits > 1")

display(repeat_customers)

# COMMAND ----------

repeat_customers.write \
.format("delta") \
.mode("overwrite") \
.saveAsTable("workspace.default.gold_repeat_customers")

# COMMAND ----------

display(
spark.table("workspace.default.gold_repeat_customers")
)

# COMMAND ----------

# MAGIC %md
# MAGIC This report identifies customers who have visited the service center multiple times. It helps the company understand customer retention and identify customers who frequently use repair services.

# COMMAND ----------

# MAGIC %md
# MAGIC **Device Brand Analysis** Q5. Which device brand receives the highest number of repair requests?

# COMMAND ----------

from pyspark.sql.functions import count

brand_analysis = silver_df.groupBy(
    "brand"
).agg(
    count("job_id").alias("total_repairs")
).orderBy(
    "total_repairs",
    ascending=False
)

display(brand_analysis)

# COMMAND ----------

brand_analysis.write \
.format("delta") \
.mode("overwrite") \
.saveAsTable("workspace.default.gold_brand_analysis")

# COMMAND ----------

# MAGIC %md
# MAGIC This report shows the number of repair requests received for each device brand. It helps identify brands that require frequent servicing and can support inventory planning.

# COMMAND ----------

# MAGIC %md
# MAGIC **Issue Type Analysis**
# MAGIC Q6. Which repair issue occurs most frequently?
# MAGIC
# MAGIC Examples:
# MAGIC
# MAGIC Battery Issue
# MAGIC Screen Damage
# MAGIC Water Damage
# MAGIC Software Problem

# COMMAND ----------

issue_analysis = silver_df.groupBy(
    "issue_type"
).agg(
    count("job_id").alias("total_cases")
).orderBy(
    "total_cases",
    ascending=False
)

display(issue_analysis)

# COMMAND ----------

issue_analysis.write \
.format("delta") \
.mode("overwrite") \
.saveAsTable("workspace.default.gold_issue_analysis")

# COMMAND ----------

# MAGIC %md
# MAGIC This report summarizes the frequency of different repair issues. It helps the service center identify common problems and maintain spare parts accordingly.

# COMMAND ----------

# MAGIC %md
# MAGIC **Monthly Repair Trend**
# MAGIC Q7. How many repair jobs were received each month?

# COMMAND ----------

from pyspark.sql.functions import month

monthly_repairs = silver_df.withColumn(
    "month",
    month("received_date")
).groupBy(
    "month"
).agg(
    count("job_id").alias("total_repairs")
).orderBy("month")

display(monthly_repairs)

# COMMAND ----------

monthly_repairs.write \
.format("delta") \
.mode("overwrite") \
.saveAsTable("workspace.default.gold_monthly_repairs")

# COMMAND ----------

# MAGIC %md
# MAGIC This report displays the number of repair requests received each month. It helps management identify seasonal trends and plan technician availability accordingly.

# COMMAND ----------

# MAGIC %md
# MAGIC **Warranty Analysis**
# MAGIC Q8. How many repairs were covered under warranty?

# COMMAND ----------

silver_df.printSchema()

# COMMAND ----------

warranty_analysis = silver_df.groupBy(
    "warranty_status"
).agg(
    count("job_id").alias("total_jobs")
)

display(warranty_analysis)

# COMMAND ----------

silver_df.select("warranty_months").show(20)

# COMMAND ----------

from pyspark.sql.functions import when

silver_df = silver_df.withColumn(
    "warranty_status",
    when(silver_df.warranty_months > 0, "Under Warranty")
    .otherwise("Out of Warranty")
)

# COMMAND ----------

from pyspark.sql.functions import count

warranty_analysis = silver_df.groupBy(
    "warranty_status"
).agg(
    count("job_id").alias("total_jobs")
)

display(warranty_analysis)

# COMMAND ----------

warranty_analysis.write \
    .format("delta") \
    .mode("overwrite") \
    .saveAsTable("workspace.default.gold_warranty_analysis")

# COMMAND ----------

display(
    spark.table("workspace.default.gold_warranty_analysis")
)

# COMMAND ----------

# MAGIC %md
# MAGIC This report clearly shows that 1500 jobs are under warranty.

# COMMAND ----------

# MAGIC %md
# MAGIC **Repair Cost Analysis**
# MAGIC Q9. Which device brands generate the highest repair costs?

# COMMAND ----------

from pyspark.sql.functions import sum

repair_cost = silver_df.groupBy("brand").agg(
    sum("estimated_cost").alias("total_estimated_cost"),
    sum("actual_cost").alias("total_actual_cost")
).orderBy("total_actual_cost", ascending=False)

display(repair_cost)

# COMMAND ----------

repair_cost.write \
    .format("delta") \
    .mode("overwrite") \
    .saveAsTable("workspace.default.gold_repair_cost")

# COMMAND ----------

# MAGIC %md
# MAGIC **Technician Workload**
# MAGIC Q10. How many jobs are assigned to each technician?

# COMMAND ----------

from pyspark.sql.functions import count

technician_workload = silver_df.groupBy(
    "technician_name"
).agg(
    count("job_id").alias("jobs_assigned")
).orderBy(
    "jobs_assigned",
    ascending=False
)

display(technician_workload)

# COMMAND ----------

technician_workload.write \
    .format("delta") \
    .mode("overwrite") \
    .saveAsTable("workspace.default.gold_technician_workload")

# COMMAND ----------

# MAGIC %md
# MAGIC **Average Repair Duration**
# MAGIC Q11. Which device brands take the longest time to repair?

# COMMAND ----------

from pyspark.sql.functions import avg

repair_duration = silver_df.groupBy(
    "brand"
).agg(
    avg("repair_duration").alias("average_repair_days")
).orderBy(
    "average_repair_days",
    ascending=False
)

display(repair_duration)

# COMMAND ----------

repair_duration.write \
    .format("delta") \
    .mode("overwrite") \
    .saveAsTable("workspace.default.gold_repair_duration")

# COMMAND ----------

# MAGIC %md
# MAGIC **City-wise Service Requests**
# MAGIC Q12.Which cities generate the highest number of repair requests?

# COMMAND ----------

from pyspark.sql.functions import count

city_analysis = silver_df.groupBy(
    "city"
).agg(
    count("job_id").alias("total_jobs")
).orderBy(
    "total_jobs",
    ascending=False
)

display(city_analysis)

# COMMAND ----------

city_analysis.write \
    .format("delta") \
    .mode("overwrite") \
    .saveAsTable("workspace.default.gold_city_analysis")

# COMMAND ----------

# MAGIC %md
# MAGIC **Business Summary**

# COMMAND ----------

from pyspark.sql.functions import count, avg, sum

business_summary = silver_df.agg(
    count("job_id").alias("total_jobs"),
    avg("repair_duration").alias("average_repair_days"),
    sum("actual_cost").alias("total_revenue")
)

display(business_summary)

# COMMAND ----------

business_summary.write \
    .format("delta") \
    .mode("overwrite") \
    .saveAsTable("workspace.default.gold_business_summary")

# COMMAND ----------

display(
    spark.table("workspace.default.gold_business_summary")
)

# COMMAND ----------

spark.sql("SHOW TABLES IN workspace.default").display()

# COMMAND ----------

display(
spark.table("workspace.default.gold_business_summary")
)

# COMMAND ----------

spark.table("gold_warranty_analysis").show()