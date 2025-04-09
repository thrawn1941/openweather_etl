from load.abstract_load_strategy import LoadDataStrategy
from google.cloud import bigquery
import json


class WeatherLoadStrategy(LoadDataStrategy):

    def load_data_to_bigquery(self, data, table_name):
        ### just for one city; function assumes that data is just a dict for one city
        #data = json.dumps(data)
        client = bigquery.Client()

        errors = client.insert_rows_json(
            table_name, data
        )
        if not errors:
            print("Rows have been added.")
        else:
            print("Encountered errors while inserting rows: {}".format(errors))

    def load_temperatue_to_bigquery(self, data, table_name):
        insert_values=[]
        for city in data.keys():
            text = f"('{data[city][0]}', '{city}', {data[city][1]})"
            insert_values.append(text)

        merged_values = ", ".join(insert_values)
        full_insert = f"""INSERT INTO `{table_name}` (ds, City, Temperature) VALUES {merged_values};"""

        try:
            client = bigquery.Client()
            job = client.query(full_insert)
            job.result()
            print("Insert successful.")
        except Exception as e:
            print(f'Error occurred during data insert: {e}')