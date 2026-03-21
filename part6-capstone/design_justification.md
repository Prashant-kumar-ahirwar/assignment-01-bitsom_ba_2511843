# Design Justification

## Storage Systems

To support the four goals of the AI-powered hospital system, multiple storage systems are used, each optimized for a specific purpose.

An **OLTP database (PostgreSQL/MySQL)** is used for storing real-time operational data such as patient records, admissions, treatments, and billing information. This system ensures fast and reliable transactions required for daily hospital operations.

A **Data Lake (AWS S3 / Hadoop)** is used to store large volumes of raw and historical data, including medical records, doctor notes, and lab reports. This data is useful for training machine learning models, especially for predicting patient readmission risk.

A **Data Warehouse (Snowflake / BigQuery)** is used for analytical processing and reporting. Hospital management can generate monthly reports such as bed occupancy, department-wise costs, and patient trends using this system. It is optimized for complex queries and aggregations.

A **Vector Database (Pinecone / FAISS)** is used to enable natural language queries. Patient records are converted into embeddings, allowing doctors to search patient history using plain English queries. This improves usability and accessibility of medical data.

A **Time-Series Database (InfluxDB / TimescaleDB)** is used to store real-time ICU monitoring data such as heart rate, oxygen levels, and blood pressure. These databases are optimized for continuous time-based data streams.

Using multiple storage systems ensures efficiency, scalability, and performance for different types of workloads.

---

## OLTP vs OLAP Boundary

The system clearly separates transactional processing (OLTP) from analytical processing (OLAP) to maintain performance and scalability.

The **OLTP layer** includes systems like Electronic Health Records (EHR) and Hospital Management Systems, which handle real-time operations such as patient updates, admissions, and billing. These systems require fast response times and frequent updates.

The **OLAP layer** includes the Data Warehouse and Data Lake, where data is stored for analysis, reporting, and machine learning. Data from OLTP systems is periodically transferred to the OLAP layer using ETL pipelines.

For example, historical patient data stored in the Data Lake is used to train machine learning models for readmission prediction. Similarly, the Data Warehouse is used to generate monthly hospital reports.

This separation ensures that heavy analytical queries do not affect the performance of real-time hospital operations.

---

## Trade-offs

One major trade-off in this architecture is **increased system complexity** due to the use of multiple storage systems and data pipelines.

While using specialized databases improves performance and scalability, it also introduces challenges such as data synchronization, higher infrastructure costs, and maintenance overhead.

To mitigate this, the system can use **automated data pipelines and orchestration tools** like Apache Airflow to ensure smooth and reliable data movement between systems. Additionally, implementing **data validation and monitoring tools** helps maintain data consistency and quality.

Despite the complexity, this design provides flexibility and efficiency, making it suitable for modern AI-driven healthcare applications.