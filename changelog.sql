--liquibase generate sql

--changeset bob:1
create table test1 (
id int primary key,
name varchar(255)
);
