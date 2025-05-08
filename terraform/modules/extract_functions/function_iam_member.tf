resource "google_cloudfunctions2_function_iam_member" "default_invoker" {
  for_each = google_cloudfunctions2_function.default_extract

  project        = each.value.project
  location       = each.value.location
  cloud_function = each.value.name

  role   = var.role_type
  member = var.service_account
}