username="$(whoami)-local-dev-$RANDOM"
gcloud iam service-accounts create "$username" \
    --description="Local development account created on $(whoami) at $(date '+%Y-%m-%d-%H-%M-%S')" \
    --display-name="$username" \
    --project="storage-0994"
