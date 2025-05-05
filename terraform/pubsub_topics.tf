resource "google_pubsub_topic" "extract_functions_topics" {
  for_each = toset(var.extract_functions)
  name = "${each.key}-topic"
}
### historical_pollution_data
resource "google_pubsub_topic" "extract_historical_pollution" {
  name = "get_historical_pollution_data"
}
### historical_weather_data
resource "google_pubsub_topic" "extract_historical_weather" {
  name = "get_historical_weather_data"
}