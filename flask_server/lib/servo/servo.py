from __future__ import print_function  # In python 2.7
from lib.servo.PCA9685 import PCA9685
import time

pwm = PCA9685(0x40, debug=True)
pwm.setPWMFreq(50)


class Servo:
    def __init__(self):
        self.updown_range = [0, 1500]
        self.leftright_range = [0, 3000]

        self.updown_center = 1650
        self.leftright_center = 1500

    def run_servo(self, current, position, speed, motor_id, defaults):
        if (position > defaults[1]):
            position = defaults[1]
        elif (position < defaults[0]):
            position = defaults[0]
        if (position < current):
            speed = speed * -1
            for i in range(current, position, speed):
                pwm.setServoPulse(motor_id, i)
                time.sleep(0.02)
        else:
            for i in range(current, position, speed):
                pwm.setServoPulse(motor_id, i)
                time.sleep(0.02)
        return position

    def center(self, current_leftright, current_updown):
        self.run_servo(current_leftright, self.leftright_center, 10, 0, self.leftright_range)
        self.run_servo(current_updown, self.updown_center, 10, 1, self.updown_range)
