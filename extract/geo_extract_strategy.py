import requests
from extract.abstract_extract_strategy import GetDataStrategy


class GeoDirectDataStrategy(GetDataStrategy):

    def get_data(self, city, api_key):
        geo_url = f'http://api.openweathermap.org/geo/1.0/direct?q={city}&limit=1&appid={api_key}'
        geo_data = requests.get(geo_url).json()

        return geo_data

    @staticmethod
    def get_lat_and_lon(city, api_key):
        geo_url = f'http://api.openweathermap.org/geo/1.0/direct?q={city}&limit=1&appid={api_key}'
        geo_data = requests.get(geo_url).json()
        lat, lon = geo_data[0]['lat'], geo_data[0]['lon']

        return lat, lon