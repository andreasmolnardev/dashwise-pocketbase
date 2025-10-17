FROM alpine:latest
ARG PB_VERSION=0.22.9

# Install curl (required by your init script)
RUN apk add --no-cache curl

# Download and extract PocketBase release
RUN wget -O /pocketbase.zip https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip \
    && unzip /pocketbase.zip -d /app \
    && rm /pocketbase.zip

WORKDIR /app

# Copying init script into the image
COPY init_pb.sh /init_pb.sh
RUN chmod +x /init_pb.sh

# Run init script as entrypoint
ENTRYPOINT ["/init_pb.sh"]
