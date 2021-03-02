#!/bin/sh

set -e

cd /scripts

set -o allexport
[[ -f .env ]] && source .env
set +o allexport

# Check if it is already initilized
if [ -f /var/lib/postgresql/pgdata/.prepared ]; then
    echo "Database has already been initilized"
else
    # Execute the DB init scripts
    echo "Running: create-ehrbase-user"
    eval ./create-ehrbase-user.sh

    echo "Installing temporal tables"
    rm -Rf temporal*
    eval ./install-temporal-tables.sh

    echo "Installing JSquery"
    rm -Rf jsquery*
    eval ./install-jsquery.sh

    echo "Creating default databases"
    eval ./prepare-databases.sh
fi

