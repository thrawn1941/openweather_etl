resource "google_cloudfunctions2_function_iam_member" "default_invoker" {
  #for_each = google_cloudfunctions2_function.default_extract

  project        = google_cloudfunctions2_function.default_extract.project
  location       = google_cloudfunctions2_function.default_extract.location
  cloud_function = google_cloudfunctions2_function.default_extract.name

  role   = var.role_type
  member = var.service_account
}