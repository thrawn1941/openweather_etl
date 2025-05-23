##### workflow for extract functions
resource "google_workflows_workflow" "openweather_workflow" {
  name            = "openweather-workflow"
  region          = "europe-central2"
  description     = "A workflow to run openweather extract functions"
  service_account = trimprefix(var.service_account, "serviceAccount:")

  source_contents = file("./support_files/openweather_workflow.yml")

}
##### workflow for extract raw geo data
resource "google_workflows_workflow" "geo_workflow" {
  name            = "geo-workflow"
  region          = "europe-central2"
  description     = "Workflow exporting raw geo data to pubsub"
  service_account = trimprefix(var.service_account, "serviceAccount:")

  source_contents = file("./support_files/geo_workflow.yml")

}