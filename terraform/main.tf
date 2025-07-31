terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  credentials = file(var.gcp_credentials_file)
  project     = var.project_id
  region      = var.region
}

# VM Creation
resource "google_compute_instance" "default" {
  name         = var.vm_name
  machine_type = "n2-standard-8"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2204-lts"
      size  = 100
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  labels = {
    managed_by = "scheduler"
  }

  tags = ["ssh"]
}

# Storage bucket for Cloud Functions code
resource "google_storage_bucket" "functions" {
  name     = "${var.project_id}-functions-bucket"
  location = var.region
}

# Package Cloud Function code
resource "null_resource" "package_function" {
  provisioner "local-exec" {
    command = <<EOT
      cd functions && zip -r ../function-code.zip .
    EOT
  }
}

resource "google_storage_bucket_object" "function_code" {
  name   = "function-code.zip"
  bucket = google_storage_bucket.functions.name
  source = "function-code.zip"
}

# Cloud Functions: Start VM
resource "google_cloudfunctions_function" "start_vm" {
  name        = "start-vm"
  runtime     = "python311"
  entry_point = "start_vm"
  source_archive_bucket = google_storage_bucket.functions.name
  source_archive_object = google_storage_bucket_object.function_code.name
  trigger_http = true
  available_memory_mb = 128
}

# Cloud Functions: Stop VM
resource "google_cloudfunctions_function" "stop_vm" {
  name        = "stop-vm"
  runtime     = "python311"
  entry_point = "stop_vm"
  source_archive_bucket = google_storage_bucket.functions.name
  source_archive_object = google_storage_bucket_object.function_code.name
  trigger_http = true
  available_memory_mb = 128
}

# Cloud Functions: Delete VM
resource "google_cloudfunctions_function" "delete_vm" {
  name        = "delete-vm"
  runtime     = "python311"
  entry_point = "delete_vm"
  source_archive_bucket = google_storage_bucket.functions.name
  source_archive_object = google_storage_bucket_object.function_code.name
  trigger_http = true
  available_memory_mb = 128
}

# Cloud Scheduler Jobs
resource "google_cloud_scheduler_job" "start_9am" {
  name        = "start-9am"
  schedule    = "30 3 * * *" # 9:00 AM IST
  time_zone   = "Asia/Kolkata"
  http_target {
    http_method = "POST"
    uri         = google_cloudfunctions_function.start_vm.https_trigger_url
  }
}

resource "google_cloud_scheduler_job" "stop_11am" {
  name        = "stop-11am"
  schedule    = "30 5 * * *" # 11:00 AM IST
  time_zone   = "Asia/Kolkata"
  http_target {
    http_method = "POST"
    uri         = google_cloudfunctions_function.stop_vm.https_trigger_url
  }
}

resource "google_cloud_scheduler_job" "start_11_30" {
  name        = "start-11-30"
  schedule    = "0 6 * * *" # 11:30 AM IST
  time_zone   = "Asia/Kolkata"
  http_target {
    http_method = "POST"
    uri         = google_cloudfunctions_function.start_vm.https_trigger_url
  }
}

resource "google_cloud_scheduler_job" "stop_2pm" {
  name        = "stop-2pm"
  schedule    = "30 8 * * *" # 2:00 PM IST
  time_zone   = "Asia/Kolkata"
  http_target {
    http_method = "POST"
    uri         = google_cloudfunctions_function.stop_vm.https_trigger_url
  }
}

resource "google_cloud_scheduler_job" "start_3pm" {
  name        = "start-3pm"
  schedule    = "30 9 * * *" # 3:00 PM IST
  time_zone   = "Asia/Kolkata"
  http_target {
    http_method = "POST"
    uri         = google_cloudfunctions_function.start_vm.https_trigger_url
  }
}

resource "google_cloud_scheduler_job" "delete_5pm" {
  name        = "delete-5pm"
  schedule    = "30 11 * * *" # 5:00 PM IST
  time_zone   = "Asia/Kolkata"
  http_target {
    http_method = "POST"
    uri         = google_cloudfunctions_function.delete_vm.https_trigger_url
  }
}
