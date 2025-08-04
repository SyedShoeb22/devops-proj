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

resource "google_compute_instance" "default" {
  name         = "devops-instance"
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
  ssh-keys = <<EOT
ubuntu:${file(var.ssh_public_key)}
shoeb:${file(var.ssh_public_key)}
EOT
}

  # 🔑 IMPORTANT: Add 'ssh' tag so firewall rule applies
  tags = ["ssh"]
}

output "instance_ip" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}

resource "google_cloudfunctions_function_iam_member" "delete_vm_invoker" {
  project        = local.credentials.project_id
  region         = var.region
  cloud_function = google_cloudfunctions_function.delete_vm.name
  role           = "roles/cloudfunctions.invoker"
  member         = "serviceAccount:scheduler-sa@${local.credentials.project_id}.iam.gserviceaccount.com"
}

resource "google_cloudfunctions_function_iam_member" "start_vm_invoker" {
  project        = local.credentials.project_id
  region         = var.region
  cloud_function = google_cloudfunctions_function.start_vm.name
  role           = "roles/cloudfunctions.invoker"
  member         = "serviceAccount:scheduler-sa@${local.credentials.project_id}.iam.gserviceaccount.com"
}

resource "google_cloudfunctions_function_iam_member" "stop_vm_invoker" {
  project        = local.credentials.project_id
  region         = var.region
  cloud_function = google_cloudfunctions_function.stop_vm.name
  role           = "roles/cloudfunctions.invoker"
  member         = "serviceAccount:scheduler-sa@${local.credentials.project_id}.iam.gserviceaccount.com"
}

