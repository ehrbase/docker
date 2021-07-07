# docker

Docker images used by EHRbase

## Table of contents
- [docker](#docker)
  - [Table of contents](#table-of-contents)
  - [Images](#images)
    - [ehrbase-postgresql-full.dockerfile](#ehrbase-postgresql-fulldockerfile)
      - [Containing software](#containing-software)
      - [Installation](#installation)
      - [Customization](#customization)

## Images

This list shows all available images and the content / use case description

| Image file name         | Description                                        |
| ----------------------- | -------------------------------------------------- |
| ehrbase-postgresql-full | Full PostgreSQL image with all available extension |

### ehrbase-postgresql-full.dockerfile

This image contains the full installation of POSTGRESQL version 11 including
temporary_tables and jsquery plugins. These plugins might not be supported by 
common used platform services as Amazon Web Services or Microsoft Azure and thus
can lead to failures during execution. For these you can try other images with
reduced plugins installed.

#### Containing software

* POSTGRESQL 11.5-apline
* temporary_tables plugin for POSTGRESQL
* jsquery plgin for POSTGRESQL

#### Installation

Pull docker image from docker hub and start with default parameters

```bash
$ docker run --name ehrdb -d -p 5432:5432 ehrbase/ehrbase-postgres:11.10
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

