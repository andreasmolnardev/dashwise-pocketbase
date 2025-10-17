#!/bin/sh
set -e

PB_BINARY="/app/pocketbase"
PB_PORT="0.0.0.0:8090"

PB_DATA_DIR="/pb_data"
PB_MIGRATIONS_DIR="/pb_migrations"

ADMIN_EMAIL="${PB_ADMIN_EMAIL:-default@dashwise.local}"
ADMIN_PASSWORD="${PB_ADMIN_PASSWORD:-dashwiseIsAwesome}"

# Ensure data and migrations directories exist
mkdir -p "$PB_DATA_DIR" "$PB_MIGRATIONS_DIR"

# Start PocketBase as background service with correct paths
$PB_BINARY serve \
  --http "$PB_PORT" \
  --dir "$PB_DATA_DIR" \
  --migrationsDir "$PB_MIGRATIONS_DIR" &
PB_PID=$!

sleep 5

echo "Checking for existing PocketBase admin accounts..."
if $PB_BINARY admin list --dir "$PB_DATA_DIR" | grep -q .; then
  echo "✅ Admin account already exists — skipping creation."
else
  echo "Creating PocketBase admin account..."
  if $PB_BINARY admin create "$ADMIN_EMAIL" "$ADMIN_PASSWORD" --dir "$PB_DATA_DIR"; then
    echo "✅ PocketBase admin successfully created: ${ADMIN_EMAIL}"
  else
    echo "❌ Error: Failed to create PocketBase admin account"
    kill $PB_PID
    exit 1
  fi
fi

wait $PB_PID
