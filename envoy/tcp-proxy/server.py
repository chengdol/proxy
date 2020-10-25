import socket
import sys
import logging

FORMAT = "[%(threadName)s, %(asctime)s, %(levelname)s] %(message)s"
logging.basicConfig(stream=sys.stdout, level=logging.DEBUG, format=FORMAT)

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Bind the socket to the port
server_address = ('0.0.0.0', 8000)
logging.info(f"starting up on port {server_address}\n")
sock.bind(server_address)

# Listen for incoming connections
sock.listen(1)

while True:
    # Wait for a connection
    logging.info('>>> waiting for a connection')
    connection, client_address = sock.accept()
    try:
        logging.info(f"connection from {client_address}")

        # Receive the data in small chunks and retransmit it
        while True:
            data = connection.recv(1024)
            output = data.decode('utf-8').rstrip("\n")
            if data:
                logging.debug(f"data received: \"{output}\"")
                logging.info('sending data back to the client')
                connection.sendall(data)
            else:
                logging.info(f"no more data from {client_address}\n")
                break

    finally:
        # Clean up the connection
        connection.close()
