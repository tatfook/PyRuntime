#!/usr/bin/env python3

from http.server import HTTPServer, BaseHTTPRequestHandler
from socketserver import ThreadingMixIn
import json

from pythonlua.translator import Translator

class handler(BaseHTTPRequestHandler):
    """
    post json
    {
        "pycode": pycode
    }

    res json
    {
        "error": true/false,
        "luacode": luacode/error_msg
    }
    """
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        content = self.rfile.read(content_length)

        data = json.loads(content.decode('utf-8'), 'utf-8')
        pycode = data['pycode']

        translator = Translator()
        error, luacode = translator.translate(pycode)

        self.send_response(200)
        self.send_header('Content-Type',
                         'application/json; charset=utf-8')
        self.end_headers()

        res = {
            "error": error,
            "luacode": luacode
        }
        res = json.dumps(res)

        self.wfile.write(res.encode('utf-8'))


class ThreadedHTTPServer(ThreadingMixIn, HTTPServer):
    """handle requests in a seperate thread."""


if __name__ == '__main__':
    port = 8080
    server = ThreadedHTTPServer(('localhost', port), handler)
    print('start server at port %d, use <Ctrl-C> to stop' % port)
    server.serve_forever()
