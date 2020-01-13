#!/usr/bin/env python3

from http.server import HTTPServer, BaseHTTPRequestHandler
from socketserver import ThreadingMixIn
import json, argparse, sys
from urllib import parse

from pythonlua.translator import Translator

server = None

class handler(BaseHTTPRequestHandler):
    """
    request /transpile
    {
        "pycode": pycode
    }
    -------------------------------------------
    response
    {
        "error": true/false,
        "luacode": luacode/error_msg
    }

    request /exit
    -------------------------------------------
    response
    {
        "exit": true
    }
    """
    def do_POST(self):
        post_path = parse.urlparse(self.path).path

        print(post_path)
        if post_path == '/transpile':
            self._transplie()
        elif post_path == '/exit':
            self._exit()
        else:
            pass

    def _transplie(self):
        content_length = int(self.headers['Content-Length'])
        content = self.rfile.read(content_length)

        data = json.loads(content.decode('utf-8'), 'utf-8')
        pycode = data['pycode']

        print(pycode)

        translator = Translator()
        error, luacode = translator.translate(pycode)

        print('=' * 80)
        print(luacode)

        res = {
            "error": error,
            "luacode": luacode
        }
        res = json.dumps(res)

        self.send_response(200)
        self.send_header('Content-Type',
                         'application/json; charset=utf-8')
        self.end_headers()
        self.wfile.write(res.encode('utf-8'))

    def _exit(self):
        res = {
            "exit": True
        }
        res = json.dumps(res)

        self.send_response(200)
        self.send_header('Content-Type',
                         'application/json; charset=utf-8')
        self.end_headers()
        self.wfile.write(res.encode('utf-8'))

        server.shutdown()


class ThreadedHTTPServer(ThreadingMixIn, HTTPServer):
    """handle requests in a seperate thread."""


def get_parser():
    parser = argparse.ArgumentParser()
    parser.add_argument('--addr', type=str, default='127.0.0.1', help='serve listen address')
    parser.add_argument('--port', type=int, default=8006, help='serve listen port')
    return parser

if __name__ == '__main__':
    parser = get_parser()

    try:
        args = parser.parse_args()
    except SystemExit:
        print('parse arguments error!')
        print(sys.argv)
        sys.exit()

    addr = args.addr
    port = args.port

    server = ThreadedHTTPServer((addr, port), handler)
    print('start server at %s:%d, use <Ctrl-C> to stop' % (addr, port))
    server.serve_forever()
