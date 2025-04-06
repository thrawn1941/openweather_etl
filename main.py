import datetime as dt
import os
import base64
import json
import functions_framework
from dotenv import load_dotenv
from extract.geo_extract_strategy import GeoDirectDataStrategy
from extract.pollution_extract_strategy import AirPollutionDataStrategy
from extract.pollution_history_extract_strategy import AirPollutionHistoryDataStrategy
from extract.weather_extract_strategy import WeatherCurrentDataStrategy
from transform.weather_transform_strategy import WeatherTransformStrategy
from transform_wrapper_class import Transform
from endpoint_class import Endpoint
from load.weather_load_strategy import WeatherLoadStrategy
from utils import publish_message

GLOBAL_START_DATE=dt.datetime(2020, 12, 1, 0, 0)
GLOBAL_END_DATE=dt.datetime(2021, 1, 1, 0, 0)
GLOBAL_FORECAST_DAYS=4

load_dotenv()
API_KEY = os.getenv('OPEN_WEATHER_API_KEY')
LAST_MONTH_TOPIC_ID = os.getenv('LAST_MONTH_TOPIC_ID')
API_KEY2 = os.getenv('ACCOUNT_API_KEY')


def main():
    pass

### EXTRACT FUNCTIONS
@functions_framework.http
def get_geo_data(_):
    app_weather = Endpoint(GeoDirectDataStrategy())
    app_weather.append_data_from_cities(API_KEY)
    gathered_data = app_weather.return_all_data()

    result = json.dumps(gathered_data)
    return result, 200

@functions_framework.http
def get_pollution_data(_):
    app_weather = Endpoint(AirPollutionDataStrategy())
    app_weather.append_data_from_cities(API_KEY)
    gathered_data = app_weather.return_all_data()

    result = json.dumps(gathered_data)
    return result, 200

@functions_framework.http
def get_last_day_pollution_data(_):
    app_weather = Endpoint(AirPollutionHistoryDataStrategy())
    app_weather.append_data_from_cities(API_KEY, 1)
    gathered_data = app_weather.return_all_data()

    result = json.dumps(gathered_data)
    return result, 200

@functions_framework.http
def get_last_week_pollution_data(_):
    app_weather = Endpoint(AirPollutionHistoryDataStrategy())
    app_weather.append_data_from_cities(API_KEY, 7)
    gathered_data = app_weather.return_all_data()

    result = json.dumps(gathered_data)
    return result, 200

@functions_framework.http
def get_last_month_pollution_data(_):
    app_weather = Endpoint(AirPollutionHistoryDataStrategy())
    app_weather.append_data_from_cities(API_KEY, 30)
    gathered_data = app_weather.return_all_data()

    result = json.dumps(gathered_data)
    publish_message(result, LAST_MONTH_TOPIC_ID)
    print("message published!")
    return result, 200

@functions_framework.http
def get_weather_data(_):
    app_weather = Endpoint(WeatherCurrentDataStrategy())
    app_weather.append_data_from_cities(API_KEY)
    gathered_data = app_weather.return_all_data()

    result = json.dumps(gathered_data)
    return result, 200

@functions_framework.http
def get_temperature_data(_):
    app_weather = Endpoint(WeatherCurrentDataStrategy())
    app_weather.append_data_from_cities(API_KEY)
    gathered_data = app_weather.return_all_data()

    result = json.dumps(gathered_data)
    return result, 200


### LOAD FUNCTIONS
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