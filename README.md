# sql code migrations using Liquibase

## prereqs:-
docker installed locally

## intro
this repo contains a docker-compose file with 2 containers:- 
Liquibase (built from local Dockerfile)
Postgresql (dockerhub image)

## instructions:
git clone this repo

build image into local repo:- 
    docker build -t myname/liquibase:1.0 .

edit docker-compose file to refer to above tag name
    version: '3.2'
    services:
      liquibase:
        image: myname/liquibase:1.0
        depends_on:
          - db
      db:
        image: postgres
        restart: always
        environment:
          - POSTGRES_PASSWORD:hello123
        ports:
          - 5432:5432
      
start both containers as an app:-
      docker-compose up


you should get the following to stdout:-
    db_1         | 2020-01-23 13:49:02.421 UTC [1] LOG:  database system is ready to accept connections
    liquibase_1  | 13:59:58.811 INFO  [liquibase.integration.commandline.Main]: Liquibase Community 3.8.5 by Datical
    liquibase_1  | 13:59:59.404 INFO  [liquibase.integration.commandline.Main]: Liquibase: Update has been successful.
    liquibase_liquibase_1 exited with code 0


check files:-
changelog.sql  - these are 

edit the change.log.sql file to include the initial sql code 

https://www.liquibase.org/get_started/quickstart_sql.html


## Sample Change Log
    
 
    --liquibase formatted sql

    --changeset nvoxland:1
    create table test1 (
    id int primary key,
    name varchar(255)
    );
    --rollback drop table test1;

    --changeset nvoxland:2
    insert into test1 (id, name) values (1, ‘name 1′);
    insert into test1 (id, name) values (2, ‘name 2′);

    --changeset nvoxland:3 dbms:oracle
    create sequence seq_test;

