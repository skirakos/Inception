FROM debian:bullseye

RUN apt update -y && apt upgrade -y

RUN apt install mariadb-server mariadb-client -y && rm -rf /var/lib/apt/lists/*

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY ./tools/run-mariadb.sh /

WORKDIR /cat /var/log/mysql/error.log


RUN chmod +x /run-mariadb.sh

EXPOSE 3306

CMD ["/run-mariadb.sh"]