import base64
import json
from utils_and_wrappers.load import Load
def create_load_function(target_table, load_strategy):
    """
    The function to which the decorator is applied should only perform the necessary data transformation before sending it to BigQuery.

    :param target_table: name of the target table
    :param load_strategy: strategy adjusted to the type of data (pollution/ weather/ etc.)
    :return: function that loads data to BigQuery
    """
    def wrapper(func):
        def inner(*args):
            imported_data = json.loads(base64.b64decode(args[0]["data"]))
            if not imported_data:
                print("No data provided!")
                return

            imported_data=func(imported_data)
            load_app = Load(data=imported_data, target_table=target_table,load_strategy=load_strategy)
            load_app.load_raw_to_bigquery()
        return inner
    return wrapper