# Databricks notebook source
# MAGIC %md
# MAGIC # **Phase 1 - Silver Layer(Cleaning data and transformations)**

# COMMAND ----------

# MAGIC %md
# MAGIC **Read Bronze Tables**

# COMMAND ----------

df_customers = spark.table("workspace.default.bronze_customers")

df_devices = spark.table("workspace.default.bronze_devices")

df_jobs = spark.table("workspace.default.bronze_service_jobs")

# COMMAND ----------

display(df_jobs)

# COMMAND ----------

# MAGIC %md
# MAGIC **Check the Schema**

# COMMAND ----------

df_customers.printSchema()

df_devices.printSchema()

df_jobs.printSchema()

# COMMAND ----------

# MAGIC %md
# MAGIC **Remove Duplicate Records**

# COMMAND ----------

df_jobs = df_jobs.dropDuplicates(["job_id"])

# COMMAND ----------

# MAGIC %md
# MAGIC **Check Missing Values**

# COMMAND ----------

from pyspark.sql.functions import col, sum

df_jobs.select([
    sum(col(c).isNull().cast("int")).alias(c)
    for c in df_jobs.columns
]).show()

# COMMAND ----------

# MAGIC %md
# MAGIC **Handle Missing Values**

# COMMAND ----------

from pyspark.sql.functions import lit

df_jobs = df_jobs.fillna({
    "technician_name": "Not Assigned"
})

# COMMAND ----------

# MAGIC %md
# MAGIC **Convert Date Columns**

# COMMAND ----------


from pyspark.sql.functions import to_date

df_jobs = df_jobs.withColumn(
    "received_date",
    to_date("received_date")
)

df_jobs = df_jobs.withColumn(
    "promised_date",
    to_date("promised_date")
)

df_jobs = df_jobs.withColumn(
    "completed_date",
    to_date("completed_date")
)

# COMMAND ----------

df_jobs.printSchema()

# COMMAND ----------

# MAGIC %md
# MAGIC **Calculate Repair Duration**

# COMMAND ----------

from pyspark.sql.functions import datediff

df_jobs = df_jobs.withColumn(
    "repair_duration",
    datediff("completed_date", "received_date")
)

# COMMAND ----------

df_jobs.select(
    "job_id",
    "repair_duration"
).show(10)

# COMMAND ----------

# MAGIC %md
# MAGIC **Create Delivery Status**

# COMMAND ----------

from pyspark.sql.functions import when, col

df_jobs = df_jobs.withColumn(
    "delivery_status",
    when(
        col("completed_date") > col("promised_date"),
        "Delayed"
    ).otherwise("On Time")
)

# COMMAND ----------

    df_jobs.select(
    "job_id",
    "delivery_status"
).show(5)

# COMMAND ----------

# MAGIC %md
# MAGIC **Join the Three Tables**

# COMMAND ----------


silver_df = df_jobs.join(
    df_customers,
    on="customer_id",
    how="left"
)

silver_df = silver_df.join(
    df_devices,
    on="device_id",
    how="left"
)

# COMMAND ----------

display(silver_df)

# COMMAND ----------

# MAGIC %md
# MAGIC **Data Quality Report**

# COMMAND ----------

print("Total Records :", silver_df.count())

print("Total Columns :", len(silver_df.columns))

print("Duplicate Jobs Removed")

print("Date Columns Converted")

print("Delivery Status Created")

# COMMAND ----------

# MAGIC %md
# MAGIC **Save the Silver Table**

# COMMAND ----------

silver_df.write \
    .format("delta") \
    .mode("overwrite") \
    .saveAsTable("workspace.default.silver_service_track")

# COMMAND ----------

display(
    spark.table("workspace.default.silver_service_track")
)

# COMMAND ----------

# MAGIC %md
# MAGIC Q1. Why we use Silver Layer?
# MAGIC Ans: In this phase, the raw data from the Bronze Layer was cleaned and transformed. Duplicate records were removed, date columns were converted into the correct format, repair duration was calculated, and the delivery status of each job was identified. Finally, the customer, device, and service job datasets were combined into a single table and saved as a Silver Delta table for further analysis.