output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "kube_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "deployer_sa_email" {
  value = google_service_account.gke_deployer.email
}

output "artifact_repo" {
  value = google_artifact_registry_repository.container_repo.repository_id
}
