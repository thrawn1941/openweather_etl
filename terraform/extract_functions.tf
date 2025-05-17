locals {
  extract_functions = {
    extract_geo_data = {
      function_description         = "Function for geo data extraction"
      location                     = var.region
      function_name_in_source_code = "get_geo_data"
      storage_bucket_name          = google_storage_bucket.bucket_for_functions.name
      storage_bucket_object_name   = google_storage_bucket_object.archive.name
      instances                    = 1
      memory                       = "512Mi"
      env_vars                     = {
        OPEN_WEATHER_API_KEY = var.open_weather_api_key
      }
      role_type                    = var.functions_invoker_role
      service_account              = var.service_account
      create_pubsub                = true
    }
    extract_pollution_data = {
      function_description         = "Function for pollution data extraction"
      location                     = var.region
      function_name_in_source_code = "get_pollution_data"
      storage_bucket_name          = google_storage_bucket.bucket_for_functions.name
      storage_bucket_object_name   = google_storage_bucket_object.archive.name
      instances                    = 1
      memory                       = "512Mi"
      env_vars                     = {
        OPEN_WEATHER_API_KEY = var.open_weather_api_key
      }
      role_type                    = var.functions_invoker_role
      service_account              = var.service_account
      create_pubsub                = true
    }
    extract_weather_data = {
      function_description         = "Function for weather data extraction"
      location                     = var.region
      function_name_in_source_code = "get_weather_data"
      storage_bucket_name          = google_storage_bucket.bucket_for_functions.name
      storage_bucket_object_name   = google_storage_bucket_object.archive.name
      instances                    = 1
      memory                       = "512Mi"
      env_vars                     = {
        OPEN_WEATHER_API_KEY = var.open_weather_api_key
      }
      role_type                    = var.functions_invoker_role
      service_account              = var.service_account
      create_pubsub                = true
    }
    extract_historical_pollution_data = {
      function_description            = "Function for weather data extraction"
      location                        = var.region
      function_name_in_source_code    = "get_historical_pollution_data"
      storage_bucket_name             = google_storage_bucket.bucket_for_functions.name
      storage_bucket_object_name      = google_storage_bucket_object.archive.name
      instances                       = 1
      memory                          = "512Mi"
      env_vars                        = {
        OPEN_WEATHER_API_KEY = var.open_weather_api_key
        HISTORICAL_POLLUTION_PUBSUB_TOPIC = "projects/${var.project_id}/topics/extract_historical_pollution_data-topic"
        ACCOUNT_API_KEY = var.gcp_credentials
      }
      role_type                       = var.functions_invoker_role
      service_account                 = var.service_account
      create_pubsub                   = true
    }

  }
}
module "extract_functions" {
  for_each = local.extract_functions
  source   = "./modules/extract_functions"

  function_name_in_gcp         = each.key
  function_description         = each.value.function_description
  location                     = each.value.location
  function_name_in_source_code = each.value.function_name_in_source_code
  storage_bucket_name          = each.value.storage_bucket_name
  storage_bucket_object_name   = each.value.storage_bucket_object_name
  instances                    = each.value.instances
  memory                       = each.value.memory
  env_vars                     = each.value.env_vars
  role_type                    = each.value.role_type
  service_account              = each.value.service_account
  create_pubsub                = each.value.create_pubsub
}