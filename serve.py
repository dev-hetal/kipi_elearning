import http.server
import socketserver
import os

PORT = 5000
DIRECTORY = os.path.join(os.path.dirname(os.path.abspath(__file__)), "example", "build", "web")

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def end_headers(self):
        self.send_header("Cache-Control", "no-cache, no-store, must-revalidate")
        super().end_headers()

with socketserver.TCPServer(("0.0.0.0", PORT), Handler) as httpd:
    print(f"Serving Flutter web app at http://0.0.0.0:{PORT}")
    httpd.serve_forever()
