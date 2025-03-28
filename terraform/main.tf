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
resource "google_workflows_workflow" "default" {
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
                        url: $${"https://europe-central2-totemic-client-447220-r1.cloudfunctions.net/" + func}
                        auth:
                          type: OIDC
                      result: function_response
                  - publish_to_pubsub:
                      call: googleapis.pubsub.v1.projects.topics.publish
                      args:
                        topic: projects/totemic-client-447220-r1/topics/demo-topic
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
resource "google_storage_bucket" "bucket_for_functions" {
  name     = "functions-bucket-spec-111"
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
resource "google_cloudfunctions_function" "get_geo_data" {
  name        = "get_geo_data_tf"
  description = "My function"
  runtime     = "python311"


  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket_for_functions.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  entry_point           = "get_geo_data"

  environment_variables = {
    OPEN_WEATHER_API_KEY = var.open_weather_api_key
  }
}

# IAM entry for all users to invoke the function
# resource "google_cloudfunctions_function_iam_member" "invoker" {
#   project        = google_cloudfunctions_function.function.project
#   region         = google_cloudfunctions_function.function.region
#   cloud_function = google_cloudfunctions_function.function.name
#
#   role   = "roles/cloudfunctions.invoker"
#   member = "allUsers"
# }
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.get_geo_data.project
  region         = google_cloudfunctions_function.get_geo_data.region
  cloud_function = google_cloudfunctions_function.get_geo_data.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:test-account@totemic-client-447220-r1.iam.gserviceaccount.com"
}
