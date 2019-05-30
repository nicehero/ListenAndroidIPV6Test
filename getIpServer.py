import socket,SocketServer;
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer;
SocketServer.TCPServer.address_family=socket.AF_INET6;
class CustomHTTPRequestHandler(BaseHTTPRequestHandler):
	def do_GET(self):
		self.send_response(200)
		self.send_header('Content-type', 'text/html')
		self.end_headers()
		print (self.client_address)
		self.wfile.write(self.client_address[0])


class CustomHTTPServer(HTTPServer):
	def __init__(self, host, port):
		HTTPServer.__init__(self, (host, port), CustomHTTPRequestHandler)


def main():
	server = CustomHTTPServer('::', 8000)
	server.serve_forever()


if __name__ == '__main__':
    main()
