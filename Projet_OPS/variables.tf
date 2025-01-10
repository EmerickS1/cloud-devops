# variables.tf
variable "project_id" {
  description = "ID du projet Google Cloud"
  default     = "cloud-devops-447407"
}

variable "region" {
  description = "Région pour les ressources GCP"
  default     = "europe-west9"
}
