terraform {
  required_providers {
    google={
      source="hashicorp/google"
      version= "~> 6.0.0"
    }
  }
}
provider "google" {
  project=var.project_id
  region=var.region
  credentials = var.gcp_credentials
}
##### EXTRACT FUNCTIONS ########################################
resource "google_storage_bucket" "bucket_for_functions" {
  name     = "functions-bucket-openweather-etl"
  location = var.region
}
data "archive_file" "function_source" {
  type        = "zip"
  source_dir  = var.functions_source_dir
  output_path = "${path.module}/functions-source.zip"
}
resource "google_storage_bucket_object" "archive" {
  name   = "functions-source.zip"
  bucket = google_storage_bucket.bucket_for_functions.name
  source = data.archive_file.function_source.output_path
}

resource "google_cloudfunctions2_function" "extract_functions" {
  for_each = toset(var.extract_functions)

  name        = "${each.key}_tf"
  description = "Function to extract geo data"
  location    = var.region

  build_config {
    runtime = "python311"
    entry_point = each.key
    source {
      storage_source {
        bucket = google_storage_bucket.bucket_for_functions.name
        object = google_storage_bucket_object.archive.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "128Mi"
    environment_variables = {
      OPEN_WEATHER_API_KEY = var.open_weather_api_key
    }
  }
}
#########################################################################################################
##### pubsub topics for each extract function
resource "google_pubsub_topic" "extract_functions_topics" {
  for_each = toset(var.extract_functions)
  name = "${each.key}-topic"
}
#########################################################################################################

resource "google_workflows_workflow" "test_workflow" {
  name            = "test-workflow"
  region          = "europe-central2"
  description     = "A test workflow"
  service_account = "test-account@totemic-client-447220-r1.iam.gserviceaccount.com"

  source_contents = <<-EOF
    - init:
        assign:
            - results : {} # result from each iteration keyed by table name
            - functions:
                - get_geo_data
                - get_last_day_pollution_data
                #- get_last_month_pollution_data
                - get_last_week_pollution_data
                - get_pollution_data
                - get_weather_data
    - runQueries:
        parallel:
            shared: [results]
            for:
                value: func
                in: $${functions}
                steps:
                  - call_function:
                      call: http.get
                      args:
                        url: $${"https://europe-central2-totemic-client-447220-r1.cloudfunctions.net/" + func + "_tf"}
                        auth:
                          type: OIDC
                      result: function_response
                  - publish_to_pubsub:
                      call: googleapis.pubsub.v1.projects.topics.publish
                      args:
                        topic: $${"projects/totemic-client-447220-r1/topics/" + func + "-topic"}
                        body:
                          messages:
                            - data: $${base64.encode(text.encode(function_response.body))}
                      result: pubsub_response
                  - returnResult:
                      assign:
                          - results[func]: $${pubsub_response}
    - returnResults:
        return: $${results}
  EOF

}

resource "google_cloud_scheduler_job" "test_workflow" {
  name        = "test-workflow-schedule"
  description = "Trigger for the test-workflow"
  schedule    = "0 * * * *"
  time_zone   = "Europe/Warsaw"
  http_target {
    uri         = "https://${google_workflows_workflow.test_workflow.id}"
    http_method = "POST"
    oauth_token {
      service_account_email = "test-account@totemic-client-447220-r1.iam.gserviceaccount.com"
    }
  }
}
# resource "google_cloudfunctions_function" "get_geo_data" {
#   name        = "get_geo_data_tf"
#   description = "My function"
#   runtime     = "python311"
#
#
#   available_memory_mb   = 128
#   source_archive_bucket = google_storage_bucket.bucket_for_functions.name
#   source_archive_object = google_storage_bucket_object.archive.name
#   trigger_http          = true
#   entry_point           = "get_geo_data"
#
#   environment_variables = {
#     OPEN_WEATHER_API_KEY = var.open_weather_api_key
#   }
# }

resource "google_cloudfunctions2_function_iam_member" "invoker" {
  for_each = google_cloudfunctions2_function.extract_functions

  project        = each.value.project
  location       = each.value.location
  cloud_function = each.value.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:test-account@totemic-client-447220-r1.iam.gserviceaccount.com"
}
