import datetime as dt
import os
from dotenv import load_dotenv
# from threading import Thread
# from extract.abstract_get_data_strategy import GetDataStrategy
# from extract.geo_get_data_strategy import GeoDirectDataStrategy
# from extract.pollution_extract_strategy import AirPollutionDataStrategy
# from extract.pollution_history_get_data_strategy import AirPollutionHistoryDataStrategy
from extract.weather_extract_strategy import WeatherCurrentDataStrategy
# from extract.weather_forecast_get_data_strategy import WeatherCurrentForecastDataStrategy
from transform.weather_transform_strategy import WeatherTransformStrategy
from transform_wrapper_class import Transform
from endpoint_class import Endpoint
import functions_framework
import base64
import json
from google.cloud import bigquery

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
    transform_app = Transform(imported_data, WeatherTransformStrategy())
    insert_rows = []
    temp_data = transform_app.transform_strategy.get_temperature()
    for city in temp_data.keys():
        text = f"('{temp_data[city][0]}', '{city}', {temp_data[city][1]})"
        insert_rows.append(text)

    v = ", ".join(insert_rows)
    full_insert = f"""INSERT INTO `totemic-client-447220-r1.city_temperature_data_set.cities_temperature_data` (ds, City, Temperature) VALUES {v};"""

    try:
        client = bigquery.Client()
        job = client.query(full_insert)
        job.result()
        print("Insert successful.")
    except Exception as e:
        print(f'Error occurred during data insert: {e}')

main()