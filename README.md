# Openweather ETL
**Work in progress!!!**

## Temporary Badges
![Static Badge](https://img.shields.io/badge/ETL-yellow)
![Static Badge](https://img.shields.io/badge/Python-3.11-blue?logo=python)
![Static Badge](https://img.shields.io/badge/Terraform-7B42BC?style=flat&logo=terraform)
![Static Badge](https://img.shields.io/badge/GCP-yellow?logo=google%20cloud)
![Static Badge](https://img.shields.io/badge/CI%2FCD-green)
![Static Badge](https://img.shields.io/badge/GitHub_Actions-grey?logo=github%20actions)
![Static Badge](https://img.shields.io/badge/pyTest-blue?logo=pytest)

## Introduction
Although the project is named "openweather_etl", its current implementation works more accurately as a Python-based connector that loads weather and air quality data from the OpenWeatherMap API into Google BigQuery. As such, the architecture aligns more closely with an ELT (Extract, Load, Transform) pattern rather than a traditional ETL pipeline, although the transform step is, for now, purely conceptual.

In addition to data ingestion, the project also focuses on automation: code deployment is orchestrated via GitHub Actions, while the underlying infrastructure is provisioned using Terraform. This dual approach ensures both data operations and infrastructure management are streamlined and reproducible.

