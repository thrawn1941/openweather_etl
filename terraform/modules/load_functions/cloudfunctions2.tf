resource "google_cloudfunctions2_function" "default_load" {
  name        = var.function_name_in_gcp
  description = var.function_description
  location    = var.region

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

  event_trigger {
    trigger_region = var.region
    event_type = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic = var.pubsub_topic_id
    retry_policy = "RETRY_POLICY_UNSPECIFIED"
  }

  service_config {
    max_instance_count = var.instances
    available_memory   = var.memory
    environment_variables = var.env_vars
  }
}