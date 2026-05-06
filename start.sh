#!/bin/sh

# MariaDB starten
echo "Starting MariaDB..."
mariadbd --user=mysql --datadir=/var/lib/mysql &

# Warten bis MariaDB bereit ist (über Socket)
echo "Waiting for MariaDB to be ready..."
for i in $(seq 1 30); do
    if mariadb-admin ping --socket=/run/mysqld/mysqld.sock --silent 2>/dev/null; then
        echo "MariaDB is ready!"
        break
    fi
    echo "Waiting... ($i/30)"
    sleep 1
done

# Datenbank initialisieren
if [ ! -f /var/lib/mysql/.initialized ]; then
    echo "Configuring root access with password..."
    
    mariadb -u root --socket=/run/mysqld/mysqld.sock << 'EOSQL'
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '1234';
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOSQL
    
    echo "Importing users.sql..."
    mariadb -u root -p1234 --socket=/run/mysqld/mysqld.sock < /docker-entrypoint-initdb.d/users.sql
    
    touch /var/lib/mysql/.initialized
    echo "Database initialized!"
else
    echo "Database already initialized, skipping import."
fi

# Backend starten
echo "Starting backend..."
node src/index.js &

# Frontend starten
echo "Starting frontend..."
PORT=3000 node web/build/index.js