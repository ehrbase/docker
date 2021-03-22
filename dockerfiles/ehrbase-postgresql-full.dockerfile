FROM postgres:11.5-alpine

# Set default values for database user and passwords
ARG EHRBASE_USER="ehrbase"
ARG EHRBASE_PASSWORD="ehrbase"
ENV EHRBASE_USER=${EHRBASE_USER:-ehrbase}
ENV EHRBASE_PASSWORD=${EHRBASE_PASSWORD:-ehrbase}

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

# Install python and dependencies
RUN apk add --update postgresql=${PG_MAJOR}-r0 \
    build-base  \
    git         \
    flex        \
    bison       \
    psutils

# Install JSQuery
RUN cd  /scripts/                                                           \
    &&  git clone https://github.com/postgrespro/jsquery.git                \
    &&  cd jsquery                                                          \
    &&  make USE_PGXS=1                                                     \
    &&  make USE_PGXS=1 install

# Install temporal tables 
RUN cd  /scripts/                                                           \
    &&  git clone https://github.com/mlt/temporal_tables.git --branch mlt   \
    &&  cd temporal_tables                                                  \
    &&  make PGUSER=postgres                                                \
    &&  make install

# Allow regression test to run from /scripts/temporal
RUN chown -R root:postgres  /scripts
RUN chmod -R g+rwx          /scripts

# Initialize basic database cluster
RUN su postgres -c sh -c "/scripts/chain-load.sh SETUP"         \
    &&  su postgres -c sh -c "/usr/local/bin/docker-entrypoint.sh postgres &"   \
    &&  su postgres -c sh -c "/scripts/chain-load.sh WAIT"       \
    &&  su postgres -c sh -c "/scripts/chain-load.sh SPAWNSET"   \
    &&  su postgres -c sh -c "/scripts/chain-load.sh STOP"

RUN echo "DONE" > /scripts/.pginit

# Copy init scripts to init directory
COPY /scripts/chain-load.sh /docker-entrypoint-initdb.d/
# COPY the pg_hba to the PGDATA directory
COPY /scripts/etc/pg_hba.conf ${PGDATA}/
RUN echo "Enforcing ownership, one moment" \
    && chown -R postgres:postgres ${PGDATA}

EXPOSE 5432