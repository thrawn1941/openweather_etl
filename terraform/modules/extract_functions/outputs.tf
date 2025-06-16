output "pubsub_topic_id" {
  value = google_pubsub_topic.default_topic[0].id
}