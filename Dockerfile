# name: rlaworhkd430/sql-executor
# working_dir: /tmp
FROM mysql:5.7
WORKDIR /tmp

COPY ./init.sql ./init.sql
COPY ./run_sql.sh ./run_sql.sh
RUN ["bash", "-c", "chmod u+x ./run_sql.sh"]
# CMD ["bash", "-c", "mysql -u root -h host.docker.internal --port=3306 --password=example < ./init.sql"]
CMD ["bash", "-c", "./run_sql.sh"]