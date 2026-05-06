# ─────────────────────────────────────────
# Stage 1: SvelteKit Frontend bauen
# ─────────────────────────────────────────
FROM node:20-alpine AS frontend-builder

WORKDIR /app/web

COPY web/package*.json ./
RUN npm ci

COPY web/ ./
RUN npm run build

# ─────────────────────────────────────────
# Stage 2: Production mit MariaDB
# ─────────────────────────────────────────
FROM node:20-alpine AS production

# MariaDB installieren
RUN apk add --no-cache mariadb mariadb-client
# Eigene Config kopieren (TCP aktivieren)
COPY my.cnf /etc/my.cnf.d/my.cnf
# MariaDB Datenverzeichnis erstellen
RUN mkdir -p /run/mysqld && \
    chown mysql:mysql /run/mysqld && \
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

WORKDIR /app

# Backend
COPY backend/package*.json ./
RUN npm ci --omit=dev
COPY backend/src ./src

# Frontend runtime
WORKDIR /app/web
COPY web/package*.json ./
RUN npm ci --omit=dev

WORKDIR /app

# SvelteKit Build Output
COPY --from=frontend-builder /app/web/build ./web/build

# SQL-Datei kopieren
COPY users.sql /docker-entrypoint-initdb.d/users.sql

# Startscript
COPY start.sh ./
RUN chmod +x start.sh

EXPOSE 3000
EXPOSE 7401

ENV NODE_ENV=production

CMD ["sh", "start.sh"]