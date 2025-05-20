import os
import json
import functions_framework
from dotenv import load_dotenv
from extract.geo_extract_strategy import GeoDirectDataStrategy
from extract.pollution_extract_strategy import AirPollutionDataStrategy
from extract.pollution_history_extract_strategy import AirPollutionHistoryDataStrategy
from extract.weather_extract_strategy import WeatherCurrentDataStrategy
from utils_and_wrappers.endpoint import Endpoint
from load.weather_load_strategy import WeatherLoadStrategy
from load.pollution_load_strategy import PollutionLoadStrategy
from load.pollution_history_load_strategy import PollutionHistoryLoadStrategy
from load.geo_load_strategy import GeoLoadStrategy
from utils_and_wrappers.utils import publish_message
from utils_and_wrappers.functions_generator import create_load_function

load_dotenv()
API_KEY = os.getenv('OPEN_WEATHER_API_KEY')
dataset_id = os.getenv('DATASET_ID')
historical_pollution_pubsub_topic = os.getenv('HISTORICAL_POLLUTION_PUBSUB_TOPIC')

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
    print("TESTING create before destroy !!!11")
    result = json.dumps(gathered_data)
    return result, 200

@functions_framework.http
def get_historical_pollution_data(request):
    request_args = request.args
    if request_args and 'start_date' in request_args and 'end_date' in request_args:
        start_date = request_args['start_date']
        end_date = request_args['end_date']
    else:
        return 'End date or start date not provided', 400

    app_weather = Endpoint(AirPollutionHistoryDataStrategy())
    app_weather.append_data_from_cities(api_key=API_KEY, start_date=start_date, end_date=end_date)
    gathered_data = app_weather.return_all_data()

    result = json.dumps(gathered_data)
    publish_message(result, historical_pollution_pubsub_topic)
    print("message published!")
    return result, 200

@functions_framework.http
def get_weather_data(_):
    app_weather = Endpoint(WeatherCurrentDataStrategy())
    app_weather.append_data_from_cities(API_KEY)
    gathered_data = app_weather.return_all_data()

    result = json.dumps(gathered_data)
    return result, 200

### LOAD FUNCTIONS
"""
@functions_framework.cloud_event
def export_raw_weather_to_bigquery(cloud_event):
    imported_data = json.loads(base64.b64decode(cloud_event.data["message"]["data"]))
    if not imported_data:
        print("No data provided!")
        return

    load_app = Load(data=imported_data, target_table='totemic-client-447220-r1.openweather_etl.weather_raw', load_strategy=WeatherLoadStrategy())
    load_app.load_raw_to_bigquery()
"""
@create_load_function(target_table=f'{dataset_id}.weather_raw', load_strategy=WeatherLoadStrategy())
def export_raw_weather_to_bigquery():
    print("Loading raw weather data...")

@create_load_function(target_table=f'{dataset_id}.pollution_raw', load_strategy=PollutionLoadStrategy())
def export_raw_pollution_to_bigquery():
    print("Loading raw pollution data...")

@create_load_function(target_table=f'{dataset_id}.pollution_raw_backup', load_strategy=PollutionLoadStrategy())
def export_bcp_pollution_to_bigquery():
    print("Loading raw pollution historical data...")

@create_load_function(target_table=f'{dataset_id}.pollution_raw', load_strategy=PollutionHistoryLoadStrategy())
def export_hist_pollution_to_bigquery():
    print("Loading pollution historical data...")

@create_load_function(target_table=f'{dataset_id}.geo_raw', load_strategy=GeoLoadStrategy())
def export_raw_geo_to_bigquery():
    print("Loading raw geo data...")

main()