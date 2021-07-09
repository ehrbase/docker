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

#### Installation

Pull docker image from docker hub and start with default parameters

```bash
docker run --name ehrdb \
           -e POSTGRES_PASSWORD=postgres \
           -d -p 5432:5432 \
           ehrbase/ehrbase-postgres:13.3
```

#### Customization

If you want to set specific parameters use environment variables provided with
the -e option to the docker run command. This will be used to set the specific
parameters for root postgres user password and ehrbase user and password. If not
provided the default values will be used.

The following parameters can be set via -e option:

| Parameter         | Usage                     | default  |
| ----------------- | ------------------------- | -------- |
| POSTGRES_PASSWORD | Password for postgres     | postgres |
| EHRBASE_USER      | Username for ehrbase user | ehrbase  |
| EHRBASE_PASSWORD  | Password for ehrbase user | ehrbase  |
