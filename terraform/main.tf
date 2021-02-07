terraform {
  required_version = ">= 0.12.7"
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
  version = "~> 2.9.0"
  project = var.project
  region  = var.region
}

provider "google-beta" {
  version = "~> 2.9.0"
  project = var.project
  region  = var.region
}

