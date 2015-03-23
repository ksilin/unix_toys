require 'socket'

host = '0.0.0.0'     # The web server
port = 8888                           # Default HTTP port
path = '/index.htm' # The file we want

# This is the HTTP request we send to fetch a file
request = "GET #{path} HTTP/1.0\r\n\r\n"

socket = Socket.open(host,port)  # Connect to server
puts "sending #{request} to #{socket.inspect}"

socket.print(request)               # Send request
response = socket.read              # Read complete response
puts "got back : #{response}"
# Split response at first blank line into headers and body
# headers,body = response.split("\r\n\r\n", 2)
# print body                          # And display it