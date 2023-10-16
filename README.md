UnitCalc 9000
=============

A demo application that implements a simple desktop calculator to highlight various capabilities of [NGINX Unit](https://unit.nginx.org/).

![UnitCalc screenshot](demo.gif)

Application Architecture
------------------------
UnitCalc 9000 is a web application with the following characteristics:

 * HTML/CSS/JavaScript frontend to render a familiar desktop calculator
 * JSON/REST backend API that implements the mathematical operations
 * Each mathematical operation is implemented as a discrete microservice
   - **` + `** Python
   - **` - `** Ruby
   - **` × `** Java
   - **` ÷ `** Node.JS
   - **` √ `** Go
   - **` x²`** PHP
   - **`x^y`** Rust (compiled to WebAssembly)
   - **`1/x`** Perl
 * NGINX Unit serves the frontend and backend components on a single port, and without any other dependencies
   - Each of the mathematical operations are routed to their respective application code
   - All other requests are routed to the `frontend` directory
 
Installation
------------
**Docker**

1. Clone this repo and `cd` into it
2. Build Docker image
   - `docker build -t unitcalc .`
3. Start the image
   - `docker run --name unitcalc -d -p 9000:9000 unitcalc`

**Debian/Ubuntu**
1. Install Unit ([Debian](https://unit.nginx.org/installation/#debian), [Ubuntu](https://unit.nginx.org/installation/#ubuntu))
2. Install all the language modules
   - `apt install unit-dev unit-go unit-jsc20 unit-perl unit-php unit-python3.11 unit-ruby unit-wasm`
3. Install the Node.JS dependencies
   - `apt install nodejs npm`
   - `npm install body unit-http`
4. Install the Perl dependencies
   - `apt install libplack-perl`
   - `sudo cpan App:cpanminus && sudo cpanm --notest Plack JSON`
6. Clone this repo and `cd` into it
7. Create a local configuration for this directory
  - `sed "s|/var/www/unit-calculator|${PWD}|g" < unitconf.json > unitconf_local.json`
8. Start NGINX Unit
   `sudo systemctl start unit`
9. Apply the Unit configuration
   - `sudo unitc /config ./unitconf_local.json`

**macOS**

0. Ensure you have [Homebrew](https://brew.sh/) installed
1. Clone this repo and `cd` into it
2. Install the prerequisites (this will also create a Unit configuration for the current directory)
   - `macos-prep.sh`
3. Start NGINX Unit
   - `unitd --control 127.0.0.1:8080`
4. Apply the Unit configuration
   - `unitc /config ./unitconf_local.json`

Demonstration
-------------
 * Test backend operation
   - `curl -d '{"operands": [5, 10, 10]}' http://localhost:9000/add`
   - Check [Open API Specification](frontend/calculator-oas3.yaml) for other backend operations
 * Open browser at [localhost:9000](http://localhost:9000/)
