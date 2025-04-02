terraform {
  backend "gcs" {
    bucket  = "tf-state-openweather-etl"
    prefix  = "terraform/state"
  }
}