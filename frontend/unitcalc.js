var operationUri;
var payload = {};
    payload.operands = [];

var xhr = new XMLHttpRequest();
xhr.addEventListener("load", showResult);

function registerDigit(button) {
    document.getElementById('val').value === '0' ? document.getElementById('val').value = button : document.getElementById('val').value += button;
}

function registerOperation(button) {
    if (document.getElementById('val').value === '0') {
        return button === '-' ? registerDigit('-') : document.getElementById('val').value = 'Err';
    }

    payload.operands.push(Number(document.getElementById('val').value));
    document.getElementById('val').value = '';

    switch(button) {
        case '*':
            operationUri = '/multiply';
            break;
        case '/':
            operationUri = '/divide'; // GoLang
            break;
        case '-':
            operationUri = '/subtract'; // Ruby
            break;
        case '+':
            operationUri = '/add'; // Python
            break;
    }
    xhr.open('POST', operationUri);
}

function squareRoot() {
    xhr.open('POST', '/sqroot');
    payload.operand = Number(document.getElementById('val').value);
    console.log("SENDING: " + JSON.stringify(payload));
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.send(JSON.stringify(payload));
}

function allClear() {
    while (payload.operands.length > 0) {
        payload.operands.pop();
    }
    document.getElementById('val').value = '0';
}

function execute() {
    if (document.getElementById('val').value === '0') {
        return document.getElementById('val').value = 'Err';
    }
    payload.operands.push(Number(document.getElementById('val').value));
    console.log("SENDING: " + JSON.stringify(payload));
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.send(JSON.stringify(payload));
}

function showResult() {
    console.log("RECEIVED: " + xhr.responseText);
    while (payload.operands.length > 0) {
        payload.operands.pop();
    }
    document.getElementById('val').value = JSON.parse(xhr.responseText).result;
}
