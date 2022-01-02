FROM node:bullseye

RUN curl --output /usr/share/keyrings/nginx-keyring.gpg https://unit.nginx.org/keys/nginx-keyring.gpg && \
    printf "deb [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/debian/ bullseye unit\ndeb-src [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/debian/ bullseye unit" > /etc/apt/sources.list.d/unit.list
RUN apt update && \
    apt install -y python3 default-jre golang ruby unit unit-dev unit-go unit-jsc11 unit-python3.9 unit-ruby

WORKDIR /var/www
RUN git clone https://github.com/lcrilly/unit-calculator
RUN cd unit-calculator/divide && \
    npm install body && \
    chmod +x divide.js && \
    npm link unit-http && \
    cd -
RUN cd unit-calculator/sqroot && \
    go mod init unit-calculator/sqroot && \
    go get unit.nginx.org/go && \
    go build -o sqroot sqroot.go && \
    cd -

RUN cp unit-calculator/unitconf.json /var/lib/unit/conf.json
RUN ln -sf /dev/stdout /var/log/unit.log
STOPSIGNAL SIGTERM
EXPOSE 8080 9000
CMD ["unitd", "--no-daemon", "--control", "0.0.0.0:8080"]
