import pytest
import requests
from get_data.geo_get_data_strategy import GeoDirectDataStrategy
import os
from dotenv import load_dotenv

load_dotenv()
api_key = os.getenv('OPEN_WEATHER_API_KEY')

@pytest.mark.parametrize("input1, expected_result", [
    ('Warsaw', (52.2297, 21.0122)),
    ('London', (51.509865, -0.118092)),
    ('New York City', (40.73061, -73.935242)),
])
def test_weather_get_data(input1, expected_result):
    result = GeoDirectDataStrategy().get_data(input1, api_key)
    assert (result[0]['lat'], result[0]['lon']) == pytest.approx(expected_result, rel=0.1)
