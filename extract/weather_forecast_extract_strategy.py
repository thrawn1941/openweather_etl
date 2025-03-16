import requests
from extract.abstract_extract_strategy import GetDataStrategy
from extract.geo_extract_strategy import GeoDirectDataStrategy


class WeatherCurrentForecastDataStrategy(GetDataStrategy):

    @property
    def __name__(self):
        return type(self).__name__

    def get_data(self, city, api_key, forecast_days):
        lat, lon = GeoDirectDataStrategy.get_lat_and_lon(city, api_key)
        weather_url = f'https://api.openweathermap.org/data/2.5/forecast/daily?lat={lat}&lon={lon}&cnt={forecast_days}&appid={api_key}'
        print(weather_url)
        weather_data = requests.get(weather_url).json()

        return weather_data