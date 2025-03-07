import pytest
import requests
from get_data.weather_extract_strategy import WeatherCurrentDataStrategy
import os
from dotenv import load_dotenv

load_dotenv()
api_key = os.getenv('OPEN_WEATHER_API_KEY')

@pytest.fixture
def get_test_data():
    lat, lon = 52.2297, 21.0122

    weather_url = f'https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={api_key}'
    weather_data = requests.get(weather_url).json()

    return weather_data


def test_weather_get_data(get_test_data):
    result = WeatherCurrentDataStrategy().get_data('Warsaw', api_key)
    assert result == get_test_data
