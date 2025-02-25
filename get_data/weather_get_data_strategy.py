import requests
from get_data.abstract_get_data_strategy import GetDataStrategy
from get_data.geo_get_data_strategy import GeoDirectDataStrategy


class WeatherCurrentDataStrategy(GetDataStrategy):

    def get_data(self, city, api_key):
        lat, lon = GeoDirectDataStrategy.get_lat_and_lon(city, api_key)
        weather_url = f'https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={api_key}'
        weather_data = requests.get(weather_url).json()

        return weather_data
