variable "storage_bucket_name" {
  type=string
  description="Name of google storage bucket"
}
variable "storage_bucket_object_name" {
  type=string
  description="Name of google storage bucket object"
}
variable "function_name_in_gcp" {
  type=string
  description="Function's name used in GCP"
}
variable "function_description" {
  type=string
  description="Function's description"
}
variable "location" {
  type=string
  description="Function's location"
}
variable "function_name_in_source_code" {
  type=string
  description="Function's name in source code"
}
variable "instances" {
  type=number
  description="Max number of function's instances"
}
variable "memory" {
  type=string
  description="Memory assigned to the function"
}
variable "env_vars" {
  type = map(string)
  description="Env variables required by an extract function"
  #default = {
  #  OPEN_WEATHER_API_KEY = "abc123"
  #  NODE_ENV             = "production"
  #  LOG_LEVEL            = "debug"
  #}
}
variable "role_type" {
  type=string
  description="Role type assigned in function_iam_member"
}
variable "service_account" {
  type=string
  description="Service account used in function_iam_member"
}
variable "create_pubsub" {
  type=bool
  description="Determines whether a PubSub topic related to the function should be created"
}
variable "function_depends_on" {
  type = any
  description="Source files required to deploy the function"
}