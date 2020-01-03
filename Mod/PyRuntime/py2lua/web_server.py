from http.server import HTTPServer, BaseHTTPRequestHandler
from socketserver import ThreadingMixIn
import json

class handler(BaseHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        raw = self.rfile.read(content_length)

        self.send_response(200)
        self.send_header('Content-Type',
                         'application/json; charset=utf-8')
        self.end_headers()

        d = json.loads(raw.decode('utf-8'), 'utf-8')
        print(d['code'])

        self.wfile.write(raw)

class ThreadedHTTPServer(ThreadingMixIn, HTTPServer):
    """handle requests in a seperate thread."""

if __name__ == '__main__':
    port = 8080
    server = ThreadedHTTPServer(('localhost', port), handler)
    print('start server at port %d, use <Ctrl-C> to stop' % port)
    server.serve_forever()
