resource "google_cloudfunctions2_function_iam_member" "default_invoker" {
  project        = google_cloudfunctions2_function.default_load.project
  location       = google_cloudfunctions2_function.default_load.location
  cloud_function = google_cloudfunctions2_function.default_load.name

  role   = var.role_type
  member = var.service_account
}