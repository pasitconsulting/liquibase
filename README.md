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

 ```docker build -t myname/liquibase:1.0 . ```

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


## To verify your db schema changes are successful:-

1) you should get the following to stdout when running docker-compose up:-
```
    db_1         | 2020-01-23 13:49:02.421 UTC [1] LOG:  database system is ready to accept connections
    liquibase_1  | 13:59:58.811 INFO  [liquibase.integration.commandline.Main]: Liquibase Community 3.8.5 by Datical
    liquibase_1  | 13:59:59.404 INFO  [liquibase.integration.commandline.Main]: Liquibase: Update has been successful.
    liquibase_liquibase_1 exited with code 0
```

2) run a psql session in the running postgres container to verify schema objects, e.g. to confirm tables:-
``docker ps``   <==FIND CONTAINER ID OF RUNNING POSTGRES
```docker exec -it [POSTGRES CONTAINER ID] bash```
```psql -h localhost -p 5432 -U postgres```
```postgres=# \dt``  <== RUN '\dt' on POSTGRES PROMPT


# Liquibase Configuration
check files:-

`changelog.sql`  - THIS IS THE KEY FILE USED TO PUSH SQL CHANGES TO THE DATABASE - see sample changelog below

`liquibase.properties` - jdbc connection string etc


typically you will need to modify `changelog.sql` and then rebuild the dockerfile and rerun docker-compose (as per above instructions)



## Sample Change Log
```    
vi changelog.sql
--liquibase formatted sql

--changeset YOURNAME:1
create table test1 (
id int primary key,
name varchar(255)
);
--rollback drop table test1;

--changeset YOURNAME:2
insert into test1 (id, name) values (1, ‘name 1′);
insert into test1 (id, name) values (2, ‘name 2′);

--changeset YOURNAME:3 dbms:oracle
create sequence seq_test;
```

## Reference
https://www.liquibase.org/get_started/quickstart_sql.html

## Tips & Tricks
### to import state of an existing database
Note: same liquibase command as normal:-

```liquibase --changeLogFile=changelog.sql update```, except replace `update` with `changelogSync`

edit Dockerfile: change the ``CMD`` value as follows:-

    CMD ["--changeLogFile=changelog.sql","--logLevel=warning","changelogSync"]
 
 rebuild Dockerfile:-
 
    docker build -t myname/liquibase:1.1 .
        
edit docker-compose.yml file with new tag and then rerun docker-compose:-

```docker-compose up```

