import requests
from extract.abstract_extract_strategy import GetDataStrategy
from extract.geo_extract_strategy import GeoDirectDataStrategy


class WeatherCurrentDataStrategy(GetDataStrategy):

    @property
    def __name__(self):
        return type(self).__name__

    def get_data(self, city, api_key):
        lat, lon = GeoDirectDataStrategy.get_lat_and_lon(city, api_key)
        weather_url = f'https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={api_key}'
        weather_data = requests.get(weather_url).json()

        return weather_data
