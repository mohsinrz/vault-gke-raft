module "gke-cluster" {
  source                     = "./modules/google-gke-cluster/"
  credentials_file           = var.credentials_file
  region                     = var.region
  project_id                 = "mohsin-sandbox"
  cluster_name               = "demo-cluster"
  cluster_location           = "northamerica-northeast1-a"
  network                    = "projects/${var.project_id}/global/networks/default"
  subnetwork                 = "projects/${var.project_id}/regions/${var.region}/subnetworks/default"
  initial_node_count         = 3
}

module "tls" {
  source                     = "./modules/tls-private"
  hostname                   = "*.vault-internal"
}

module "vault" {
  source                     = "./modules/vault"
  num_vault_pods             = var.num_vault_pods
  cluster_endpoint           = module.gke-cluster.endpoint
  cluster_cert               = module.gke-cluster.ca_certificate
  vault_tls_ca               = module.tls.ca_cert
  vault_tls_cert             = module.tls.cert 
  vault_tls_key              = module.tls.key
}