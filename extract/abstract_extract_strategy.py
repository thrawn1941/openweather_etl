from abc import ABC, abstractmethod

class GetDataStrategy(ABC):
    @abstractmethod
    def get_data(self, city, api_key, days):
        pass