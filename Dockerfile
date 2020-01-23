FROM centos:7

# Add the liquibase user and step in the directory

RUN yum install -y java-1.8.0-openjdk

RUN yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
RUN yum install -y postgresql11 telnet

# Change to the liquibase user

WORKDIR /liquibase
ADD liquibase.properties /liquibase
ADD changelog.sql /liquibase
ADD postgresql-42.2.9.jar /liquibase
COPY liquibase-3.8.5.tar.gz /liquibase

RUN tar -xzf /liquibase/liquibase-3.8.5.tar.gz 
RUN rm /liquibase/liquibase-3.8.5.tar.gz 

RUN chmod 777 /liquibase

ENTRYPOINT ["/liquibase/liquibase"]
CMD ["--changeLogFile=changelog.sql","--logLevel=warning","update"]
