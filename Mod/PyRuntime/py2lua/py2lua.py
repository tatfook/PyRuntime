#!/usr/bin/env python3

from http.server import HTTPServer, BaseHTTPRequestHandler
from socketserver import ThreadingMixIn
import json, argparse, sys, threading
from urllib import parse
from timeit import default_timer as timer
from datetime import timedelta
from threading import Timer

from pythonlua.translator import Translator

server = None
monitor = None
verbose = None
max_idle_interval = None

last_visit_time = timer()
check_interval = 10 # seconds


def check():
    now = timer()

    if verbose:
        print('now is time', now)
        print('last visit time', last_visit_time)

    if timedelta(seconds=(now - last_visit_time)) > max_idle_interval:
        exit_server()

def exit_server():
    server.shutdown()
    monitor.cancel()


class handler(BaseHTTPRequestHandler):
    """
    request /transpile
    {
        "pycode": pycode
    }
    response
    {
        "error": true/false,
        "luacode": luacode/error_msg
    }

    request /exit
    response
    {
        "exit": true
    }
    """
    def do_POST(self):
        post_path = parse.urlparse(self.path).path

        if verbose:
            start = timer()

        if post_path == '/transpile':
            self._transplie()
        elif post_path == '/exit':
            self._exit()
        else:
            pass

        if verbose:
            end = timer()
            print(threading.currentThread().getName(), 'time consume:', timedelta(seconds=end-start))


    def _transplie(self):
        global last_visit_time
        last_visit_time = timer()

        content_length = int(self.headers['Content-Length'])
        content = self.rfile.read(content_length)

        data = json.loads(content.decode('utf-8'), 'utf-8')
        pycode = data['pycode']

        translator = Translator()
        error, luacode = translator.translate(pycode)

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

        if verbose:
            print('=' * 40)
            print(pycode)
            print('-' * 40)
            print(luacode)
            print('=' * 40)


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

        exit_server()


class ThreadedHTTPServer(ThreadingMixIn, HTTPServer):
    """handle requests in a seperate thread."""


class RepeatTimer(Timer):
    def run(self):
        while not self.finished.wait(self.interval):
            self.function(*self.args, **self.kwargs)


def get_parser():
    parser = argparse.ArgumentParser()
    parser.add_argument('--addr', type=str, default='127.0.0.1', help='serve listen address')
    parser.add_argument('--port', type=int, default=8006, help='serve listen port')
    parser.add_argument('--verbose', dest='verbose', action='store_true', help='if show verbose information')
    parser.add_argument('--idle_time', type=int, default=30, help='serve will auto exit from being idle in minutes')
    parser.set_defaults(verbose=False)
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
    verbose = args.verbose
    max_idle_interval = timedelta(minutes=args.idle_time)

    monitor = RepeatTimer(check_interval, check)
    monitor.start()

    server = ThreadedHTTPServer((addr, port), handler)
    print('start server at %s:%d, use <Ctrl-C> to stop' % (addr, port))
    server.serve_forever()
