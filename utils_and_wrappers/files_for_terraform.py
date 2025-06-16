import os
from utils_and_wrappers.utils import read_config

config_values = read_config()
current_project = config_values['project_id']
bucket_name = config_values['state_bucket_name']

terraform_path = os.getcwd().strip("utils_and_wrappers") + "terraform\\"
terraform_path = terraform_path.replace('\\', '/')
def create_geo_workflow_file(region, project_id, function_name, topic_name):
    file_path=terraform_path+"support_files/geo_workflow.yml"

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

def create_openweather_workflow_file(region, project_id, functions_list):
    file_path = terraform_path + "support_files/openweather_workflow.yml"
    functions_text=''
    for function in functions_list:
        functions_text+=f'\n                - {function}'

    text=f"""    - init:
        assign:
            - results : {{}} # result from each iteration keyed by table name
            - functions:{functions_text}
    - runQueries:
        parallel:
            shared: [results]
            for:
                value: func
                in: ${{functions}}
                steps:
                  - call_function:
                      call: http.get
                      args:
                        url: ${{"https://{region}-{project_id}.cloudfunctions.net/" + func}}
                        auth:
                          type: OIDC
                      result: function_response
                  - publish_to_pubsub:
                      call: googleapis.pubsub.v1.projects.topics.publish
                      args:
                        topic: ${{"projects/{project_id}/topics/" + func + "-topic"}}
                        body:
                          messages:
                            - data: ${{base64.encode(text.encode(function_response.body))}}
                      result: pubsub_response
                  - returnResult:
                      assign:
                          - results[func]: ${{pubsub_response}}
    - returnResults:
        return: ${{results}}"""

    with open(file_path, "w") as file:
        file.write(text)

backend_code="""terraform {
  backend "gcs" {
    bucket  = "%s"
    prefix  = "terraform/state"
  }
}"""

def create_backend_file(state_bucket_name):
    file_path = terraform_path + "backend.tf"
    final_backend_code =  backend_code % state_bucket_name

    with open(file_path, "w") as file:
        file.write(final_backend_code)

def main():
    create_geo_workflow_file(region="europe-central2", project_id=current_project, function_name="extract_geo_data", topic_name="extract_geo_data-topic")
    create_openweather_workflow_file(region="europe-central2", project_id=current_project, functions_list=["extract_pollution_data", "extract_weather_data"])
    create_backend_file(bucket_name)
main()