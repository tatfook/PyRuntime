#!/usr/bin/env python3

from http.server import HTTPServer, BaseHTTPRequestHandler
from socketserver import ThreadingMixIn
import json, argparse

from pythonlua.translator import Translator

class handler(BaseHTTPRequestHandler):
    """
    request json
    {
        "pycode": pycode
    }
    -------------------------------------------
    response json
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

def get_parser():
    parser = argparse.ArgumentParser()
    parser.add_argument('--addr', type=str, default='127.0.0.1', help='serve listen address')
    parser.add_argument('--port', type=int, default=8000, help='serve listen port')
    return parser

if __name__ == '__main__':
    parser = get_parser()
    args = parser.parse_args()
    addr = args.addr
    port = args.port

    server = ThreadedHTTPServer((addr, port), handler)
    print('start server at %s:%d, use <Ctrl-C> to stop' % (addr, port))
    server.serve_forever()
