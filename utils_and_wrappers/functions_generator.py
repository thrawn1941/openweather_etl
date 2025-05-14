import base64
import json
from utils_and_wrappers.load import Load
"""
def create_load_function(target_table, load_strategy):
    def wrapper(func):
        def inner(cloud_event):
            imported_data = json.loads(base64.b64decode(cloud_event.data["message"]["data"]))
            if not imported_data:
                print("No data provided!")
                return

            imported_data=func(imported_data)
            load_app = Load(data=imported_data, target_table=target_table,load_strategy=load_strategy)
            load_app.load_raw_to_bigquery()
        return inner
    return wrapper
"""
def create_load_function(target_table, load_strategy):
    def wrapper(func):
        def inner(*args):
            print(args)
        return inner
    return wrapper