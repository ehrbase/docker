#!/bin/bash

set -e

if [ ! -f /var/lib/postgresql/pgdata/.jsquery_installed ]; then
    # Fetch from remote repository
    git clone https://github.com/postgrespro/jsquery.git
    cd jsquery

    # Build jsQuery plugin
    make USE_PGXS=1 && \
    make USE_PGXS=1 install && \

    cd ..
    echo "done" > /var/lib/postgresql/pgdata/.jsquery_installed
fi
