import os

path = os.getcwd().strip("utils_and_wrappers") + "terraform\\support_files\\"
def create_geo_workflow_file(region, project_id, function_name, topic_name):
    file_path=path+"geo_workflow.yml"
    file_path = file_path.replace('\\', '/')

    text = f"""    main:
      params: [input]
      steps:
        - call_function:
            call: http.get
            args:
              url: https://{region}-{project_id}.cloudfunctions.net/{function_name}
              auth:
                type: OIDC
            result: function_response
        - publish_to_pubsub:
            call: googleapis.pubsub.v1.projects.topics.publish
            args:
              topic: projects/{project_id}/topics/{topic_name}
              body:
                messages:
                  - data: ${{base64.encode(text.encode(function_response.body))}}
            result: pubsub_response
        - return_results:
            return: ${{pubsub_response}}"""
    with open(file_path, "w") as file:
        file.write(text)

def main():
    create_geo_workflow_file(region="europe-central2", project_id="totemic-client-447220-r1", function_name="extract_geo_data", topic_name="extract_geo_data-topic")
main()