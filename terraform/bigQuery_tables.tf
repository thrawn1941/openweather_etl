

resource "google_bigquery_table" "weather_raw" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "weather_raw"
  schema = jsondecode(bq_weather_schema)
}

resource "google_bigquery_table" "pollution_raw" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "pollution_raw"
  schema = jsonencode(var.bq_pollution_schema)
}

resource "google_bigquery_table" "pollution_raw_backup" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "pollution_raw_backup"
  schema = jsonencode(var.bq_pollution_schema)
}

resource "google_bigquery_table" "geo_raw" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "geo_raw"
  schema = jsonencode(var.bq_geo_schema)
}
