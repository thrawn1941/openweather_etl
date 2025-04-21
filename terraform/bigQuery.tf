resource "google_bigquery_dataset" "default" {
  dataset_id                  = "openweather_etl"
  friendly_name               = "openweather ETL"
  description                 = "Data set to store data extracted from openweathermap.org"
  location                    = "EU"

  labels = {
    env = "default"
  }
}

resource "google_bigquery_table" "weather" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "weather"

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "current-weather"
  }

  schema = <<EOF
[
  {
    "name": "city",
    "type": "STRING",
    "mode": "REQUIRED",
    "description": "City"
  },
  {
    "name": "ds",
    "type": "DATETIME",
    "mode": "REQUIRED",
    "description": "Timestamp"
  },
  {
    "name": "temp",
    "type": "NUMERIC",
    "mode": "NULLABLE",
    "description": "Temperature"
  },
  {
    "name": "feels_like",
    "type": "NUMERIC",
    "mode": "NULLABLE",
    "description": "Feels like temperature"
  },
  {
    "name": "temp_min",
    "type": "NUMERIC",
    "mode": "NULLABLE",
    "description": "Min. temperature"
  },
  {
    "name": "temp_max",
    "type": "NUMERIC",
    "mode": "NULLABLE",
    "description": "Max. temperature"
  },
  {
    "name": "pressure",
    "type": "INT64",
    "mode": "NULLABLE",
    "description": "Pressure"
  },
  {
    "name": "humidity",
    "type": "INT64",
    "mode": "NULLABLE",
    "description": "Humidity"
  },
  {
    "name": "sea_level",
    "type": "INT64",
    "mode": "NULLABLE",
    "description": "Sea level"
  },
  {
    "name": "grnd_level",
    "type": "INT64",
    "mode": "NULLABLE",
    "description": "Ground level"
  },
  {
    "name": "visibility",
    "type": "INT64",
    "mode": "NULLABLE",
    "description": "Visibility"
  },
  {
    "name": "wind_speed",
    "type": "NUMERIC",
    "mode": "NULLABLE",
    "description": "Temperature"
  },
  {
    "name": "wind_deg",
    "type": "INT64",
    "mode": "NULLABLE",
    "description": "Wind speed"
  },
  {
    "name": "clouds_all",
    "type": "INT64",
    "mode": "NULLABLE",
    "description": "Clouds"
  }
]
EOF

}
resource "google_bigquery_table" "geo" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "geo"
  schema = <<EOF
[
  {
    "name": "city",
    "type": "STRING",
    "mode": "REQUIRED",
    "description": "City"
  },
  {
    "name": "state",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "State"
  },
  {
    "name": "country",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "Country"
  },
  {
    "name": "lat",
    "type": "FLOAT",
    "mode": "REQUIRED",
    "description": "Latitude"
  },
  {
    "name": "lon",
    "type": "FLOAT",
    "mode": "REQUIRED",
    "description": "Longitude"
  }
]
EOF

}
resource "google_bigquery_table" "pollution" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "pollution"
  schema = <<EOF
[
  {
    "name": "city",
    "type": "STRING",
    "mode": "REQUIRED",
    "description": "City"
  },
  {
    "name": "dt",
    "type": "TIMESTAMP",
    "mode": "REQUIRED",
    "description": "Timestamp"
  },
  {
    "name": "aqi",
    "type": "FLOAT",
    "mode": "NULLABLE",
    "description": "Air Quality Index"
  },
  {
    "name": "co",
    "type": "FLOAT",
    "mode": "NULLABLE",
    "description": "Carbon monoxide"
  },
  {
    "name": "no",
    "type": "FLOAT",
    "mode": "NULLABLE",
    "description": "Nitrogen monoxide"
  },
  {
    "name": "no2",
    "type": "FLOAT",
    "mode": "NULLABLE",
    "description": "Nitrogen dioxide"
  },
  {
    "name": "o3",
    "type": "FLOAT",
    "mode": "NULLABLE",
    "description": "Ozone"
  },
  {
    "name": "so2",
    "type": "FLOAT",
    "mode": "NULLABLE",
    "description": "Sulfur dioxide"
  },
  {
    "name": "pm2_5",
    "type": "FLOAT",
    "mode": "NULLABLE",
    "description": "Particulate Matter 2.5 micrometers"
  },
  {
    "name": "pm10",
    "type": "FLOAT",
    "mode": "NULLABLE",
    "description": "Particulate Matter 10 micrometers"
  },
  {
    "name": "nh3",
    "type": "FLOAT",
    "mode": "NULLABLE",
    "description": "Ammonia"
  }
]
EOF

}
resource "google_bigquery_table" "weather_raw" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "weather_raw"
  schema = jsonencode(var.bq_weather_schema)
}

resource "google_bigquery_table" "pollution_raw" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "pollution_raw"
  schema = jsonencode(var.bq_pollution_schema)
}

resource "google_bigquery_table" "geo_raw" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "geo_raw"
  schema = jsonencode(var.bq_geo_schema)
}