GKE_PROJECT_ID="salamirangerover"
GKE_CLUSTER_NAME="salamirangerover-cluster"
GKE_REGION="us-central1"
GKE_SA_NAME="salamirangerover-cluster-sa"
GKE_SA_EMAIL="$GKE_SA_NAME@${GKE_PROJECT_ID}.iam.gserviceaccount.com"

ROLES=(
  roles/logging.logWriter
  roles/monitoring.metricWriter
  roles/monitoring.viewer
  roles/stackdriver.resourceMetadata.writer
)

gcloud iam service-accounts create $GKE_SA_NAME \
  --display-name $GKE_SA_NAME --project $GKE_PROJECT_ID

# assign google service account to roles in GKE project
for ROLE in ${ROLES[*]}; do
  gcloud projects add-iam-policy-binding $GKE_PROJECT_ID \
    --member "serviceAccount:$GKE_SA_EMAIL" \
    --role $ROLE
done
