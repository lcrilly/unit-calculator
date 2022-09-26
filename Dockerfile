FROM node:bullseye

RUN curl --output /usr/share/keyrings/nginx-keyring.gpg https://unit.nginx.org/keys/nginx-keyring.gpg && \
    printf "deb [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/debian/ bullseye unit\ndeb-src [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/debian/ bullseye unit" > /etc/apt/sources.list.d/unit.list
RUN apt update && \
    apt install -y python3 default-jre golang ruby unit unit-dev unit-go unit-jsc11 unit-python3.9 unit-ruby unit-php unit-perl

WORKDIR /var/www/unit-calculator
COPY frontend/ frontend/
COPY backend/ backend/
RUN cd backend && \
    npm install body && \
    npm link unit-http && \
    go mod init unit-calculator/sqroot && \
    go get unit.nginx.org/go && \
    go build -o sqroot sqroot.go && \
    cpan App:cpanminus && cpanm Plack JSON

COPY unitconf.json /var/lib/unit/conf.json
RUN sed -i 's/frontend$uri/frontend/' /var/lib/unit/conf.json 
STOPSIGNAL SIGTERM
EXPOSE 8080 9000
CMD ["unitd", "--no-daemon", "--control", "0.0.0.0:8080", "--log",  "/dev/stderr"]
