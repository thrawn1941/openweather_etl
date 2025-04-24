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
from endpoint import Endpoint
from load.weather_load_strategy import WeatherLoadStrategy
from load.pollution_load_strategy import PollutionLoadStrategy
from load.geo_load_strategy import GeoLoadStrategy
from utils import publish_message
from load_wrapper_class import Load

load_dotenv()
API_KEY = os.getenv('OPEN_WEATHER_API_KEY')
LAST_MONTH_TOPIC_ID = os.getenv('LAST_MONTH_TOPIC_ID')


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
def export_raw_weather_to_bigquery(cloud_event):
    imported_data = json.loads(base64.b64decode(cloud_event.data["message"]["data"]))
    if not imported_data:
        print("No data provided!")
        return

    load_app = Load(data=imported_data, target_table='totemic-client-447220-r1.openweather_etl.weather_raw', load_strategy=WeatherLoadStrategy())
    load_app.load_raw_to_bigquery()

@functions_framework.cloud_event
def export_raw_pollution_to_bigquery(cloud_event):
    imported_data = json.loads(base64.b64decode(cloud_event.data["message"]["data"]))
    if not imported_data:
        print("No data provided!")
        return

    load_app = Load(data=imported_data, target_table='totemic-client-447220-r1.openweather_etl.pollution_raw', load_strategy=PollutionLoadStrategy())
    load_app.load_raw_to_bigquery()

@functions_framework.cloud_event
def export_raw_geo_to_bigquery(cloud_event):
    try:
        imported_data = json.loads(base64.b64decode(cloud_event.data["message"]["data"]))
        if not imported_data:
            print("No data provided!")
            return
    except Exception as e:
        print("ERROR OCCURED!")
        print(e)


    load_app = Load(data=imported_data, target_table='totemic-client-447220-r1.openweather_etl.geo_raw', load_strategy=GeoLoadStrategy())
    load_app.load_raw_to_bigquery()

main()