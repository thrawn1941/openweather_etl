##### schedules for extract functions
resource "google_cloud_scheduler_job" "test_workflow" {
  name        = "test-workflow-schedule"
  description = "Trigger for the test-workflow"
  schedule    = "0 * * * *"
  time_zone   = "Europe/Warsaw"
  http_target {
    uri         = "https://workflowexecutions.googleapis.com/v1/${google_workflows_workflow.test_workflow.id}/executions"
    http_method = "POST"
    oauth_token {
      service_account_email = "test-account@totemic-client-447220-r1.iam.gserviceaccount.com"
    }
  }
}