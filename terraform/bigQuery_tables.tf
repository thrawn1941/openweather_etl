resource "google_bigquery_table" "weather_raw" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "weather_raw"
  schema = file("./support_files/schemas/bq_raw_weather_schema.json")
}
resource "google_bigquery_table" "pollution_raw" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "pollution_raw"
  schema = file("./support_files/schemas/bq_raw_pollution_schema.json")
}
resource "google_bigquery_table" "pollution_raw_backup" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "pollution_raw_backup"
  schema = file("./support_files/schemas/bq_raw_pollution_schema.json")
}
resource "google_bigquery_table" "geo_raw" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "geo_raw"
  schema = file("./support_files/schemas/bq_raw_geo_schema.json")
}
resource "google_bigquery_table" "weather" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "Weather"
  schema = file("./support_files/schemas/bq_weather_schema.json")
  time_partitioning {
    type  = "DAY"
    field = "dt"
  }
}
resource "google_bigquery_table" "pollution" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "Pollution"
  schema = file("./support_files/schemas/bq_pollution_schema.json")
  time_partitioning {
    type  = "DAY"
    field = "dt"
  }
}