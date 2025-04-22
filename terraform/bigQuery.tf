resource "google_bigquery_dataset" "default" {
  dataset_id                  = "openweather_etl"
  friendly_name               = "openweather ETL"
  description                 = "Data set to store data extracted from openweathermap.org"
  location                    = "EU"

  labels = {
    env = "default"
  }
}

resource "google_bigquery_table" "weather_raw" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "weather_raw"
  schema = jsonencode(var.bq_weather_schema)
}

resource "google_bigquery_table" "pollution_raw" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "pollution_raw"
  schema = jsonencode(var.bq_pollution_schema)
}

resource "google_bigquery_table" "geo_raw" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "geo_raw"
  schema = jsonencode(var.bq_geo_schema)
}
resource "google_bigquery_data_transfer_config" "geo" {
  display_name           = "geo"
  location               = "EU"
  data_source_id         = "scheduled_query"
  schedule               = "every day 14:15"
  destination_dataset_id = google_bigquery_dataset.default.dataset_id
  params = {
    destination_table_name_template = "geo"
    write_disposition               = "WRITE_TRUNCATE"
    query                           = "SELECT  name as city, ANY_VALUE(lat) as lat, ANY_VALUE(lon) as lon, ANY_VALUE(country) as country, ANY_VALUE(state) as state FROM `totemic-client-447220-r1.openweather_etl.geo_raw` GROUP BY name"
  }
}