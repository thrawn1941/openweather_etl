from abc import ABC, abstractmethod

class LoadDataStrategy(ABC):

    @abstractmethod
    def load_data_to_bigquery(self, data, table_name):
        pass