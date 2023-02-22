# docker

Docker images used by EHRbase


## Table of contents
- [docker](#docker)
  - [Table of contents](#table-of-contents)
  - [Images](#images)
    - [ehrbase-postgresql-db.dockerfile](#ehrbase-postgresql-fulldockerfile)
      - [Containing software](#containing-software)
      - [Usage](#usage)
      - [Customization](#customization)
      - [Build Your Own Image Locally](#build-your-own-image-locally)


## Images

This list shows all available images and the content / use case description

| Image file name         | Description                                          |
| ----------------------- | ---------------------------------------------------- |
| ehrbase-postgresql-db   | Cloud-ready PostgreSQL DB image (not for production! |



### ehrbase-postgresql-db.dockerfile

This image contains the full installation of POSTGRESQL version 13.4

Extensions/plugins like temporary_tables and jsquery are not longer required.
All functionallity that was provided by these plugins is in the past 
now is handled by scripts/db-setup.sql.

For reference you can check the archive folder with old docker files and all 
related scripts.



#### Containing software

* POSTGRESQL 13.4-apline



#### Usage
NOTE: there is possibly an issue with Moby's BuildKit (`docker buildx`) which requires to set a custom PGDATA folder to run the container successfully.
See https://github.com/docker-library/postgres/issues/881#issuecomment-918414825 for more details.



Pull docker image from docker hub and start with default parameters

```bash
docker run --name ehrdb \
           -e POSTGRES_PASSWORD=postgres \
           -e PGDATA=/tmp \
           -d -p 5432:5432 \
           ehrbase/ehrbase-postgres:13.4
```



#### Customization

```bash
# customized docker run command
docker run --name ehrdb \
           -e POSTGRES_PASSWORD=mypostgres \
           -e EHRBASE_USER_ADMIN=myuser \
           -e EHRBASE_PASSWORD_ADMIN=mypassword \
           -e EHRBASE_USER=myuser2 \
           -e EHRBASE_PASSWORD=mypassword2 \
           -e PGDATA=/tmp \
           -d -p 5432:5432 \
           ehrbase/ehrbase-postgres:13.4.v2
```

If you want to set specific parameters, provide environment variables with
the `-e` option to `docker run` command. Example above sets custom values
for root postgres user password and ehrbase user and password. If not
provided the default values from table below will apply.

The following parameters can be set via -e option:

| Parameter              | Usage                           | default            |
|------------------------|---------------------------------|--------------------|
| POSTGRES_PASSWORD      | Password for postgres           | postgres           |
| EHRBASE_USER_ADMIN     | Username for ehrbase Admin user | ehrbase            |
| EHRBASE_PASSWORD_ADMIN | Password for ehrbase Admin user | ehrbase            |
| EHRBASE_USER           | Username for ehrbase user       | ehrbase_restricted |
| EHRBASE_PASSWORD       | Password for ehrbase user       | ehrbase_restricted |



#### Build Your Own Image Locally

```bash
cd dockerfiles

# provides build runtimes for addition platforms
docker run --privileged --rm tonistiigi/binfmt --install all

# creates a 'docker-container' driver
# which allows building for multiple platforms 
docker buildx create --use --name multiarchbuilder

# shows build Driver and available target platforms
docker buildx inspect multiarchbuilder

# builds image for specific platforms
# and pushes it to docker-hub
docker buildx build --push --platform=linux/arm64,linux/amd64 \
    -t ehrbase/ehrbase-postgres:yourtag-001 \
    -f ehrbase-postgresql-db.dockerfile .

```

NOTE: If you want to build for one platform only, just provide only the one you need i.e.
```
docker buildx build --push --platform=linux/amd64 \
    -t ehrbase/ehrbase-postgres:yourtag-001 \
    -f ehrbase-postgresql-db.dockerfile .
```

NOTE: If you don't want to push the image to Docker Hub, use `--load` instead of `--push`.
This will make the image available only for you locally.
