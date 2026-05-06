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

# Backend Dependencies
COPY backend/package*.json ./
RUN npm ci --omit=dev

# Backend Source
COPY backend/ ./

# SvelteKit Build Output → build/
COPY --from=frontend-builder /app/web/build ./web/build
COPY --from=frontend-builder /app/web/static ./web/static

EXPOSE 3000

ENV NODE_ENV=production

CMD ["node", "src/index.js"]