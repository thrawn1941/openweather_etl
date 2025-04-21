from abc import ABC, abstractmethod
from google.cloud import bigquery

class LoadDataStrategy(ABC):

    @abstractmethod
    def dummy_load(self, data, table_name):
        pass

    def load_data_to_bigquery(self, data, table_name):
        """
        Takes data for one city and loads it to a BigQuery table.

        :param data: Data as a dict.
        :param table_name: Full (with project id and dataset) target table name.
        :return: None, actually. Function prints error if it fails or communicates success otherwise.
        """
        client = bigquery.Client()

        errors = client.insert_rows_json(
            table_name, [data]          # insert_rows_json() expects list of dicts, so we need to embedd the dict into a list
        )
        if not errors:
            print("Rows have been added.")
        else:
            print("Encountered errors while inserting rows: {}".format(errors))