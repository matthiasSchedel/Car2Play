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
def servo_leftright():
    handle_request(request, 0)
    return "servoleftright!"

@app.route("/servo/updown/")
def servo_updown():
    handle_request(request, 1)
    return "servoupdown!"


def handle_request(request, mode_id):
    position = int(request.args.get("position"))
    speed = int(request.args.get("speed"))
    defaults = s.leftright_range
    key = "leftright"
    if (mode_id == 1):
        key = "updown"
        defaults = s.updown_range

    current = cache.get(key)
    if (current is None): current = defaults[1]
    result = s.run_servo(current, position, speed, mode_id, defaults)
    cache.set(key, result)

@app.route("/servo/center/")
def servoCenter():
    current_updown = cache.get("updown")
    current_left_right  = cache.get("leftright")
    if (current_left_right is None): current_left_right = s.leftright_range[0]
    if (current_updown is None): current_updown = s.leftright_range[1]
    s.center(current_left_right, current_updown)
    cache.set("leftright", 1500)
    cache.set("updown", 2600)
    return "servoupdown!"


@app.route("/setWheelSpeed/")
def setWheelSpeed():
    left = request.args.get('leftWheelSpeed')
    right = request.args.get('rightWheelSpeed')
    Ab.setMotor(left, right)


if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True)
