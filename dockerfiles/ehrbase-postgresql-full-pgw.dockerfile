FROM postgres:11.5-alpine

# Set default values for database user and passwords
ARG EHRBASE_USER="ehrbase"
ARG EHRBASE_PASSWORD="ehrbase"
ENV EHRBASE_USER=${EHRBASE_USER}
ENV EHRBASE_PASSWORD=${EHRBASE_PASSWORD}

# Set Postgres data directory to custom folder
ENV PGDATA="/var/lib/postgresql/pgdata"

# Create custom data directory and change ownership to postgres user
USER root
RUN mkdir -p ${PGDATA}
RUN chown postgres: ${PGDATA}
RUN chmod 0700 ${PGDATA}

# Define Postgres version for easier upgrades for the future
ENV PG_MAJOR=11.11

# Copy init scripts to init directory
COPY ./scripts/create-ehrbase-user.sh /docker-entrypoint-initdb.d/

# Initialize basic database cluster
RUN sh -c "/usr/local/bin/docker-entrypoint.sh postgres & " && \
    sleep 20 && \
    echo "Database initialized"

# Allow connections from all adresses & Listen to all interfaces
RUN echo "host  all  all   0.0.0.0/0  scram-sha-256" >> ${PGDATA}/pg_hba.conf
RUN echo "listen_addresses='*'" >> ${PGDATA}/postgresql.conf

# Install python and dependencies
RUN apk add --update postgresql=${PG_MAJOR}-r0 \
    build-base  \
    git         \
    flex        \
    bison

COPY scripts /scripts
RUN chmod +x /scripts/*
RUN env > /scripts/.env
RUN sh /scripts/init-db.sh

EXPOSE 5432
