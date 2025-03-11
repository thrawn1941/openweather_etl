from abc import ABC, abstractmethod

class LoadDataStrategy(ABC):

    @abstractmethod
    def load_to_bigquery(self):
        pass