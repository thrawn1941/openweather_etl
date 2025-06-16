resource "google_pubsub_topic" "default_topic" {
  count = var.create_pubsub ? 1 : 0
  name = "${google_cloudfunctions2_function.default_extract.name}-topic"
}