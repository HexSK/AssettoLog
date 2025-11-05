import asyncio
import websockets
import json
import random
import datetime
import threading
import sys

running = True

async def generate_data(server_running=1):
    rpmList = [1000, 2000, 3000, 4000, 5000, 6000, 7000]
    speedList = [10, 30, 50, 70, 90, 110, 130]
    gearList = [0, 1, 2, 3, 4, 5, 6, 7]
    fuelLeftList = [35, 34, 33, 32, 31, 30, 29]
    litersPerLapList = [2.1, 2.2, 1.8, 1.9, 2.4, 1.5, 2.8, 2.3]
    lapNumberList = [33, 34, 35, 36, 37, 38, 39]
    currentLapTime = [83.534, 82.342, 84.231, 82.341, 82.412, 85.123, 89.231]

    i = random.randint(0, 6)
    return {
        "speed": speedList[i],
        "RPM": rpmList[i],
        "gear": gearList[i],
        "fuelLeft": fuelLeftList[i],
        "litersPerLap": litersPerLapList[i],
        "lapNumber": lapNumberList[i],
        "currentLapTime": currentLapTime[i],
        "bestLapTime": min(currentLapTime),
        "serverRunning": server_running
    }

def check_quit():
    global running
    while running:
        if input() == 'q':
            running = False

async def handler(websocket):
    global running
    print(f"Client connected: {websocket.remote_address}")
    try:
        while running:
            data = await generate_data(1 if running else 0)
            await websocket.send(json.dumps(data))
            print(f"[{datetime.datetime.now()}] Sent {data}")
            await asyncio.sleep(1)
        final_data = await generate_data(0) #final words
        await websocket.send(json.dumps(final_data))
        print(f"[{datetime.datetime.now()}] Final message sent: {final_data}")
    except websockets.exceptions.ConnectionClosed:
        print(f"Client disconnected: {websocket.remote_address}")

async def main():
    global running
    input_thread = threading.Thread(target=check_quit)
    input_thread.daemon = True
    input_thread.start()

    server = await websockets.serve(handler, "0.0.0.0", 44148)
    print("WebSocket server running on ws://0.0.0.0:44148")
    print("Press 'q' and Enter to quit")
    
    try:
        while running:
            await asyncio.sleep(1)
    finally:
        server.close()
        await server.wait_closed()

if __name__ == "__main__":
    if input("Run server? [y/n]: ") == 'y':
        asyncio.run(main())
    else:
        print("o no")
        exit()