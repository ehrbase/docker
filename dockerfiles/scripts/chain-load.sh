#!/bin/bash

# Read in ARG0
STARTSERVER="$1";

# Always swap to /scripts
cd /scripts

# Always expand the enviroment
set -e

# Incase this is a volume mount move
if [ -f "/scripts/.pginit" ]; then
    STARTSERVER="SPAWNSET"
fi

if [[ -z "$STARTSERVER" ]]; then
    echo "No runmode specified!"
    exit 0
else
    echo "Running mode: $STARTSERVER"
fi

# If we are in setup, init the db and install the required databases
# and modules
if [ $STARTSERVER == "INIT" ]; then
    sh -c 'pg_ctl initdb -D ${PGDATA}'
elif [ "$STARTSERVER" == "START" ]; then
    sh -c 'pg_ctl start -D ${PGDATA}'
elif [ "$STARTSERVER" == "WAIT" ]; then
    LOOPRUN=0
    while [ "$LOOPRUN" != 1 ]; do
        sleep 1
        LOOPRUN=$(perl -e 'print `psql -AtXq -U postgres -d template1 -c "SELECT 1"`')
    done
    echo "Primary database initilization complete!"
elif [ "$STARTSERVER" == "STOP" ]; then
    sh -c 'pg_ctl stop -D ${PGDATA}'
elif [ "$STARTSERVER" == "SETUP" ]; then
    # Totally remove the PGDATA to force re-init on image start
    rm -Rf "${PGDATA}"
elif [ "$STARTSERVER" == "SPAWNSET" ]; then
    # Execute the DB init scripts, we are already the postgres user
    # Add in MD5 auth
    echo "listen_addresses='*'" >> ${PGDATA}/postgresql.conf

    echo "Running temporal table test"
    eval ./test-temporal-tables.sh

    echo "Running: create-ehrbase-user"
    eval ./create-ehrbase-user.sh

    echo "Creating default databases"
    eval ./prepare-databases.sh
elif [ "$STARTSERVER" == "PASSRESET" ]; then
    echo "Running: password-recrypt-set"
    eval ./password-recrypt-set.sh
else
    echo "Unknown action '$STARTSERVER' called."
fi;
