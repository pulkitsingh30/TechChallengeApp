gcloud container clusters get-credentials example-private-cluster --region=australia-southeast1

# Deploying the go app on the cluster

kubectl create deployment go-app-deploy --image=gcr.io/servian-tech/goapp-image:latest

#Horizontal Pod Autoscaler
kubectl autoscale deployment go-app-deploy --cpu-percent=80 --min=1 --max=5

#Load balancer for public exposure

kubectl expose deployment go-app-deploy --type=LoadBalancer --port 80 --target-port 3000

sleep 3m
echo "Waiting for Load Balancer to be provisioned"
#Service Details
kubectl get service
