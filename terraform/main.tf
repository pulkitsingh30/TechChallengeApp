terraform {
  required_version = ">= 0.12.26"
}

#--------------------------------------------------------------------------------------------------------------------
# Creating GCS bucket to store terraform state files
#--------------------------------------------------------------------------------------------------------------------
terraform {
  backend "gcs" {
    bucket = "go-app-infra"
    prefix = "version/tfstate"
  }
}
provider "google" {
  version = "~> 3.55.0"
  project = var.project
  region  = var.region
}

provider "google-beta" {
  version = "~> 3.55.0"
  project = var.project
  region  = var.region
}
