#!/bin/bash
set -e

echo "CREATE ROLE ${EHRBASE_USER} LOGIN PASSWORD '${EHRBASE_PASSWORD}'"

psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
CREATE ROLE ${EHRBASE_USER} LOGIN PASSWORD '${EHRBASE_PASSWORD}';
CREATE DATABASE ehrbase ENCODING 'UTF-8' TEMPLATE template0;
GRANT ALL PRIVILEGES ON DATABASE ehrbase TO ${EHRBASE_USER};
CREATE USER root WITH SUPERUSER;
EOSQL

# Stop database before proceeding
pg_ctl stop -D ${PGDATA}
echo "done" > /var/lib/postgresql/pgdata/.userinit
