#!/bin/bash

# Chjange to the same directory as this script
cd "$(dirname "$0")"

# Import all env's that was present at the time of init
set -o allexport
[[ -f .env ]] && source .env
set +o allexport

# Execute the DB init scripts
sh -c "./install-temporal-tables.sh"
sh -c "./install-jsquery.sh"
sh -c "./prepare-databases.sh"

