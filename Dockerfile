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
# Stage 2: Production
# ─────────────────────────────────────────
FROM node:20-alpine AS production

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

# Startscript
COPY start.sh ./
RUN chmod +x start.sh

EXPOSE 3000
EXPOSE 7401

ENV NODE_ENV=production

CMD ["sh", "start.sh"]