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

```postgres=# \dt```  <== RUN '\dt' on POSTGRES PROMPT



# Liquibase Configuration
check files:-

`changelog.sql`  - THIS IS THE KEY FILE USED TO PUSH SQL CHANGES TO THE DATABASE - see sample changelog below

`liquibase.properties` - jdbc connection string etc


to make SQL schema changes you will need to modify `changelog.sql` and then rebuild the dockerfile and rerun docker-compose (as per above instructions)

changelog.sql is comprised of ```Changesets``` (a change to existing schema is appended to the changelog.sql file as a changeset)

Each changeset in a formatted SQL file begins with a comment of the form

--changeset author:id attribute1:value1 attribute2:value2 [...]

## Sample Change Log
```    
vi changelog.sql
--liquibase formatted sql
  
--changeset psenior:1
create table test2 (
id int primary key,
name varchar(255)
);

--changeset psenior:2
create table test3 (
id int primary key,
name varchar(255)
);

--changeset psenior:3
create table test4 (
id int primary key,
name varchar(255)
);

--comment: added 2 rows to test3 table
--changeset psenior:4
insert into test3 (id, name) values (1, 'name 1');
insert into test3 (id, name) values (2, 'name 2');

--comment: remove table created earlier
--changeset psenior:5
drop table test3;
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

