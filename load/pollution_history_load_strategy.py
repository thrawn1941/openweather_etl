from load.abstract_load_strategy import LoadDataStrategy
from google.cloud import bigquery

class PollutionHistoryLoadStrategy(LoadDataStrategy):

    def dummy_load(self, data, table_name):
        pass

    def load_data_to_bigquery(self, data, table_name, data_format='dict'):
        ### just for one city; function assumes that data is just a dict for one city
        #data = json.dumps(data)
        client = bigquery.Client()

        if data_format == 'dict':
            errors = client.insert_rows_json(
                table_name, data
            )
            if not errors:
                print("Rows have been added.")
            else:
                print("Encountered errors while inserting rows: {}".format(errors))

    def transform_before_load(self, data):
        dataframes = dict()
        for city in data.keys():
            records = data[city]["list"]
            lon_lat = {"lon": data[city]["coord"]["lon"], "lat": data[city]["coord"]["lat"]}
            output = []
            for record in records:
                x = dict()
                x['list'] = [record]
                x['coord'] = lon_lat
                output.append(x)
            dataframes[city] = output

        return dataframes