import requests
from get_data.abstract_get_data_strategy import GetDataStrategy
from get_data.geo_get_data_strategy import GeoDirectDataStrategy


class AirPollutionDataStrategy(GetDataStrategy):

    def get_data(self, city, api_key):
        lat, lon = GeoDirectDataStrategy.get_lat_and_lon(city, api_key)
        pollution_url = f'http://api.openweathermap.org/data/2.5/air_pollution?lat={lat}&lon={lon}&appid={api_key}'
        pollution_data = requests.get(pollution_url).json()

        return pollution_data
