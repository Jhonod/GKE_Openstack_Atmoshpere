resource "google_compute_network" "vpc" {
  name                    = var.network
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnetwork
  ip_cidr_range = "10.10.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc.id
  secondary_ip_range {
    range_name    = "pods-range"
    ip_cidr_range = "10.20.0.0/20"
  }
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "10.21.0.0/20"
  }
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone

  network    = google_compute_network.vpc.self_link
  subnetwork = google_compute_subnetwork.subnet.self_link

  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods-range"
    services_secondary_range_name = "services-range"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name     = "primary-pool"
  cluster  = google_container_cluster.primary.name
  location = var.zone

  node_count = var.node_count

  node_config {
    machine_type = var.node_machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    disk_size_gb = 100
  }
}

resource "google_artifact_registry_repository" "container_repo" {
  provider      = google
  location      = var.region
  repository_id = "openstack-images"
  format        = "DOCKER"
  description   = "Container images for OpenStack & Atmosphere"
}

resource "google_service_account" "gke_deployer" {
  account_id   = "gke-deployer"
  display_name = "GKE Deployer for GitHub Actions"
}

resource "google_project_iam_member" "deployer_container" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.gke_deployer.email}"
}

resource "google_project_iam_member" "deployer_artifact" {
  project = var.project_id
  role    = "roles/artifactregistry.admin"
  member  = "serviceAccount:${google_service_account.gke_deployer.email}"
}

resource "google_project_iam_member" "deployer_storage" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.gke_deployer.email}"
}
