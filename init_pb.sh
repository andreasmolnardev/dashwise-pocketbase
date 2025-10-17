#!/bin/sh

PB_BINARY="/app/pocketbase"
PB_PORT=0.0.0.0:8090

ADMIN_EMAIL="${PB_ADMIN_EMAIL:-default@dashwise.local}"
ADMIN_PASSWORD="${PB_ADMIN_PASSWORD:-dashwiseIsAwesome}"

# Start PocketBase as background service
$PB_BINARY serve --http $PB_PORT &
PB_PID=$!

sleep 5

echo "Creating PocketBase admin account..."
if $PB_BINARY admin create "$ADMIN_EMAIL" "$ADMIN_PASSWORD"; then
  echo "PocketBase admin successfully created: ${ADMIN_EMAIL}"
else
  echo "Error: Failed to create PocketBase admin account"
  kill $PB_PID
  exit 1
fi

wait $PB_PID
