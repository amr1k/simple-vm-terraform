resource "google_service_account" "default" {
  project      = "amriksingh-testing"
  account_id   = "test-vm"
  display_name = "Test VM Service Account"
}

resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "e2-medium"
  zone         = "europe-west1-b"
  project      = "amriksingh-testing"


  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2304-amd64"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = file("startup-script.tpl")

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}
