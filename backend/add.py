import json

def application(environ, start_response):
    try:
        request_body_size = int(environ.get('CONTENT_LENGTH', 0))
    except (ValueError):
        request_body_size = 0

    request_body = environ['wsgi.input'].read(request_body_size)
    reqj = json.loads(request_body)

    res = { "result": 0 }
    for value in reqj['operands']:
        res['result'] += value
    
    start_response('200 OK', [('Content-Type', 'application/json')])
    yield str.encode(json.dumps(res))