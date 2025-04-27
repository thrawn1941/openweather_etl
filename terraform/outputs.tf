output "dataset_id" {
  value = google_bigquery_dataset.default.dataset_id
}
output "pollution_history_pubsub_id" {
  value = google_pubsub_topic.extract_historical_pollution.id
}