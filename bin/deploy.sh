set -e

API="https://api.fr.cloud.gov"
ORG="gsa-acq-micropurchase"
SPACE=$1

if [ $# -ne 1 ]; then
  echo "Usage: deploy <space>"
  exit
fi

if [ $SPACE = 'production' ]; then
  NAME="micropurchase"
  MANIFEST="manifest.yml"
  CF_PASSWORD=$CF_PASSWORD_PRODUCTION
  CF_USERNAME=$CF_USERNAME_PRODUCTION
elif [ $SPACE = 'staging' ]; then
  NAME="micropurchase-staging"
  MANIFEST="manifest-staging.yml"
  CF_PASSWORD=$CF_PASSWORD_STAGING
  CF_USERNAME=$CF_USERNAME_STAGING
else
  echo "Unknown space: $SPACE"
  exit
fi

cf login -a $API -u $CF_USERNAME -p $CF_PASSWORD -o $ORG -s $SPACE
cf zero-downtime-push $NAME -f $MANIFEST
