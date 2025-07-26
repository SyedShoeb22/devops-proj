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
      image_family  = "ubuntu-2204-lts"
      image_project = "ubuntu-os-cloud"
      size          = 100
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "ansible:${var.ssh_public_key}"
  }

  tags = ["http-server"]
}


output "instance_ip" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}
