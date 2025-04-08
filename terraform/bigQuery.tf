resource "google_bigquery_dataset" "default" {
  dataset_id                  = "openweather_etl"
  friendly_name               = "openweather ETL"
  description                 = "Data set to store data extracted from openweathermap.org"
  location                    = "EU"

  labels = {
    env = "default"
  }
}

resource "google_bigquery_table" "default" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "weather"

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "Current weather data from openweathermap.org"
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
    "type": "INT",
    "mode": "NULLABLE",
    "description": "Pressure"
  },
  {
    "name": "humidity",
    "type": "INT",
    "mode": "NULLABLE",
    "description": "Humidity"
  },
  {
    "name": "sea_level",
    "type": "INT",
    "mode": "NULLABLE",
    "description": "Sea level"
  },
  {
    "name": "grnd_level",
    "type": "INT",
    "mode": "NULLABLE",
    "description": "Ground level"
  },
  {
    "name": "visibility",
    "type": "INT",
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
    "type": "INT",
    "mode": "NULLABLE",
    "description": "Wind speed"
  },
  {
    "name": "clouds_all",
    "type": "INT",
    "mode": "NULLABLE",
    "description": "Clouds"
  }
]
EOF

}