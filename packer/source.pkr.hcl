source "googlecompute" "default" {
  source_image = var.source_image
  ssh_username = var.ssh_username
  project_id   = var.project_id
  zone         = var.gcp_zone
}
