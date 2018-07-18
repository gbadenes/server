#!/usr/bin/python

import socket
import sys
import json
import os
from datetime import datetime

# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Bind the socket to the port
server_address = ('0.0.0.0', 12345)
print >>sys.stderr, 'starting up on %s port %s' % server_address
sock.bind(server_address)

# Listen for incoming connections
sock.listen(1)

while True:
    # Wait for a connection
    print >>sys.stderr, 'waiting for a connection'
    connection, client_address = sock.accept()
    try:
        print >>sys.stderr, 'connection from', client_address

        # Receive the data in small chunks and retransmit it
        while True:
            data = connection.recv(1024)
            print >>sys.stderr, 'received "%s"' % data
            if data:
                # split incoming data in format '[DD/MM/YYYY HH:MM] MESSAGE BODY' 
                # to get date time and message
                string = data.split("]")
                epoc = string[0]
                # remove first [ from the date and convert to epoch
                epoc = epoc[1:]
		dt = datetime.strptime(epoc, '%d/%m/%Y  %H:%M')
                timestamp = (dt - datetime(1970,1,1)).total_seconds()
                
                # remove fist blank space from message
		message = string[1]
                message = message[1:]
		
                # create a dictionary to store all the data
                d = {}
                d["timestamp"] = str(timestamp)
                d["container"] = socket.gethostname()
                # get environment varaible passed as argument
                d["hostname"] = os.environ['HOST']
                d["message"] = message
                
                # dump data to client
                data = json.dumps(d)
		
                print >>sys.stderr, 'sending data back to the client'
                connection.sendall(data+'\n')
            else:
                print >>sys.stderr, 'no more data from', client_address
                break
            
    finally:
        # Clean up the connection
        connection.close()
