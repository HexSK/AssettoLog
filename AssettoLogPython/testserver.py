import socket
import threading
import json
import time

PORT = 8765
clients = []

def handle_client(conn, addr):
    print(f"Client connected: {addr}")
    clients.append(conn)
    try:
        while True:
            try:
                data = json.dumps({"hello": "world"})
                conn.sendall(data.encode() + b'\n')
                time.sleep(1)
            except (BrokenPipeError, ConnectionResetError) as e:
                print(f"Client {addr} disconnected: {e}")
                break
    finally:
        if conn in clients:
            clients.remove(conn)
        conn.close()

def ws_server():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind(('0.0.0.0', PORT))
    s.listen()
    print(f"Socket server started on port {PORT}")
    while True:
        conn, addr = s.accept()
        threading.Thread(target=handle_client, args=(conn, addr), daemon=True).start()

threading.Thread(target=ws_server, daemon=True).start()

# Keep main thread alive
while True:
    time.sleep(10)
