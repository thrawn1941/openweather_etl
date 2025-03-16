import requests
from extract.abstract_extract_strategy import GetDataStrategy
from extract.geo_extract_strategy import GeoDirectDataStrategy


class AirPollutionDataStrategy(GetDataStrategy):

    @property
    def __name__(self):
        return type(self).__name__

    def get_data(self, city, api_key):
        lat, lon = GeoDirectDataStrategy.get_lat_and_lon(city, api_key)
        pollution_url = f'http://api.openweathermap.org/data/2.5/air_pollution?lat={lat}&lon={lon}&appid={api_key}'
        pollution_data = requests.get(pollution_url).json()

        return pollution_data
