resource "google_bigquery_dataset" "default" {
  dataset_id                  = "openweather_etl"
  friendly_name               = "openweather ETL"
  description                 = "Data set to store data extracted from openweathermap.org"
  location                    = "EU"

  labels = {
    env = "default"
  }
}