gcloud container clusters get-credentials example-private-cluster --region=australia-southeast1

# Deploying the go app on the cluster

kubectl create deployment go-app-deploy --image=gcr.io/servian-tech/goapp-image:latest

#Load balancer for public exposure

kubectl expose deployment go-app-deploy --type=LoadBalancer --port 80 --target-port 3000
