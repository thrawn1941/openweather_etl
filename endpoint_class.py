from extract.abstract_extract_strategy import GetDataStrategy
import asyncio

class Endpoint:
    id_list = []

    def __init__(self, get_data_strategy: GetDataStrategy):
        self.get_data_strategy = get_data_strategy
        self.collected_data = dict()
        self.id = 0 if len(Endpoint.id_list) == 0 else max(Endpoint.id_list) + 1
        Endpoint.id_list.append(self.id)

    def print_data(self, city, api_key):
        data = self.get_data_strategy.get_data(city, api_key)
        print(data)

    def append_data(self, city, api_key):
        if self.collected_data.get(city) is None:
            self.collected_data[city] = []

        data = self.get_data_strategy.get_data(city, api_key)
        self.collected_data[city] = data

    def append_data_from_cities(self, api_key, *cities):
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

    def get_temperature(self):
        from datetime import datetime
        result = dict()
        for key in self.collected_data.keys():
            data = self.collected_data.get(key)
            temp = round(data['main']['temp'] - 273.15, 2)
            dt = data['dt']
            dt = datetime.fromtimestamp(dt)
            dt = dt.strftime("%Y-%m-%d %H:%M:%S")
            result[key] = (temp, dt)

        return result