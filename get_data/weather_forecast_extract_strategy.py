import requests
from get_data.abstract_extract_strategy import GetDataStrategy
from get_data.geo_extract_strategy import GeoDirectDataStrategy


class WeatherCurrentForecastDataStrategy(GetDataStrategy):

    def __init__(self, forecast_days):
        self.forecast_days = forecast_days

    def get_data(self, city, api_key, forecast_days):
        lat, lon = GeoDirectDataStrategy.get_lat_and_lon(city, api_key)
        weather_url = f'https://api.openweathermap.org/data/2.5/forecast/daily?lat={lat}&lon={lon}&cnt={self.forecast_days}&appid={api_key}'
        weather_data = requests.get(weather_url).json()

        return weather_data