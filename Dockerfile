# name: rlaworhkd430/sql-executor
# working_dir: /tmp
FROM mysql:5.7
WORKDIR /tmp

COPY ./init.sql ./init.sql
CMD ["bash", "-c", "mysql -u root -h host.docker.internal --port=3306 --password=example < ./init.sql"]