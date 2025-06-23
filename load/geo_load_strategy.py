from load.abstract_load_strategy import LoadDataStrategy
from google.cloud import bigquery


class GeoLoadStrategy(LoadDataStrategy):

    def dummy_load(self, data, table_name):
        pass

    def load_data_to_bigquery(self, data, table_name, data_format):
        """
                Takes data for one city and loads it to a BigQuery table.

                :param data: Data as a dict.
                :param table_name: Full (with project id and dataset) target table name.
                :return: None, actually. Function prints error if it fails or communicates success otherwise.
        """
        client = bigquery.Client()

        errors = client.insert_rows_json(
            table_name, data          # geo data comes as dict inside a list, so we don't need to embedd the data
        )
        if not errors:
            print("Rows have been added.")
        else:
            print("Encountered errors while inserting rows: {}".format(errors))