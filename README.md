# docker

Docker images used by EHRbase


## Table of contents
- [docker](#docker)
  - [Table of contents](#table-of-contents)
  - [Images](#images)
    - [ehrbase-postgresql-db.dockerfile](#ehrbase-postgresql-fulldockerfile)
      - [Containing software](#containing-software)
      - [Installation](#installation)
      - [Customization](#customization)


## Images

This list shows all available images and the content / use case description

| Image file name         | Description                                          |
| ----------------------- | ---------------------------------------------------- |
| ehrbase-postgresql-db   | Cloud-ready PostgreSQL DB image (not for production! |



### ehrbase-postgresql-db.dockerfile

This image contains the full installation of POSTGRESQL version 13.3

Extensions/plugins like temporary_tables and jsquery are not longer required.
All functionallity that was provided by these plugins is in the past 
now is handled by scripts/db-setup.sql.

For reference you can check the archive folder with old docker files and all 
related scripts.



#### Containing software

* POSTGRESQL 13.3-apline



#### Usage

Pull docker image from docker hub and start with default parameters

```bash
docker run --name ehrdb \
           -e POSTGRES_PASSWORD=postgres \
           -d -p 5432:5432 \
           ehrbase/ehrbase-postgres:13.3
```



#### Customization

```bash
# customized docker run command
docker run --name ehrdb \
           -e POSTGRES_PASSWORD=mypostgres \
           -e EHRBASE_USER=myuser
           -e EHRBASE_PASSWORD=mypassword
           -d -p 5432:5432 \
           ehrbase/ehrbase-postgres:13.3
```

If you want to set specific parameters, provide environment variables with
the `-e` option to `docker run` command. Example above sets custom values
for root postgres user password and ehrbase user and password. If not
provided the default values from table below will apply.

The following parameters can be set via -e option:

| Parameter         | Usage                     | default  |
| ----------------- | ------------------------- | -------- |
| POSTGRES_PASSWORD | Password for postgres     | postgres |
| EHRBASE_USER      | Username for ehrbase user | ehrbase  |
| EHRBASE_PASSWORD  | Password for ehrbase user | ehrbase  |



# Building Your Own Image Locally

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
    -t ehrbase/ehrbase-postgres:youtag-001 \
    -f ehrbase-postgresql-db.dockerfile .

```

NOTE: If you want to build for one platform only, just provide only the one you need i.e. `--platform=linux/amd64`
