variable "project_id" {
  type=string
  description="Google Cloud project id"
}
variable "region" {
  type=string
  description="Google Cloud region"
  default="europe-central2"
}
variable "gcp_credentials" {
  type=string
  description="Google Cloud credentials in json format"
  sensitive=true
}
variable "open_weather_api_key" {
  description = "API key for OpenWeather"
  type        = string
  sensitive   = true
}
variable "functions_source_dir" {
  description = "path to source code functions"
  type        = string
  default     = "../"
}
variable "extract_functions" {
  type = list(string)
  description = "List of the extraction functions to export"
  default = ["get_geo_data", "get_pollution_data", "get_last_day_pollution_data", "get_last_week_pollution_data", "get_weather_data"]
}
variable "bq_weather_schema" {
  type = any
  description = "Schema for BigQuery table that contains raw weather data"
  default = [
    {
      name = "coord"
      type = "RECORD"
      mode = "NULLABLE"
      fields = [
        { name = "lon", type = "FLOAT", mode = "NULLABLE" },
        { name = "lat", type = "FLOAT", mode = "NULLABLE" }
      ]
    },
    {
      name = "weather"
      type = "RECORD"
      mode = "REPEATED"
      fields = [
        { name = "id", type = "INTEGER", mode = "NULLABLE" },
        { name = "main", type = "STRING", mode = "NULLABLE" },
        { name = "description", type = "STRING", mode = "NULLABLE" },
        { name = "icon", type = "STRING", mode = "NULLABLE" }
      ]
    },
    {
      name = "base"
      type = "STRING"
      mode = "NULLABLE"
    },
    {
      name = "main"
      type = "RECORD"
      mode = "NULLABLE"
      fields = [
        { name = "temp", type = "FLOAT", mode = "NULLABLE" },
        { name = "feels_like", type = "FLOAT", mode = "NULLABLE" },
        { name = "temp_min", type = "FLOAT", mode = "NULLABLE" },
        { name = "temp_max", type = "FLOAT", mode = "NULLABLE" },
        { name = "pressure", type = "INTEGER", mode = "NULLABLE" },
        { name = "humidity", type = "INTEGER", mode = "NULLABLE" },
        { name = "sea_level", type = "INTEGER", mode = "NULLABLE" },
        { name = "grnd_level", type = "INTEGER", mode = "NULLABLE" }
      ]
    },
    {
      name = "visibility"
      type = "INTEGER"
      mode = "NULLABLE"
    },
    {
      name = "wind"
      type = "RECORD"
      mode = "NULLABLE"
      fields = [
        { name = "speed", type = "FLOAT", mode = "NULLABLE" },
        { name = "deg", type = "INTEGER", mode = "NULLABLE" },
        { name = "gust", type = "FLOAT", mode = "NULLABLE" }
      ]
    },
    {
      name = "clouds"
      type = "RECORD"
      mode = "NULLABLE"
      fields = [
        { name = "all", type = "INTEGER", mode = "NULLABLE" }
      ]
    },
    {
      name = "dt"
      type = "INTEGER"
      mode = "NULLABLE"
    },
    {
      name = "sys"
      type = "RECORD"
      mode = "NULLABLE"
      fields = [
        { name = "type", type = "INTEGER", mode = "NULLABLE" },
        { name = "id", type = "INTEGER", mode = "NULLABLE" },
        { name = "country", type = "STRING", mode = "NULLABLE" },
        { name = "sunrise", type = "INTEGER", mode = "NULLABLE" },
        { name = "sunset", type = "INTEGER", mode = "NULLABLE" }
      ]
    },
    {
      name = "timezone"
      type = "INTEGER"
      mode = "NULLABLE"
    },
    {
      name = "id"
      type = "INTEGER"
      mode = "NULLABLE"
    },
    {
      name = "name"
      type = "STRING"
      mode = "NULLABLE"
    },
    {
      name = "cod"
      type = "INTEGER"
      mode = "NULLABLE"
    }
  ]
}

variable "bq_pollution_schema" {
  type = any
  description = "Schema for BigQuery table that contains raw pollution data"
  default = [
    {
      name = "coord"
      type = "RECORD"
      mode = "NULLABLE"
      fields = [
        {
          name = "lon"
          type = "FLOAT"
          mode = "NULLABLE"
        },
        {
          name = "lat"
          type = "FLOAT"
          mode = "NULLABLE"
        }
      ]
    },
    {
      name = "list"
      type = "RECORD"
      mode = "REPEATED"
      fields = [
        {
          name = "main"
          type = "RECORD"
          mode = "NULLABLE"
          fields = [
            {
              name = "aqi"
              type = "INTEGER"
              mode = "NULLABLE"
            }
          ]
        },
        {
          name = "components"
          type = "RECORD"
          mode = "NULLABLE"
          fields = [
            { name = "co", type = "FLOAT", mode = "NULLABLE" },
            { name = "no", type = "FLOAT", mode = "NULLABLE" },
            { name = "no2", type = "FLOAT", mode = "NULLABLE" },
            { name = "o3", type = "FLOAT", mode = "NULLABLE" },
            { name = "so2", type = "FLOAT", mode = "NULLABLE" },
            { name = "pm2_5", type = "FLOAT", mode = "NULLABLE" },
            { name = "pm10", type = "FLOAT", mode = "NULLABLE" },
            { name = "nh3", type = "FLOAT", mode = "NULLABLE" }
          ]
        },
        {
          name = "dt"
          type = "TIMESTAMP"
          mode = "NULLABLE"
        }
      ]
    }
  ]
}