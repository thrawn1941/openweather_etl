from extract.abstract_extract_strategy import GetDataStrategy
from utils import get_cities_from_config
import asyncio

class Endpoint:
    id_list = []

    def __init__(self, get_data_strategy: GetDataStrategy):
        self.get_data_strategy = get_data_strategy
        self.collected_data = dict()
        self.id = 0 if len(Endpoint.id_list) == 0 else max(Endpoint.id_list) + 1
        Endpoint.id_list.append(self.id)

    def print_data(self, city):
        print(self.collected_data[city])

    def print_all_data(self):
        print(self.collected_data)

    def return_data(self, city):
        return self.collected_data[city]

    def return_all_data(self):
        return self.collected_data

    def append_data_from_cities(self, api_key):
        if self.get_data_strategy.__name__ in ['AirPollutionHistoryDataStrategy', 'WeatherCurrentForecastDataStrategy']:
            raise Exception('Privided strategy cannot perform this action!')

        cities = get_cities_from_config()
        if len(cities) < 1:
            raise Exception('The "cities" list should not be empty')

        async def async_get_city_data(city_name):
            data = self.get_data_strategy.get_data(city_name, api_key)
            self.collected_data[city_name] = data
            return 1

        async def gather_data():
            tasks = [async_get_city_data(city) for city in cities]
            results = await asyncio.gather(*tasks)
            return results

        asyncio.run(gather_data())

    def append_last_n_days_pollution(self, api_key, n):
        if self.get_data_strategy.__name__ != 'AirPollutionHistoryDataStrategy':
            raise Exception('Privided strategy cannot perform this action!')

        cities = get_cities_from_config()

        if len(cities) < 1:
            raise Exception('The "cities" list should not be empty')

        async def async_get_city_data(city_name):
            data = self.get_data_strategy.get_data(city_name, api_key, n)
            self.collected_data[city_name] = data
            return 1

        async def gather_data():
            tasks = [async_get_city_data(city) for city in cities]
            results = await asyncio.gather(*tasks)
            return results

        asyncio.run(gather_data())

    def append_n_days_weather_forecast(self, api_key, n):
        if self.get_data_strategy.__name__ != 'WeatherCurrentForecastDataStrategy':
            raise Exception('Privided strategy cannot perform this action!')

        cities = get_cities_from_config()

        if len(cities) < 1:
            raise Exception('The "cities" list should not be empty')
        if n > 16:
            raise Exception('Forecast longer than 16 days is not supported!')

        async def async_get_city_data(city_name):
            data = self.get_data_strategy.get_data(city_name, api_key, n)
            self.collected_data[city_name] = data
            return 1

        async def gather_data():
            tasks = [async_get_city_data(city) for city in cities]
            results = await asyncio.gather(*tasks)
            return results

        asyncio.run(gather_data())