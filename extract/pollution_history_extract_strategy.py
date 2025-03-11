import requests
from extract.abstract_extract_strategy import GetDataStrategy
from extract.geo_extract_strategy import GeoDirectDataStrategy


class AirPollutionHistoryDataStrategy(GetDataStrategy):

    def __init__(self, start_date, end_date):
        self.start_date = start_date
        self.end_date = end_date

    def get_data(self, city, api_key):
        lat, lon = GeoDirectDataStrategy.get_lat_and_lon(city, api_key)
        pollution_url = f'http://api.openweathermap.org/data/2.5/air_pollution/history?lat={lat}&lon={lon}&start={self.start_date}&end={self.end_date}&appid={api_key}'
        pollution_data = requests.get(pollution_url).json()

        return pollution_data
