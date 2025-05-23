resource "google_bigquery_data_transfer_config" "geo" {
  display_name           = "geo"
  location               = "EU"
  data_source_id         = "scheduled_query"
  schedule               = "1 of month 12:30"
  destination_dataset_id = google_bigquery_dataset.default.dataset_id
  params = {
    destination_table_name_template = "geo"
    write_disposition               = "WRITE_TRUNCATE"
    query                           = file("./support_files/geo_transfer.sql")
  }
  depends_on = [google_project_service.gcp_services]
}
resource "google_bigquery_data_transfer_config" "weather" {
  display_name           = "weather"
  location               = "EU"
  data_source_id         = "scheduled_query"
  schedule               = "every 60 minutes"
  destination_dataset_id = google_bigquery_dataset.default.dataset_id
  params = {
    destination_table_name_template = "Weather"
    write_disposition               = "WRITE_APPEND"
    query                           = file("./support_files/weather_transfer.sql")
  }
  schedule_options {
    start_time           = var.weather_transfer_start_time
  }
  depends_on = [google_project_service.gcp_services]
}
resource "google_bigquery_data_transfer_config" "pollution" {
  display_name           = "pollution"
  location               = "EU"
  data_source_id         = "scheduled_query"
  schedule               = "every 60 minutes"
  destination_dataset_id = google_bigquery_dataset.default.dataset_id
  params = {
    destination_table_name_template = "Pollution"
    write_disposition               = "WRITE_APPEND"
    query                           = file("./support_files/pollution_transfer.sql")
  }
  schedule_options {
    start_time           = var.pollution_transfer_start_time
  }
  depends_on = [google_project_service.gcp_services]
}