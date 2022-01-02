#!/usr/bin/env bash

echo -n "*** Checking pre-requisites..."
MISSING=""
for lang in brew java ruby python3; do
        hash $lang 2> /dev/null
        if [ $? -ne 0 ]; then
                MISSING="$lang $MISSING"
        fi
done
if [ "$MISSING" != "" ]; then
    echo " failed"
    echo "PLEASE INSTALL $MISSING"
    exit 1
fi
echo " ok ***"

echo "*** Installing languages pre-requisites ***"
brew install node golang

echo "*** Installing NGINX Unit"
brew install nginx/unit/unit && brew install unit-java unit-python3 unit-ruby

echo "*** Configuring Node.JS division service ***"
cd divide
npm install body
chmod +x divide.js
npm link unit-http
cd -

echo "*** Configuring Golang square root service ***"
cd sqroot
go mod init unit-calculator/sqroot
go get unit.nginx.org/go
go build -o sqroot sqroot.go
cd -

echo "*** Creating local Unit configuration for $PWD as unitconf_local.json ***"
sed "s|/var/www/unit-calculator|${PWD}|g" < unitconf.json > unitconf_local.json

echo "*** Ready ***"
