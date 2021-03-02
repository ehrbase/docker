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
RUN mkdir -p ${PGDATA} /usr/local/share/doc/
RUN chown postgres: ${PGDATA}
RUN chmod 0700 ${PGDATA}

# Define Postgres version for easier upgrades for the future
ENV PG_MAJOR=11.11

# Copy system scripts to the scripts directory on root
COPY scripts /scripts
RUN chmod +x /scripts/*
RUN env > /scripts/.env

# Copy init scripts to init directory
COPY ./scripts/chain-load.sh /docker-entrypoint-initdb.d/
RUN chown -R root:postgres  /scripts                                \
                            /usr/local/lib/postgresql               \
                            /usr/local/include/postgresql           \
                            /usr/local/share/postgresql/extension   \
                            /usr/local/share/doc/

RUN chmod -R g+rwx          /scripts                                \
                            /usr/local/lib/postgresql               \
                            /usr/local/include/postgresql           \
                            /usr/local/share/postgresql/extension   \
                            /usr/local/share/doc/

# Install python and dependencies
RUN apk add --update postgresql=${PG_MAJOR}-r0 \
    build-base  \
    git         \
    flex        \
    bison

# Initialize basic database cluster
RUN sh -c "/usr/local/bin/docker-entrypoint.sh postgres & " && \
    sleep 20 && \
    echo "Database initialized"

# Allow connections from all adresses & Listen to all interfaces
RUN echo "host  all  all   0.0.0.0/0  md5" >> ${PGDATA}/pg_hba.conf
RUN echo "listen_addresses='*'" >> ${PGDATA}/postgresql.conf

EXPOSE 5432
