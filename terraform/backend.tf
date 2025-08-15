terraform {
  required_version = ">= 1.0"

  backend "gcs" {
    bucket = var.tfstate_bucket    # isi dengan nama bucket GCS
    prefix = "terraform/gke-openstack"
  }
}
