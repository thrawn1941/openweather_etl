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
variable "functions_source_dir" {
  description = "path to source code functions"
  type        = string
  default     = "../"
}
variable "extract_functions" {
  type = list(string)
  description = "List of the extraction functions to export"
  default = ["get_geo_data", "get_pollution_data", "get_last_day_pollution_data", "get_last_week_pollution_data", "get_weather_data"]
}