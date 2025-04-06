import requests
from extract.abstract_extract_strategy import GetDataStrategy
from extract.geo_extract_strategy import GeoDirectDataStrategy
from datetime import datetime, timedelta
from utils import string_data_to_timestamp_unix

class AirPollutionHistoryDataStrategy(GetDataStrategy):

    @property
    def __name__(self):
        return type(self).__name__

    def get_data(self, **kwargs):
        city, api_key, days_back = kwargs.get('city'), kwargs.get('api_key'), kwargs.get('days')
        lat, lon = GeoDirectDataStrategy.get_lat_and_lon(city=city, api_key=api_key)
        end_date = string_data_to_timestamp_unix(datetime.now().strftime("%d/%m/%Y"))
        start_date = string_data_to_timestamp_unix((datetime.fromtimestamp(end_date) - timedelta(days=days_back)).strftime("%d/%m/%Y"))
        pollution_url = f'http://api.openweathermap.org/data/2.5/air_pollution/history?lat={lat}&lon={lon}&start={start_date}&end={end_date}&appid={api_key}'
        pollution_data = requests.get(pollution_url).json()

        return pollution_data
