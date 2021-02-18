gcloud services enable cloudresourcemanager.googleapis.com cloudbuild.googleapis.com logging.googleapis.com compute.googleapis.com container.googleapis.com iam.googleapis.com storage.googleapis.com

PROJECT_ID=$(gcloud config get-value project)
gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:910704256954@cloudbuild.gserviceaccount.com --role=roles/compute.networkAdmin

gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:910704256954@cloudbuild.gserviceaccount.com --role=roles/compute.securityAdmin

gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:910704256954@cloudbuild.gserviceaccount.com --role=roles/container.admin

gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:910704256954@cloudbuild.gserviceaccount.com --role=roles/iam.securityAdmin

gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:910704256954@cloudbuild.gserviceaccount.com --role=roles/iam.serviceAccountCreator

gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:910704256954@cloudbuild.gserviceaccount.com --role=roles/iam.serviceAccountUser

gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:910704256954@cloudbuild.gserviceaccount.com --role=roles/storage.admin
