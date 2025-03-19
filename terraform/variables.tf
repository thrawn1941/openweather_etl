variable "project_id" {
  type=string
  description="Google Cloud project id"
}
variable "region" {
  type=string
  description="Google Cloud region"
  default="europe-central2"
}
variable "gcp_credentials" {
  type=string
  description="Google Cloud credentials in json format"
  sensitive=true
}
variable "open_weather_api_key" {
  description = "API key for OpenWeather"
  type        = string
  sensitive   = true
}