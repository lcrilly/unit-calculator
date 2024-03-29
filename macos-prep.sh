#!/usr/bin/env bash

if [ "$1" == "--nochecks" ]; then
    printf "${0##*/}: INFO: Skipping system pre-requisites\n"
else
    printf "${0##*/}: INFO: Checking system pre-requisites\n"
    MISSING=""
    for dep in brew ruby python3; do
            $dep --version
            if [ $? -ne 0 ]; then
                    MISSING="$dep $MISSING"
            fi
    done
    if [ "$MISSING" != "" ]; then
        printf "${0##*/}: ERROR: Missing system pre-requisites, please install $MISSING\n"
        exit 1
    fi

    printf "${0##*/}: INFO: Installing languages pre-requisites\n"
    brew install node golang

    printf "\n${0##*/}: INFO: Installing NGINX Unit and language module essentials\n"
    brew install nginx/unit/unit && brew install unit-java unit-python3 unit-ruby unit-php unit-perl
    npm install -g --unsafe-perm unit-http
    gem install rack
    sudo cpan App:cpanminus && sudo cpanm --notest Plack JSON
fi

printf "\n${0##*/}: INFO: Configuring Node.JS division service\n"
cd backend
npm install body && npm link --ignore-scripts unit-http

printf "\n${0##*/}: INFO: Configuring Golang square root service\n"
go mod init unit-calculator/sqroot && go get unit.nginx.org/go
go build -o sqroot sqroot.go
cd -

printf "\n${0##*/}: INFO: Creating local Unit configuration for $PWD as unitconf_local.json\n"
sed "s|/var/www/unit-calculator|${PWD}|g" < unitconf.json > unitconf_local.json

printf "${0##*/}: INFO: Ready to start\n"
