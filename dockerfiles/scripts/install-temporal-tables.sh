#!/bin/bash

set -e

pg_ctl start -D ${PGDATA} 

# Fetch from branch "mlt" which has full support of Postgres 11
git clone https://github.com/mlt/temporal_tables.git --branch mlt
cd temporal_tables

# Build from source
make PGUSER=postgres && make install && make installcheck

# Stop server
pg_ctl stop -D ${PGDATA}

cd ..

