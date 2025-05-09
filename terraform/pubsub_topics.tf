### historical_pollution_data
resource "google_pubsub_topic" "extract_historical_pollution" {
  name = "get_historical_pollution_data"
}