# Databricks notebook source
# MAGIC %md
# MAGIC #  Phase 1 - Bronze Layer(Load the raw data)

# COMMAND ----------

# MAGIC %md
# MAGIC **Import Required Libraries**

# COMMAND ----------

from pyspark.sql import SparkSession

# COMMAND ----------

# MAGIC %md
# MAGIC **Define File Paths**

# COMMAND ----------

customers_path = "/Volumes/workspace/default/servicetrack_data/customers.csv"

devices_path = "/Volumes/workspace/default/servicetrack_data/devices.csv"

jobs_path = "/Volumes/workspace/default/servicetrack_data/service_jobs.csv"

# COMMAND ----------

# MAGIC %md
# MAGIC **Load the CSV Files**

# COMMAND ----------

df_customers = spark.read.csv(
    customers_path,
    header=True,
    inferSchema=True
)

df_devices = spark.read.csv(
    devices_path,
    header=True,
    inferSchema=True
)

df_jobs = spark.read.csv(
    jobs_path,
    header=True,
    inferSchema=True
)

# COMMAND ----------

# MAGIC %md
# MAGIC **Display the Data**

# COMMAND ----------

display(df_customers)

# COMMAND ----------

# MAGIC %md
# MAGIC **Check the Schema**

# COMMAND ----------

df_customers.printSchema()

df_devices.printSchema()

df_jobs.printSchema()

# COMMAND ----------

# MAGIC %md
# MAGIC **Count Records**

# COMMAND ----------

print("Customers :", df_customers.count())

print("Devices :", df_devices.count())

print("Jobs :", df_jobs.count())

# COMMAND ----------

# MAGIC %md
# MAGIC **Check for Missing Values**

# COMMAND ----------

display(df_customers.describe())

# COMMAND ----------

display(df_devices.describe())

# COMMAND ----------

display(df_jobs.describe())

# COMMAND ----------

# MAGIC %md
# MAGIC **Save Data as Bronze Tables**

# COMMAND ----------

df_customers.write \
.format("delta") \
.mode("overwrite") \
.saveAsTable("workspace.default.bronze_customers")

# COMMAND ----------

df_devices.write \
.format("delta") \
.mode("overwrite") \
.saveAsTable("workspace.default.bronze_devices")

# COMMAND ----------

df_jobs.write \
.format("delta") \
.mode("overwrite") \
.saveAsTable("workspace.default.bronze_service_jobs")

# COMMAND ----------

# MAGIC %md
# MAGIC **Verify the Bronze Tables**

# COMMAND ----------

bronze_customers = spark.table("workspace.default.bronze_customers")

display(bronze_customers)

# COMMAND ----------

# MAGIC %md
# MAGIC **Brief insights about Why we create bronze layer and what actions we performed under this :-**

# COMMAND ----------

# MAGIC %md
# MAGIC Q1. What is the purpose of the Bronze Layer?
# MAGIC Ans: Bronze layer act as a backup layer . we load the raw data as it is in bronze layer without any modifications. It ensures that no data or information is lost before data cleaning and transformations.
# MAGIC
# MAGIC Q2. Why did we use Delta tables?
# MAGIC Ans: Delta tables are used to store data in an efficient way.They support ACID transactions, which help keep the data accurate and consistent.In addition, they offer better performance for reading and writing data.They are commonly used in Databricks to build Medallion Architecture pipelines.
# MAGIC
# MAGIC Q3. Why did we use inferSchema=True?
# MAGIC Ans: allows Apache Spark to automatically identify the correct data type for each column.This reduces manual effort, minimizes data type errors, and makes data processing and analysis more accurate and efficient.