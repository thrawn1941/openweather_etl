terraform {
  backend "gcs" {
    bucket  = "tf-state-openweather-etl33"
    prefix  = "terraform/state"
  }
}