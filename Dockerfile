# This is a 3-stage build process to produce a smaller image

# Stage 1: Create base image with the packages needed in stages 2 & 3
# and prepare the apt repos so that we don't need to `apt update` again
#
FROM debian:bullseye-slim AS core
RUN apt update && \
    apt install -y python3 curl make && \
    rm -rf /var/lib/apt/lists/*
RUN curl --output /usr/share/keyrings/nginx-keyring.gpg https://unit.nginx.org/keys/nginx-keyring.gpg && \
    printf "deb [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/debian/ bullseye unit\ndeb-src [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/debian/ bullseye unit" > /etc/apt/sources.list.d/unit.list
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt update && \
    apt install -y nodejs

# Stage 2: build the unit-npm npm module and Golang binary using packages
# that won't be needed at runtime
#
FROM core AS build
RUN apt install -y golang unit-dev
WORKDIR /var/www/unit-calculator/backend
COPY backend/ ./
RUN npm install body unit-http
RUN go mod init unit-calculator/sqroot && \
    go get unit.nginx.org/go && \
    go build -o sqroot sqroot.go

# Stage 3: copy the build artefacts from stage 2 into the core image we
# created in stage 1
#
FROM core
RUN apt install -y default-jre ruby unit unit-jsc11 unit-python3.9 unit-ruby unit-php unit-perl libplack-perl libjson-perl && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /var/www/unit-calculator
COPY frontend/ frontend/
COPY --from=build /var/www/unit-calculator/backend backend/

# Apply the Unit configuration using the control API
#
COPY unitconf.json init.json
RUN nohup /bin/sh -c "unitd --no-daemon --pid init.pid --log /dev/stdout --control unix:init.unit.sock &" && \
    curl -fsX PUT -d@init.json --unix-socket init.unit.sock _/config && \
    rm init.*

# Simple runtime behaviour for the final image
#
STOPSIGNAL SIGTERM
EXPOSE 8080 9000
CMD ["unitd", "--no-daemon", "--control", "0.0.0.0:8080", "--log", "/dev/stderr"]
