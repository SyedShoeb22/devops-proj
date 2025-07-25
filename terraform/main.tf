provider "google" {
  credentials = file(var.gcp_credentials_file)
  project     = var.project
  region      = var.region
}

resource "google_compute_instance" "default" {
  name         = "devops-instance"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "ansible:${file(var.ssh_public_key_path)}"
  }

  tags = ["http-server"]
}

output "instance_ip" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}
