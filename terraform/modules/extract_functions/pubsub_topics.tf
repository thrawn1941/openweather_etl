resource "google_pubsub_topic" "default_topic" {
  name = "${google_cloudfunctions2_function.default_extract.name}-topic"
}