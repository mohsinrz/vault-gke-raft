resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  project  = var.project_id
  location = var.cluster_location

  initial_node_count = var.initial_node_count
  network            = var.network
  subnetwork         = var.subnetwork

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  enable_binary_authorization = true

  node_config {
    machine_type = var.node_machine_type
    image_type = var.node_image_type

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}