import datetime as dt
import os
import base64
import json
import functions_framework
from dotenv import load_dotenv
from extract.weather_extract_strategy import WeatherCurrentDataStrategy
from transform.weather_transform_strategy import WeatherTransformStrategy
from transform_wrapper_class import Transform
from endpoint_class import Endpoint
from load.weather_load_strategy import WeatherLoadStrategy

GLOBAL_START_DATE=dt.datetime(2020, 12, 1, 0, 0)
GLOBAL_END_DATE=dt.datetime(2021, 1, 1, 0, 0)
GLOBAL_FORECAST_DAYS=4

load_dotenv()
API_KEY = os.getenv('OPEN_WEATHER_API_KEY')


def main():
    pass

@functions_framework.http
def get_warsaw_temperature(_):
    app_weather = Endpoint(WeatherCurrentDataStrategy())
    app_weather.append_data_from_cities(API_KEY, 'Warsaw')
    a = app_weather.return_data('Warsaw')
    result = a['main']['temp'] - 273.15
    temperature = '{:.2f}'.format(result)

    return (f"Current temperature in Warsaw: {temperature}", 200)

@functions_framework.cloud_event
def hello_pubsub(cloud_event):
    # Print out the data from Pub/Sub, to prove that it worked
    print(base64.b64decode(cloud_event.data["message"]["data"]))

@functions_framework.http
def get_temperature_data(_):
    cities = []
    with open("config", "r", encoding="utf-8") as f:
        for line in f:
            cities.append(line.strip())

    app_weather = Endpoint(WeatherCurrentDataStrategy())
    app_weather.append_data_from_cities(API_KEY, *cities)
    gathered_data = app_weather.return_all_data()
    result = json.dumps(gathered_data)
    return (result, 200)

@functions_framework.cloud_event
def export_temperature_to_bigquery(cloud_event):
    imported_data = base64.b64decode(cloud_event.data["message"]["data"])
    if not imported_data:
        print("No data provided!")
        return

    imported_data = json.loads(imported_data)

    transform_app = Transform(imported_data, WeatherTransformStrategy(imported_data))
    temp_data = transform_app.transform_strategy.get_temperature()

    load_app = WeatherLoadStrategy()
    target_table ='totemic-client-447220-r1.city_temperature_data_set.cities_temperature_data'
    load_app.load_temperatue_to_bigquery(temp_data, target_table)

main()