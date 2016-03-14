#!/bin/bash
set -e
cd $( dirname ${BASH_SOURCE[0]} )

export RAILS_ENV="${RAILS_ENV:-development}"

export DATABASE_PROTO="${DATABASE_PROTO:-postgresql}"

export DATABASE_USER="${DATABASE_USER:-${POSTGRES_USER}}"
export DATABASE_USER="${DATABASE_USER:-$(echo $VCAP_SERVICES | jq .rds[0].credentials.username)}"
export DATABASE_USER="${DATABASE_USER:-postgres}"

export DATABASE_PASS="${DATABASE_PASS:-${POSTGRES_PASSWORD}}"
export DATABASE_PASS="${DATABASE_PASS:-$(echo $VCAP_SERVICES | jq .rds[0].credentials.password)}"
export DATABASE_PASS="${DATABASE_PASS:-postgres}"

export DATABASE_HOST="${DATABASE_HOST:-${POSTGRES_HOST}}"
export DATABASE_HOST="${DATABASE_HOST:-$(echo ${VCAP_SERVICES} | jq .rds[0].credentials.hostname)}"
export DATABASE_HOST="${DATABASE_HOST:-$(ip route show 0.0.0.0/0 | awk '{print $3}')}"
export DATABASE_HOST="${DATABASE_HOST:-localhost}"

export DATABASE_PORT="${DATABASE_PORT:-$(echo ${VCAP_SERVICES} | jq .rds[0].credentials.port)}"
export DATABASE_PORT="${DATABASE_PORT:-5432}"

export DATABASE_NAME="${DATABASE_NAME:-$(echo ${VCAP_SERVICES} | jq .rds[0].credentials.name)}"
export DATABASE_NAME="${DATABASE_NAME:-micropayments}"

export DATABASE_ARGS="${DATABASE_ARGS:-pool=5}"

export DATABASE_URL="${DATABASE_URL:-${DATABASE_PROTO}://${DATABASE_USER}:${DATABASE_PASS}@${DATABASE_HOST}:${DATABASE_PORT}/${DATABASE_NAME}?${DATABASE_ARGS}}"

bundle exec rake db:create || true

while ! bundle exec rake db:migrate; do
  echo "Retrying db:migrate again in 10 seconds"
  sleep 10
done

if [ "${RAILS_ENV}" = "test" ] ; then
  bundle exec rake db:test:prepare db:seed
  bundle exec rspec
fi

exec bundle exec rails server -b 0.0.0.0 -p $PORT
