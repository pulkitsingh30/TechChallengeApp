# Solution

## <u>High Level Solution Design</u>
 Go app application is deployed by CI/CD on Google Cloud Platform(GCP) using the gcp's native cloud build that executes the build on GCP's infrastructure. Cloud build has been linked with the repository and trigger, a push to the master branch of the repository has been created in order to trigger the cloud build.
 
 1. On push to the repository, after pull request aproval,the cloud build complies the go app using a Dockerfile and creates a conatiner image out of it and pushes that to container registery. 
 2. Infrastructure as a Code tool Terraform then provisions the Google Kubernetes Cluster in the specified GCP project.
 3. The go application Container image is then deployed onto the Google Kubernetes Cluster.
 4. The application is then exposed to internet using the Load Balancer.

## <u>Pre-requisites</u>
1. A GCP Project with billing and below API's enabled:<br>
    * Cloud Resource Manager API<br>
    * Cloud Build API<br>
    * Cloud Logging API<br>
    * Compute Engine API<br>
    * Kubernetes Engine API<br>
    * Identity and Access Management (IAM) API	

2. Below IAM roles for the cloud build following GCP's principle of lease priviledges<br>
    * Compute Network Admin
    * Compute Security Admin
    * Kubernetes Engine Admin
    * Security Admin
    * Create Service Accounts
    * Service Account User
    * Storage Admin

3. A storage bucket that holds the terraform state.

4. Terraform version 0.12.26 or later

5. docker and docker-compose to run the solution locally



 ## <u>Instructions for Deploying Locally</u>
 For deploying the application locally, a docker-compose yaml file has been created with 2 services viz. db,web and maping  the local port 80 to required 'web' container port. Since web service is dependent on db, a healthcheck of db service has been configured so that web service starts after that. A bridge network has been configured and both containers are using the network for seamless communication. The environment variables for the docker-compose are coming from a .env file which is existing at root level of the repository. Docker-compose pulls the lates go-app image from the google container registery. These images have been made public. So running the below simple command will pull the image and deploys the app locally.

 "docker-compose up"

 Once both the services comes up, the application can be excessed at:

 http://localhost:80
  

  ## <u> The Dockerfile:</u>
  Below changes were done to existing Dockerfile<br>
  1. Adding few more go swagger dependencies
  2. Accumulating the db update and see web serve command into a script and calling it.
  3. The two parameters DbHost and ListenHost were updated conf.toml file. Dbhost was updated to db container 'postgres' from localhost in order for web and db services to communicate on a docker bridge network. The Listenhost was updated to '0.0.0.0' from localhost so that the application can be reached from anywhere. This parameter can be changed to specific IP's incase the application needs to be secured.

  ## <u>IAC - Terraform</u>

  Terraform has been used to provision the required Google Kubernetets Cluster on GCP. The Google Kubernetes Engine(GKE) modules from gruntwork have been used and necessary changes have been incorporated. A GCS bucket is being used for the terraform state,which gives a central place for managing the state and avoid the drifts. Terraform.tfvars file has been included for substituting the values of the variables. The google and google-beta providers have been updated to latest versions.

  ## <u>GKE Cluster</u>
  Terraform utilises the GKE Module from gruntwork and deploys a Regional GKE cluster with autoscaling enabled for Nodes(min 1 and max 5).A load balancer is also configured to expose the service to internet.As the load balancer provisioning takes few minutes, a sleep of 3 minutes has been added in the gke-deploy script.

  ## <u>The Cloud Build Yaml</u>
  This is the hearbeat of the overall CI/CD Solution on GCP. Default timeout for the cloud build is 10 mins but the overall pipeline takes more than that,hence the default cloudbuild timeout has been changed to 20 minutes  by using a timeout paramter.<br>
   The build steps are as below<br>
  1. Uses a go cloud-builder and installs the go-swagger dependencies
  2. Takes the instructions from the Dockerfile and builds the container image.
  3. Tags the image and pushes it to GCP's project container registery.
  4. Uses a terraform 0.12.26 cloud-builder and runs the terraform init command to install the providers and modules.
  5. Run's the terraform plan for the infrastructure to be deployed.
  6. Uses the plan generated in the above step and applied the plan to provision the actual GKE Cluster.
  7. Uses the gcloud cloud-builder to get the credentials for the created GKE cluster.
  8. Uses the GKE deploy cloud builder and calls the gke-deploy script that deploys the go application on the GKE cluster, does the pods horizontal autoscaling and exposes the app to internet by provisioning a load balancer.

  ## Assessment Grading Criteria


#### Coding Style

A consistent coding style has been followed. The terraform tf file have appropriate comments for the infrasructure that is being deployed. Also the shell scripts that are used in the solution also have appropriate comments for overall understanding of the GKE cluster
#### Security

The go app is being deployed on the GKE Cluster for which best practices have been followed. The cluster is made private so that it can't be reached from outside. Load Balancer's front end IP is used to access the application and backend is on internal IP's that are not accessible from internet. Though the go app image has been intentionally made public for running the solution locally using the docker-compose but can be made private so that it can only be accessed while deploying it onto GKE Cluster. For local deployment through docker-compose a bridge network is configured so that both containers can communicate seamlessly while providing isolation from other containers that are not in the bridge network. A .env file with environmental variables has been created for local deployment but for enhanced security these variables can be taken as input at runtime from the user.

#### Simplicity

The solution has been kept very simple without much dependencies. A build is triggered when a push to the repository is sensed by the cloud build. The build uses the commonly used cloud-builders,compiles the app,pushes it to container repository, creates the required GKE infrastructure using terraform, pulls the image for deploying it to GKE.

#### Resiliency

The Solution is resilient as it is being deployed on GKE with node pool autoscaling with minimum 1 node and max 5 as per the application load. Also horizontal pod autoscaling is also enabled with minimum 1 and max 5 when the cpu utilisation touches 80 %. The frontend of the application is exposed via a https load balancer which is a managed service by GCP and is deployed globally across Google's edge network as a managed and scalable pool of load balancing resources.

## References
  1. https://cloud.google.com/solutions/managing-infrastructure-as-code
  2. https://docs.gruntwork.io/guides/deploying-a-dockerized-app-on-gke/
  3. https://github.com/gruntwork-io/terraform-google-gke