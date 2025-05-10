output "dataset_id" {
  value = google_bigquery_dataset.default.dataset_id
}
output "pollution_history_pubsub_id" {
  value = google_pubsub_topic.extract_historical_pollution.id
}
#output "module_pubsub_ids" {
#  value = {
#    for k, m in module.extract_functions :
#    k => m.pubsub_topic_id
#  }
#}

locals {
  pubsub_ids = {
    for k, m in module.extract_functions :
    k => m.pubsub_topic_id
  }
}
output "module_pubsub_ids" {
  value = local.pubsub_ids
}