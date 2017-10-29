from flask import Flask
from AlphaBot2 import AlphaBot2
from flask import request
from lib.servo.servo import Servo
from werkzeug.contrib.cache import SimpleCache

cache = SimpleCache()

app = Flask(__name__)

Ab = AlphaBot2()
s = Servo()


@app.route("/forward/")
def forward():
    Ab.forward()
    return "forward!"


@app.route("/backward/")
def backward():
    Ab.backward()
    return "backward!"


@app.route("/stop/")
def stop():
    Ab.stop()
    return "stop!"


@app.route("/left/")
def left():
    Ab.left()
    return "left!"


@app.route("/right/")
def right():
    Ab.right()
    return "right!"


@app.route("/servo/leftright/")
def servoLeftRight():
    position = int(request.args.get("position"))
    speed = int(request.args.get("speed"))
    current = cache.get("leftright")
    if (current is None):
        current = 2450
    s.turnLeftRight(current, position, speed)
    cache.set("leftright", position)
    return "servoleftrigth!"


@app.route("/servo/updown/")
def servoUpDown():
    position = int(request.args.get("position"))
    speed = int(request.args.get("speed"))
    current = cache.get("updown")
    if (current is None):
        current = 3000
    s.turnUpDown(current, position, speed)
    cache.set("updown", position)
    return "servoupdown!"


@app.route("/servo/center/")
def servoCenter():
    currentUpDown = cache.get("updown")
    currentLeftRight = current = cache.get("leftright")
    if (currentLeftRight is None):
        currentLeftRight = 2450
    if (currentUpDown is None):
        currentUpDown = 2450
    s.center(currentLeftRight, currentUpDown)
    cache.set("leftright", 1500)
    cache.set("updown", 2600)
    return "servoupdown!"


@app.route("/setWheelSpeed/", methods=["POST"])
def setWheelSpeed():
    left = float(request.get_json()['leftWheelSpeed'])
    right = float(request.get_json()['rightWheelSpeed'])
    maximum = float(50)
    # Ab.setMotor(left, right)
    Ab.forward()
    print((maximum * (left / 100)))
    Ab.setPWMA(maximum * (left / 100))
    Ab.setPWMB(maximum * (right / 100))
    return "servoupdown!"


if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True)
