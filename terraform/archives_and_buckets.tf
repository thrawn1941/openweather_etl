resource "google_storage_bucket" "bucket_for_functions" {
  name     = "functions-bucket-${var.project_id}267"
  location = var.region
}
data "archive_file" "function_source" {
  type        = "zip"
  source_dir  = var.functions_source_dir
  output_path = "${path.module}/functions-source.zip"
}
resource "google_storage_bucket_object" "archive" {
  name   = "functions-source${var.main_py_version}.zip"
  bucket = google_storage_bucket.bucket_for_functions.name
  source = data.archive_file.function_source.output_path
}