#!/bin/bash

mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql
chmod -R 755 /var/lib/mysql\

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

mysqld_safe --datadir=/var/lib/mysql &

until mysqladmin ping --silent; do
    echo "Waiting for MariaDB to start..."
    sleep 2
done


cat <<EOF > db.sql
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;

UPDATE wp_options SET option_value = 'https://localhost' WHERE option_name = 'siteurl';
UPDATE wp_options SET option_value = 'https://localhost' WHERE option_name = 'home';
EOF


mysql < db.sql

kill $(cat /var/run/mysqld/mysqld.pid)

exec mysqld --datadir=/var/lib/mysql