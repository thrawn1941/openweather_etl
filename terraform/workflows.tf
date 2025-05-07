##### workflow for extract functions
resource "google_workflows_workflow" "openweather_workflow" {
  name            = "openweather-workflow"
  region          = "europe-central2"
  description     = "A workflow to run openweather extract functions"
  service_account = "test-account@totemic-client-447220-r1.iam.gserviceaccount.com"

  source_contents = file("./support_files/openweather_workflow.yml")

}
##### workflow for extract raw geo data
resource "google_workflows_workflow" "geo_workflow" {
  name            = "geo-workflow"
  region          = "europe-central2"
  description     = "Workflow exporting raw geo data to pubsub"
  service_account = "test-account@totemic-client-447220-r1.iam.gserviceaccount.com"

  source_contents = <<-EOF
    main:
      params: [input]
      steps:
        - call_function:
            call: http.get
            args:
              url: https://europe-central2-totemic-client-447220-r1.cloudfunctions.net/get_geo_data_tf
              auth:
                type: OIDC
            result: function_response
        - publish_to_pubsub:
            call: googleapis.pubsub.v1.projects.topics.publish
            args:
              topic: projects/totemic-client-447220-r1/topics/get_geo_data-topic
              body:
                messages:
                  - data: $${base64.encode(text.encode(function_response.body))}
            result: pubsub_response
        - return_results:
            return: $${pubsub_response}
  EOF

}