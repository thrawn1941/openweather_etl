import datetime as dt
import os
from dotenv import load_dotenv
from threading import Thread
# from get_data.abstract_get_data_strategy import GetDataStrategy
# from get_data.geo_get_data_strategy import GeoDirectDataStrategy
from get_data.pollution_get_data_strategy import AirPollutionDataStrategy
# from get_data.pollution_history_get_data_strategy import AirPollutionHistoryDataStrategy
from get_data.weather_get_data_strategy import WeatherCurrentDataStrategy
# from get_data.weather_forecast_get_data_strategy import WeatherCurrentForecastDataStrategy
from endpoint_class import Endpoint
import functions_framework
import base64
import json


GLOBAL_START_DATE=dt.datetime(2020, 12, 1, 0, 0)
GLOBAL_END_DATE=dt.datetime(2021, 1, 1, 0, 0)
GLOBAL_FORECAST_DAYS=4

load_dotenv()
API_KEY = os.getenv('OPEN_WEATHER_API_KEY')


def main():
    app_pollution = Endpoint(AirPollutionDataStrategy())
    app_weather = Endpoint(WeatherCurrentDataStrategy())

    t1 = Thread(target=app_pollution.append_data, args=['Warsaw', API_KEY])
    t2 = Thread(target=app_pollution.append_data, args=['London', API_KEY])

    t1.start()
    t2.start()
    t1.join()
    t2.join()

    t1 = Thread(target=app_weather.append_data, args=['Warsaw', API_KEY])
    t2 = Thread(target=app_weather.append_data, args=['London', API_KEY])

    t1.start()
    t2.start()
    t1.join()
    t2.join()

    a = app_weather.collected_data.get('Warsaw')
    b = app_weather.collected_data.get('London')
    c = app_weather.get_temperature()
    print(a)
    print("---------------------------------------------")
    print(b)
    print("---------------------------------------------")
    print(c)

@functions_framework.http
def get_warsaw_temperature(_):
    app_weather = Endpoint(WeatherCurrentDataStrategy())
    app_weather.append_data('Warsaw', API_KEY)
    a = app_weather.collected_data.get('Warsaw')
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
    gathered_data = app_weather.append_data_from_cities(API_KEY, *cities)
    result = json.dumps(gathered_data)
    print(result)
    return (result, 200)

main()