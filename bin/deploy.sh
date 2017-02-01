set -e

API="https://api.cloud.gov"
ORG="18f-acq"
SPACE=$1

if [ $# -ne 1 ]; then
  echo "Usage: deploy <space>"
  exit
fi

if [ $SPACE = 'production' ]; then
  NAME="micropurchase"
  MANIFEST="manifest.yml"
elif [ $SPACE = 'staging' ]; then
  NAME="micropurchase-staging"
  MANIFEST="manifest-staging.yml"
  CF_PASSWORD=$CF_PASSWORD_STAGING
  CF_USERNAME=$CF_USERNAME_STAGING
  # Move two below these to the stop once both staging and
  # production are deployed to GovCloud.
  API="https://api.fr.cloud.gov"
  ORG="gsa-acq-micropurchase"
else
  echo "Unknown space: $SPACE"
  exit
fi

cf login -a $API -u $CF_USERNAME -p $CF_PASSWORD -o $ORG -s $SPACE
cf zero-downtime-push $NAME -f $MANIFEST
