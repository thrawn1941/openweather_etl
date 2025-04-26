from abc import ABC, abstractmethod

class GetDataStrategy(ABC):
    @abstractmethod
    def get_data(self, city, api_key, start_date, end_date, forecast_days):
        pass