from lib.servo.PCA9685 import PCA9685
import time

pwm = PCA9685(0x40, debug=True)
pwm.setPWMFreq(50)


class Servo:
    def __init__(self):
        self.currentPosUpDown = 2400
        self.currentPosLeftRight = 2450

    def turnLeftRight(self, position, speed):

        if (position > 2450):
            position = 2450
        elif (position < 500):
            position = 550
        if (position < self.currentPosLeftRight):
            speed = speed * -1
            for i in range(position, self.currentPosLeftRight, speed):
                pwm.setServoPulse(0, i)
                time.sleep(0.02)
        else:
            for i in range(self.currentPosLeftRight, position, speed):
                pwm.setServoPulse(0, i)
                time.sleep(0.02)
        self.currentPosLeftRight = position

    def slideLeftRight(self, direction):
        steps = 550
        if (direction == -1):
            position = 2450
        self.turnLeftRight(position, 10)

    def turnUpDown(self, position, speed):
        if (position < self.currentPosLeftRight): speed = speed * -1
        if (position > 2400):
            position = 2400
        elif (position < 500):
            position = 500
        for i in range(self.currentPosUpDown, position, speed):
            pwm.setServoPulse(1, i)
            time.sleep(0.02)
        self.currentPosUpDown = position

    def center(self):
        self.turnLeftRight(1000, 10)
        self.turnUpDown(2450, 10)
