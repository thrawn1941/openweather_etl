from abc import ABC, abstractmethod
from google.cloud import bigquery

class LoadDataStrategy(ABC):

    @abstractmethod
    def dummy_load(self, data, table_name):
        pass

    def load_data_to_bigquery(self, data, table_name, data_format='dict'):
        """
        Takes data for one city and loads it to a BigQuery table.

        :param data: Data as a dict.
        :param table_name: Full (with project id and dataset) target table name.
        :return: None, actually. Function prints error if it fails or communicates success otherwise.
        """
        client = bigquery.Client()

        if data_format == 'dict':
            errors = client.insert_rows_json(
                table_name, [data]          # insert_rows_json() expects list of dicts, so we need to embedd the dict into a list
            )
            if not errors:
                print("Rows have been added.")
            else:
                print("Encountered errors while inserting rows: {}".format(errors))
        elif data_format == 'dataframe':
            job_config = bigquery.LoadJobConfig(
                write_disposition=bigquery.WriteDisposition.WRITE_APPEND
            )
            job = client.load_table_from_dataframe(data, table_name, job_config=job_config)
            job.result()
            print(f"Loaded {job.output_rows} into {table_name}")
        else:
            print('Incorrect data format. Currently available data formats: dict, dataframe')

    def transform_before_load(self, data):
        return data
