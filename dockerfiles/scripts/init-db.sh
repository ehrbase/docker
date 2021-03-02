#!/bin/sh

# Chjange to the same directory as this script
cd "$(dirname "$0")"

# If we was in build we are in the scripts directory
# if we booted we are in /
if [ -d scripts ]; then
    cd scripts
fi;

# Import all env's that was present at the time of init
set -o allexport
[[ -f .env ]] && source .env
set +o allexport

# Execute the DB init scripts
sh -c "./install-temporal-tables.sh"
sh -c "./install-jsquery.sh"
sh -c "./prepare-databases.sh"

# Next we need to swap back to docker root
cd /

# move the standard docker-entrypoint and replace with our own
if [ ! -f /docker-entrypoint-primary.sh ]; then
    unlink /docker-entrypoint.sh
    ln -s /scripts/init-db.sh /docker-entrypoint.sh
    ln -s /usr/local/bin/docker-entrypoint.sh /docker-entrypoint-primary.sh
else
    echo "exec: /docker-entrypoint-primary.sh";
    bash docker-entrypoint-primary.sh postgres
fi
