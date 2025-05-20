output "dataset_dataset_id" {
  value = google_bigquery_dataset.default.dataset_id
}
output "dataset_id" {
  value = google_bigquery_dataset.default.id
}

locals {
  pubsub_ids = {
    for k, m in module.extract_functions :
    k => m.pubsub_topic_id
  }
}
output "module_pubsub_ids" {
  value = local.pubsub_ids
}