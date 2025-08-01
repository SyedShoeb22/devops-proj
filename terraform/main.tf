terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

locals {
  credentials = jsondecode(file(var.gcp_credentials_file))
}

provider "google" {
  credentials = file(var.gcp_credentials_file)
  project     = local.credentials.project_id
  region      = var.region
}

# ----------------------
# VM Creation
# ----------------------
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

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key)}"
  }

  tags = ["ssh"]
}

output "instance_ip" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}

# ----------------------
# Storage for Cloud Functions
# ----------------------
resource "google_storage_bucket" "functions" {
  name     = "${local.credentials.project_id}-functions-bucket"
  location = var.region
}

# Upload zipped Cloud Function code
resource "google_storage_bucket_object" "function_code" {
  name   = "function-code.zip"
  bucket = google_storage_bucket.functions.name
  source = "${path.module}/function-code.zip"
}

# ----------------------
# Cloud Functions
# ----------------------
resource "google_cloudfunctions_function" "start_vm" {
  name        = "start-vm"
  runtime     = "python311"
  entry_point = "start_vm"

  source_archive_bucket = google_storage_bucket.functions.name
  source_archive_object = google_storage_bucket_object.function_code.name

  trigger_http        = true
  available_memory_mb = 128
  environment_variables = {
    PROJECT  = local.credentials.project_id
    ZONE     = var.zone
    INSTANCE = var.vm_name
  }
}

resource "google_cloudfunctions_function" "stop_vm" {
  name        = "stop-vm"
  runtime     = "python311"
  entry_point = "stop_vm"

  source_archive_bucket = google_storage_bucket.functions.name
  source_archive_object = google_storage_bucket_object.function_code.name

  trigger_http        = true
  available_memory_mb = 128
  environment_variables = {
    PROJECT  = local.credentials.project_id
    ZONE     = var.zone
    INSTANCE = var.vm_name
  }
}

resource "google_cloudfunctions_function" "delete_vm" {
  name        = "delete-vm"
  runtime     = "python311"
  entry_point = "delete_vm"

  source_archive_bucket = google_storage_bucket.functions.name
  source_archive_object = google_storage_bucket_object.function_code.name

  trigger_http        = true
  available_memory_mb = 128
  environment_variables = {
    PROJECT  = local.credentials.project_id
    ZONE     = var.zone
    INSTANCE = var.vm_name
  }
}

# ----------------------
# Cloud Scheduler Jobs
# ----------------------
resource "google_cloud_scheduler_job" "start_9am" {
  name     = "start-vm-9am"
  schedule = "0 9 * * *"
  time_zone = "Asia/Kolkata"
  http_target {
    uri        = google_cloudfunctions_function.start_vm.https_trigger_url
    http_method = "POST"
  }
}

resource "google_cloud_scheduler_job" "stop_11am" {
  name     = "stop-vm-11am"
  schedule = "0 11 * * *"
  time_zone = "Asia/Kolkata"
  http_target {
    uri        = google_cloudfunctions_function.stop_vm.https_trigger_url
    http_method = "POST"
  }
}

resource "google_cloud_scheduler_job" "start_1130am" {
  name     = "start-vm-1130am"
  schedule = "30 11 * * *"
  time_zone = "Asia/Kolkata"
  http_target {
    uri        = google_cloudfunctions_function.start_vm.https_trigger_url
    http_method = "POST"
  }
}

resource "google_cloud_scheduler_job" "stop_1pm" {
  name     = "stop-vm-1pm"
  schedule = "0 13 * * *"
  time_zone = "Asia/Kolkata"
  http_target {
    uri        = google_cloudfunctions_function.stop_vm.https_trigger_url
    http_method = "POST"
  }
}

resource "google_cloud_scheduler_job" "start_2pm" {
  name     = "start-vm-2pm"
  schedule = "0 14 * * *"
  time_zone = "Asia/Kolkata"
  http_target {
    uri        = google_cloudfunctions_function.start_vm.https_trigger_url
    http_method = "POST"
  }
}

resource "google_cloud_scheduler_job" "stop_330pm" {
  name     = "stop-vm-330pm"
  schedule = "30 15 * * *"
  time_zone = "Asia/Kolkata"
  http_target {
    uri        = google_cloudfunctions_function.stop_vm.https_trigger_url
    http_method = "POST"
  }
}

resource "google_cloud_scheduler_job" "start_4pm" {
  name     = "start-vm-4pm"
  schedule = "0 16 * * *"
  time_zone = "Asia/Kolkata"
  http_target {
    uri        = google_cloudfunctions_function.start_vm.https_trigger_url
    http_method = "POST"
  }
}

resource "google_cloud_scheduler_job" "delete_5pm" {
  name     = "delete-vm-5pm"
  schedule = "0 17 * * *"
  time_zone = "Asia/Kolkata"
  http_target {
    uri        = google_cloudfunctions_function.delete_vm.https_trigger_url
    http_method = "POST"
  }
}
