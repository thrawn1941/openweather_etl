resource "google_cloudfunctions2_function" "default_extract" {
  name        = var.function_name_in_gcp
  description = var.function_description
  location    = var.location

  build_config {
    runtime = "python311"
    entry_point = var.function_name_in_source_code
    source {
      storage_source {
        bucket = var.storage_bucket_name
        object = var.storage_bucket_object_name
      }

    }
  }

  service_config {
    max_instance_count = var.instances
    available_memory   = var.memory
    environment_variables = var.env_vars
  }
  depends_on = [var.function_depends_on]
}