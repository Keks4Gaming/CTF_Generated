#!/bin/sh

# Backend starten (im Hintergrund)
node src/index.js &

# Frontend starten (im Vordergrund, hält Container am Leben)
PORT=3000 node web/build/index.js