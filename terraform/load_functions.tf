locals {
  load_functions = {
    load_raw_weather_to_bigquery = {
      function_description            = "Function loading raw weather data to BigQuery"
      region                          = var.region
      function_name_in_source_code    = "export_raw_weather_to_bigquery"
      storage_bucket_name             = google_storage_bucket.bucket_for_functions.name
      storage_bucket_object_name      = google_storage_bucket_object.archive.name
      pubsub_topic_id                 = "projects/${var.project_id}/topics/extract_weather_data-topic"
      instances                       = 1
      memory                          = "512Mi"
      env_vars                        = {
        OPEN_WEATHER_API_KEY = var.open_weather_api_key
        DATASET_ID           = google_bigquery_dataset.default.dataset_id
        PROJECT_ID           = var.project_id
      }
      role_type                       = var.functions_invoker_role
      service_account                 = var.service_account
    }
    load_raw_pollution_to_bigquery = {
      function_description            = "Function loading raw pollution data to BigQuery"
      region                          = var.region
      function_name_in_source_code    = "export_raw_pollution_to_bigquery"
      storage_bucket_name             = google_storage_bucket.bucket_for_functions.name
      storage_bucket_object_name      = google_storage_bucket_object.archive.name
      pubsub_topic_id                 = "projects/${var.project_id}/topics/extract_pollution_data-topic"
      instances                       = 1
      memory                          = "512Mi"
      env_vars                        = {
        OPEN_WEATHER_API_KEY = var.open_weather_api_key
        DATASET_ID           = google_bigquery_dataset.default.dataset_id
        PROJECT_ID           = var.project_id
      }
      role_type                       = var.functions_invoker_role
      service_account                 = var.service_account
    }
    load_raw_geo_to_bigquery = {
      function_description            = "Function loading raw geo data to BigQuery"
      region                          = var.region
      function_name_in_source_code    = "export_raw_geo_to_bigquery"
      storage_bucket_name             = google_storage_bucket.bucket_for_functions.name
      storage_bucket_object_name      = google_storage_bucket_object.archive.name
      pubsub_topic_id                 = "projects/${var.project_id}/topics/extract_geo_data-topic"
      instances                       = 1
      memory                          = "512Mi"
      env_vars                        = {
        OPEN_WEATHER_API_KEY = var.open_weather_api_key
        DATASET_ID           = google_bigquery_dataset.default.dataset_id
        PROJECT_ID           = var.project_id
      }
      role_type                       = var.functions_invoker_role
      service_account                 = var.service_account
    }
    load_bcp_pollution_to_bigquery = {
      function_description            = "Function loading raw historical pollution data as backup to BigQuery"
      region                          = var.region
      function_name_in_source_code    = "export_bcp_pollution_to_bigquery"
      storage_bucket_name             = google_storage_bucket.bucket_for_functions.name
      storage_bucket_object_name      = google_storage_bucket_object.archive.name
      pubsub_topic_id                 = "projects/${var.project_id}/topics/extract_historical_pollution_data-topic"
      instances                       = 1
      memory                          = "512Mi"
      env_vars                        = {
        OPEN_WEATHER_API_KEY = var.open_weather_api_key
        DATASET_ID           = google_bigquery_dataset.default.dataset_id
        PROJECT_ID           = var.project_id
      }
      role_type                       = var.functions_invoker_role
      service_account                 = var.service_account
    }
    load_hist_pollution_to_bigquery = {
      function_description            = "Function loading (historical) pollution data to BigQuery"
      region                          = var.region
      function_name_in_source_code    = "export_hist_pollution_to_bigquery"
      storage_bucket_name             = google_storage_bucket.bucket_for_functions.name
      storage_bucket_object_name      = google_storage_bucket_object.archive.name
      pubsub_topic_id                 = "projects/${var.project_id}/topics/extract_historical_pollution_data-topic"
      instances                       = 1
      memory                          = "512Mi"
      env_vars                        = {
        OPEN_WEATHER_API_KEY = var.open_weather_api_key
        DATASET_ID           = google_bigquery_dataset.default.dataset_id
        PROJECT_ID           = var.project_id
      }
      role_type                       = var.functions_invoker_role
      service_account                 = var.service_account
    }
  }
}

module "load_functions" {
  for_each = local.load_functions
  source   = "./modules/load_functions"

  function_name_in_gcp         = each.key
  function_description         = each.value.function_description
  region                       = each.value.region
  function_name_in_source_code = each.value.function_name_in_source_code
  storage_bucket_name          = each.value.storage_bucket_name
  storage_bucket_object_name   = each.value.storage_bucket_object_name
  pubsub_topic_id              = each.value.pubsub_topic_id
  instances                    = each.value.instances
  memory                       = each.value.memory
  env_vars                     = each.value.env_vars
  role_type                    = each.value.role_type
  service_account              = each.value.service_account

  depends_on = [module.extract_functions]
}