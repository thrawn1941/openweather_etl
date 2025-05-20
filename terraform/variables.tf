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
variable "functions_invoker_role" {
  type=string
  description="Invoker role for functions"
  default = "roles/cloudfunctions.invoker"
}
variable "service_account" {
  type=string
  description="Service account"
  default = "serviceAccount:test-account@totemic-client-447220-r1.iam.gserviceaccount.com"
}
variable "main_py_version" {
  type=number
  description="Crude versioning for .zip file"
  default = 3
}