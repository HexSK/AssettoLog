import os
import sys
import platform
if platform.architecture()[0] == '64bit':
    sys.path.insert(0, 'apps/python/AssettoLog/third_party/stdlib64')
else:
    sys.path.insert(0, 'apps/python/AssettoLog/third_party/stdlib')
os.environ['PATH'] = os.environ['PATH'] + ';.'
#do this ^ before using imports from third_party, including _socket
import ac, acsys
from third_party.sim_info import *
import threading, socket, json, time
import subprocess

appName="SIMTRACKER"
width, height = 200, 200
PORT=8765
speed=0.0

simInfo = SimInfo()
clients = []

def handle_client(conn, addr):
    ac.log("Client connected: " + str(addr))
    clients.append(conn)
    try:
        while True:
            try:
                data = json.dumps({"speed": speed,
                                   "RPM": rpm,
                                   "gear": gear})
                conn.sendall(data.encode() + b'\n')
                time.sleep(1)
            except (BrokenPipeError, ConnectionResetError) as e:
                ac.log("Client " + str(addr) + " disconnected: " + str(e))
                break
    finally:
        if conn in clients:
            clients.remove(conn)
        conn.close()

def ws_server():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind(('0.0.0.0', PORT))
    s.listen()
    ac.log("Socket server started on port " + str(PORT))
    while True:
        conn, addr = s.accept()
        threading.Thread(target=handle_client, args=(conn, addr), daemon=True).start()

def acMain(ac_version):
    threading.Thread(target=ws_server, daemon=True).start()
    ac.log("Telemetry plugin loaded!")

    global appWindow, speedLabel, rpmLabel, gearLabel
    appWindow = ac.newApp(appName)
    ac.setTitle(appWindow, appName)
    ac.setSize(appWindow, width, height)

    speedLabel = ac.addLabel(appWindow, "Speed: 0km/h")
    ac.setPosition(speedLabel, 20, 20)

    rpmLabel = ac.addLabel(appWindow, "RPM: ")
    ac.setPosition(rpmLabel, 20, 40)

    gearLabel = ac.addLabel(appWindow, "Gear: ")
    ac.setPosition(gearLabel, 20, 60)

    ac.addRenderCallback(appWindow, appGL)
    
    # while True:
    #     time.sleep(1)
    return appName

def appGL(deltaT):
    pass

def acUpdate(deltaT):
    global speed, rpm, gear

    speed = ac.getCarState(0, acsys.CS.SpeedKMH)
    rpm = ac.getCarState(0, acsys.CS.RPM)
    gear = ac.getCarState(0, acsys.CS.Gear)

    ac.log("Current speed: {:.1f} km/h".format(speed))
    ac.log("Current RPM: {:.0f}".format(rpm))
    ac.log("Current Gear: {}".format(gear))

    ac.setText(speedLabel, "Speed: {:.1f} km/h".format(speed))
    ac.setText(rpmLabel, "RPM: {:.0f}".format(rpm))
    if gear == 0:
        ac.setText(gearLabel, "Gear: R")
    elif gear == 1:
        ac.setText(gearLabel, "Gear: N")
    else:
        ac.setText(gearLabel, "Gear: {}".format(gear-1))
