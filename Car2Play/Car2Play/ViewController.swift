//
//  ViewController.swift
//  Car2Play
//
//  Created by Frederik Riedel on 10/28/17.
//  Copyright © 2017 Frederik Riedel. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    let ipAddress = "http://192.168.0.1:5000/"
    let motionManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        motionManager.accelerometerUpdateInterval = 0.05
        motionManager.startAccelerometerUpdates()
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (accelerometerData, error) in
            var leftWheelSpeed = 0
            var rightWheelSpeed = 0
            if ((accelerometerData?.acceleration.y)! > 0) {
                // wants to drive to the right side
                leftWheelSpeed = 100
                rightWheelSpeed = Int(100 - ((accelerometerData?.acceleration.y)! * 100))
            } else {
                // wants to drive to the left side
                rightWheelSpeed = 100
                leftWheelSpeed = Int(100 - (-(accelerometerData?.acceleration.y)! * 100))
            }
            
            let json = [ "leftWheel": leftWheelSpeed,
                         "rightWheel": rightWheelSpeed ]
            
            self.getURL(url: URL(string: "\(self.ipAddress)setWheelSpeed")!, json: json)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func stop(_ sender: Any) {
        executeDrivingCommand(command: "stop")
    }
    
    @IBAction func moveForward(_ sender: Any) {
        executeDrivingCommand(command: "forward")
    }
    
    @IBAction func moveRight(_ sender: Any) {
        executeDrivingCommand(command: "right")
    }
    
    @IBAction func moveBackwards(_ sender: Any) {
        executeDrivingCommand(command: "backward")
    }
    
    @IBAction func moveLeft(_ sender: Any) {
        executeDrivingCommand(command: "left")
    }
    
    func executeDrivingCommand(command: String) {
        getURL(url: URL(string: "\(ipAddress)\(command)")!, json: nil)
    }
    
    func getURL(url: URL, json: Dictionary<String, Any>?) {
        let session = URLSession(configuration: .default)
        var request = URLRequest(url:url)
        request.httpBody = try! JSONSerialization.data(withJSONObject: json!, options: .prettyPrinted)
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if error == nil {
                //JSONSerialization
            }
        }
        task.resume()
    
    }
}

