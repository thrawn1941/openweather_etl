from transform.abstract_transform_strategy import TransformDataStrategy
from datetime import datetime

class WeatherTransformStrategy(TransformDataStrategy):

    def fake_transform(self):
        pass

    def get_cities_list(self):
        return list(self.data.keys())

    def get_temperature(self):
        cities = self.data.keys()
        result = dict()
        for city in cities:
            city_data = self.data.get(city)
            temp = round(city_data['main']['temp'] - 273.15, 2)
            dt = city_data['dt']
            dt = datetime.fromtimestamp(dt)
            dt = dt.strftime("%Y-%m-%d %H:%M:%S")
            result[city] =  (dt, temp)
        return result