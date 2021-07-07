FROM postgres:13.3-alpine

# SHOW POSTGRES SERVER AND CLIENT VERSION
RUN postgres -V; \
    psql -V

# SET DEFAULT VALUES FOR DATABASE USER AND PASSWORDS
ARG EHRBASE_USER="ehrbase"
ARG EHRBASE_PASSWORD="ehrbase"
ENV EHRBASE_USER=${EHRBASE_USER}
ENV EHRBASE_PASSWORD=${EHRBASE_PASSWORD}

# COPY DB SETUP SCRIPT TO POSTGRES's DEFAULT DOCKER ENTRYPOINT FOLDER
# NOTE: check postgres's docker docs for details
#       https://hub.docker.com/_/postgres/
COPY scripts/db-setup.sql /docker-entrypoint-initdb.d/

# ALLOW CONNECTIONS FROM ALL ADRESSES & LISTEN TO ALL INTERFACES
# NOTE: locally works w/o this additional settings
RUN echo "host  all  all   0.0.0.0/0  scram-sha-256" >> ${PGDATA}/pg_hba.conf; \
    echo "listen_addresses='*'" >> ${PGDATA}/postgresql.conf; \
    ls -la ${PGDATA}
