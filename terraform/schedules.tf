##### schedules for extract functions
resource "google_cloud_scheduler_job" "openweather_extract_workflow" {
  name        = "openweather-extract-schedule"
  description = "Trigger for the openweather-workflow"
  schedule    = "0 * * * *"
  time_zone   = "Europe/Warsaw"
  http_target {
    uri         = "https://workflowexecutions.googleapis.com/v1/${google_workflows_workflow.openweather_workflow.id}/executions"
    http_method = "POST"
    oauth_token {
      service_account_email = "test-account@totemic-client-447220-r1.iam.gserviceaccount.com"
    }
  }
}