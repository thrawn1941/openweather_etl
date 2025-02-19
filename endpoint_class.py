from get_data.abstract_get_data_strategy import GetDataStrategy

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
        self.collected_data[city].append(data)