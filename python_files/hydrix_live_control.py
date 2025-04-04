from flask import Flask, Response, request, jsonify
import cv2
import serial
import threading
import time
import math


app = Flask(__name__)

# Serial port to Arduino
ser = serial.Serial('COM17', 9600, timeout=1)

# Camera
camera = cv2.VideoCapture(0)

# Command timing
last_command_time = time.time()
stop_delay = 0.5

# Sensor data
sensor_data = {
    "temperature": None,
    "humidity": None,
    "turbidity": None
}

def auto_stop():
    global last_command_time
    while True:
        if time.time() - last_command_time > stop_delay:
            ser.write(b'S')
        time.sleep(0.1)

def read_serial():
    while True:
        try:
            line = ser.readline().decode().strip()
            if line.startswith("TEMP:"):
                parts = line.split(',')
                for part in parts:
                    if "TEMP" in part:
                        sensor_data["temperature"] = float(part.split(':')[1])
                    elif "HUMID" in part:
                        sensor_data["humidity"] = float(part.split(':')[1])
                    elif "TURB" in part:
                        sensor_data["turbidity"] = int(part.split(':')[1])
        except:
            continue

@app.route('/control', methods=['POST'])
def control():
    global last_command_time
    data = request.json
    command = data.get("command", "")

    if command in ["F", "B", "L", "R", "S"]:
        ser.write(command.encode())
        last_command_time = time.time()
        return {"status": "success", "command": command}
    else:
        return {"status": "error", "message": "Invalid command"}, 400


@app.route('/sensor_data')
def get_sensor_data():
    def safe_value(val):
        if val is None or (isinstance(val, float) and math.isnan(val)):
            return 0
        return val

    return jsonify({
        "temperature": safe_value(sensor_data["temperature"]),
        "humidity": safe_value(sensor_data["humidity"]),
        "turbidity": sensor_data["turbidity"] or 0
    })

def generate_frames():
    while True:
        success, frame = camera.read()
        if not success:
            break
        _, buffer = cv2.imencode('.jpg', frame)
        frame_bytes = buffer.tobytes()
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame_bytes + b'\r\n')

@app.route('/video')
def video_feed():
    return Response(generate_frames(), mimetype='multipart/x-mixed-replace; boundary=frame')

if __name__ == "__main__":
    threading.Thread(target=auto_stop, daemon=True).start()
    threading.Thread(target=read_serial, daemon=True).start()
    app.run(host='0.0.0.0', port=5000)
