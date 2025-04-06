resource "google_bigquery_table" "default" {
  dataset_id = "totemic-client-447220-r1.city_temperature_data_set"
  table_id   = "test_weather"

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "default"
  }

  schema = <<EOF
[
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
    "description": "Temperature"
  },
  {
    "name": "temp_min",
    "type": "NUMERIC",
    "mode": "NULLABLE",
    "description": "Temperature"
  },
  {
    "name": "temp_max",
    "type": "NUMERIC",
    "mode": "NULLABLE",
    "description": "Temperature"
  },
  {
    "name": "pressure",
    "type": "INT",
    "mode": "NULLABLE",
    "description": "Temperature"
  },
  {
    "name": "humidity",
    "type": "INT",
    "mode": "NULLABLE",
    "description": "Temperature"
  },
  {
    "name": "sea_level",
    "type": "INT",
    "mode": "NULLABLE",
    "description": "Temperature"
  },
  {
    "name": "grnd_level",
    "type": "INT",
    "mode": "NULLABLE",
    "description": "Temperature"
  },
  {
    "name": "visibility",
    "type": "INT",
    "mode": "NULLABLE",
    "description": "Temperature"
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
    "description": "Temperature"
  },
  {
    "name": "clouds_all",
    "type": "INT",
    "mode": "NULLABLE",
    "description": "Temperature"
  }
]
EOF

}