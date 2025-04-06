resource "google_bigquery_dataset" "default" {
  dataset_id                  = "foo"
  friendly_name               = "test"
  description                 = "This is a test description"
  location                    = "EU"
  default_table_expiration_ms = 3600000

  labels = {
    env = "default"
  }
}

resource "google_bigquery_table" "default" {
  dataset_id = google_bigquery_dataset.default.dataset_id
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
    "type": "INT64",
    "mode": "NULLABLE",
    "description": "Temperature"
  },
  {
    "name": "humidity",
    "type": "INT64",
    "mode": "NULLABLE",
    "description": "Temperature"
  },
  {
    "name": "sea_level",
    "type": "INT64",
    "mode": "NULLABLE",
    "description": "Temperature"
  },
  {
    "name": "grnd_level",
    "type": "INT64",
    "mode": "NULLABLE",
    "description": "Temperature"
  },
  {
    "name": "visibility",
    "type": "INT64",
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
    "type": "INT64",
    "mode": "NULLABLE",
    "description": "Temperature"
  },
  {
    "name": "clouds_all",
    "type": "INT64",
    "mode": "NULLABLE",
    "description": "Temperature"
  }
]
EOF

}