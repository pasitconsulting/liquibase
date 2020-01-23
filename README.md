# sql code migrations using Liquibase

## prereqs:-
docker installed locally

## intro
this repo contains a docker-compose file with 2 containers:- 

Liquibase (built from local Dockerfile)

Postgresql (dockerhub image)

# Install Instructions:
1) git clone this repo
    git clone https://github.com/pasitconsulting/liquibase.git

2) build image into local repo:- 
    docker build -t myname/liquibase:1.0 .

3) edit ```docker-compose.yml``` file to refer to above tag name
```
    version: '3.2'
    services:
      liquibase:
        image: myname/liquibase:1.0      <===EDIT THIS VALUE ONLY
        depends_on:
          - db
      db:
        image: postgres
        restart: always
        environment:
          - POSTGRES_PASSWORD:hello123
        ports:
          - 5432:5432
```

start both containers as an app:-

    docker-compose up


you should get the following to stdout:-
```
    db_1         | 2020-01-23 13:49:02.421 UTC [1] LOG:  database system is ready to accept connections
    liquibase_1  | 13:59:58.811 INFO  [liquibase.integration.commandline.Main]: Liquibase Community 3.8.5 by Datical
    liquibase_1  | 13:59:59.404 INFO  [liquibase.integration.commandline.Main]: Liquibase: Update has been successful.
    liquibase_liquibase_1 exited with code 0
```

#Liquibase Configuration
check files:-

`changelog.sql`  - THIS IS THE KEY FILE USED TO PUSH SQL CHANGES TO THE DATABASE - see sample changelog below

`liquibase.properties` - jdbc connection string etc


typically you will need to modify `changelog.sql` and then rebuild the dockerfile and rerun docker-compose (as per above instructions)



## Sample Change Log
```    
vi changelog.sql
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

## Reference
https://www.liquibase.org/get_started/quickstart_sql.html
