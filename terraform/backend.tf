terraform {
  backend "gcs" {
    bucket  = "tf-state-openweather-etl2"
    prefix  = "terraform/state"
  }
}