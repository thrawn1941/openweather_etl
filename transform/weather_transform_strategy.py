from transform.abstract_transform_strategy import TransformDataStrategy
from utils import temp_to_celcius, timestamp_to_string_data

class WeatherTransformStrategy(TransformDataStrategy):

    def transform_data(self):
        cities = self.data.keys()
        result = dict()
        for city in cities:
            city_data = self.data.get(city)
            ds = timestamp_to_string_data(city_data['dt'], "%Y-%m-%d %H:%M:%S")
            temp = temp_to_celcius(city_data['main']['temp'])
            feels_like = temp_to_celcius(city_data['main']['feels_like'])
            temp_min = temp_to_celcius(city_data['main']['temp_min'])
            temp_max = temp_to_celcius(city_data['main']['temp_max'])
            pressure = city_data['main']['pressure']
            humidity = city_data['main']['humidity']
            sea_level = city_data['main']['sea_level']
            grnd_level = city_data['main']['grnd_level']
            visibility = city_data['visibility']
            wind_speed = city_data['wind']['speed']
            wind_deg = city_data['wind']['deg']
            clouds_all = city_data['clouds']['all']

            result[city] = {
                "city": city,
                "ds": ds,
                "temp": temp,
                "feels_like": feels_like,
                "temp_min": temp_min,
                "temp_max": temp_max,
                "pressure": pressure,
                "humidity": humidity,
                "sea_level": sea_level,
                "grnd_level": grnd_level,
                "visibility": visibility,
                "wind_speed": wind_speed,
                "wind_deg": wind_deg,
                "clouds_all": clouds_all
            }
        return result

    def get_cities_list(self):
        return list(self.data.keys())

    def get_temperature(self):
        cities = self.data.keys()
        result = dict()
        for city in cities:
            city_data = self.data.get(city)
            temp = temp_to_celcius(city_data['main']['temp'])
            dt = timestamp_to_string_data(city_data['dt'], "%Y-%m-%d %H:%M:%S")
            result[city] =  (dt, temp)
        return result