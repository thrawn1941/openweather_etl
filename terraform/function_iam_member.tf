#########################################################################################################
##### invoker permissions for extract functions
resource "google_cloudfunctions2_function_iam_member" "invoker" {
  for_each = google_cloudfunctions2_function.extract_functions

  project        = each.value.project
  location       = each.value.location
  cloud_function = each.value.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:test-account@totemic-client-447220-r1.iam.gserviceaccount.com"
}
resource "google_cloudfunctions2_function_iam_member" "invoker_extract_last_month" {
  project        = google_cloudfunctions2_function.extract_historical_pollution.project
  location       = google_cloudfunctions2_function.extract_historical_pollution.location
  cloud_function = google_cloudfunctions2_function.extract_historical_pollution.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:test-account@totemic-client-447220-r1.iam.gserviceaccount.com"
}
#########################################################################################################
##### invoker permissions for load functions
resource "google_cloudfunctions2_function_iam_member" "invoker_load_functions" {
  for_each = google_cloudfunctions2_function.load_functions

  project        = each.value.project
  location       = each.value.location
  cloud_function = each.value.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:test-account@totemic-client-447220-r1.iam.gserviceaccount.com"
}
resource "google_cloudfunctions2_function_iam_member" "invoker_load_functions2" {
  for_each = google_cloudfunctions2_function.load_functions2

  project        = each.value.project
  location       = each.value.location
  cloud_function = each.value.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:test-account@totemic-client-447220-r1.iam.gserviceaccount.com"
}
resource "google_cloudfunctions2_function_iam_member" "invoker_load_functions3" {
  for_each = google_cloudfunctions2_function.load_functions3

  project        = each.value.project
  location       = each.value.location
  cloud_function = each.value.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:test-account@totemic-client-447220-r1.iam.gserviceaccount.com"
}