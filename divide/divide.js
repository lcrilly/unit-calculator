#!/usr/bin/env node

const bd = require("body")
require("unit-http").createServer(function (req, res) {
    bd (req, res, function (err, body) {
        var result = null;
        JSON.parse(body).operands.forEach(operand => {
            result === null ? result = operand : result = result / operand;
        });

        res.writeHead(200, {"Content-Type": "application/json; charset=utf-8"})
        res.end(JSON.stringify({"result": result}, null, "    ").toString("utf8"))
    })
}).listen()
