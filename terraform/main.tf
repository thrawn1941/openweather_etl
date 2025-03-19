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

  depends_on = [google_project_service.default]
}