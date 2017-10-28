from flask import Flask
from AlphaBot2 import AlphaBot2
from flask import request
from lib.servo.servo import Servo

app = Flask(__name__)

Ab = AlphaBot2()
s = Servo()


@app.route("/forward/")
def forward():
    return "forward!"
    Ab.forward()


@app.route("/backward/")
def backward():
    return "backward!"
    Ab.backward()


@app.route("/stop/")
def stop():
    return "stop!"
    Ab.stop()


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
    s.turnLeftRight(position, speed)
    return "servoleftrigth!"


@app.route("/servo/updown/")
def servoUpDown():
    position = int(request.args.get("position"))
    speed = int(request.args.get("speed"))
    s.turnUpDown(position, speed)
    return "servoupdown!"

@app.route("/servo/center/")
def servoCenter():
    s.center()
    return "servoupdown!"

@app.route("/setWheelSpeed/")
def setWheelSpeed():
    left = request.args.get('leftWheelSpeed')
    right = request.args.get('rightWheelSpeed')
    Ab.setMotor(left, right)


if __name__ == '__main__':
    app.run(host="0.0.0.0")
