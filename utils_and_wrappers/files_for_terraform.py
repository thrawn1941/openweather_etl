import os

config_path = os.getcwd().strip("utils_and_wrappers") + "config\\project_id"
config_path = config_path.replace('\\', '/')
file = open(config_path,"r")
current_project = file.read()

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

def create_openweather_workflow_file(region, project_id, functions_list):
    file_path = path + "openweather_workflow.yml"
    file_path = file_path.replace('\\', '/')
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

def main():
    create_geo_workflow_file(region="europe-central2", project_id=current_project, function_name="extract_geo_data", topic_name="extract_geo_data-topic")
    create_openweather_workflow_file(region="europe-central2", project_id=current_project, functions_list=["extract_pollution_data", "extract_weather_data"])
main()