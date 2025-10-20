import mmap, struct, time
import socket, json, threading

PHYSICS_FILE = "/dev/shm/acpmf_physics"
GRAPHICS_FILE = "/dev/shm/acpmf_graphics"
AC_PHYSICS_SIZE = 2048
AC_GRAPHICS_SIZE = 2048

PORT = 8765
clients = []

def handle_client(conn, addr):
    print("Client connected: {}".format(addr))
    clients.append(conn)

    try:
        while True:
            try:
                data = json.dumps({
                    "rpms": rpms,
                    "speed": speed,
                    "gear": gear,
                    "gas": gas,
                    "brake": brake
                })
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


def open_shm(file_path, size):
    f = open(file_path, "r+b")
    mm = mmap.mmap(f.fileno(), size)
    return mm

mm_phys = open_shm(PHYSICS_FILE, AC_PHYSICS_SIZE)
mm_graph = open_shm(GRAPHICS_FILE, AC_GRAPHICS_SIZE)

def read_int(mm, offset):
    return struct.unpack('i', mm[offset:offset+4])[0]

def read_float(mm, offset):
    return struct.unpack('f', mm[offset:offset+4])[0]

PHYS_RPMS = 20
PHYS_SPEED = 28
PHYS_GAS = 4
PHYS_BRAKE = 8
PHYS_GEAR = 16

GRAPH_COMPLETED_LAPS = 60
GRAPH_POSITION = 64
GRAPH_SESSION_TYPE = 8

try:
    while True:
        rpms = read_int(mm_phys, PHYS_RPMS)
        speed = read_float(mm_phys, PHYS_SPEED)

        gear = read_int(mm_phys, PHYS_GEAR)
        gas = read_float(mm_phys, PHYS_GAS)
        brake = read_float(mm_phys, PHYS_BRAKE)

        print(f"{rpms}\n{speed:.1f}\n{gear}\n{gas}\n{brake}")
        time.sleep(0.1)
except KeyboardInterrupt:
    print("Exiting....")
finally:
    mm_phys.close()
    mm_graph.close()

while True:
    time.sleep(10)