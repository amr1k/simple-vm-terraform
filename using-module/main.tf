data "google_compute_subnetwork" "subnet" {
  project = "<< gcp-project >>"
  name    = "default"
  region  = "europe-west1"
}

module "simple-vm-example" {
  source        = "github.com/GoogleCloudPlatform/cloud-foundation-fabric/modules/compute-vm"
  project_id    = "<< gcp-project >>"
  zone          = "europe-west1-b"
  name          = "test"
  instance_type = "n2-standard-2"
  network_interfaces = [{
    network    = "default"
    subnetwork = data.google_compute_subnetwork.subnet.self_link
    nat        = true #Enable public ip
  }]
  service_account_create = true
  boot_disk = {
    initialize_params = {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2304-amd64"
    }
  }

  metadata = {
    startup-script = file("startup-script.tpl")
  }
}
