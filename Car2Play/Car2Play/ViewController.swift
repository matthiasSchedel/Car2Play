//
//  ViewController.swift
//  Car2Play
//
//  Created by Frederik Riedel on 10/28/17.
//  Copyright © 2017 Frederik Riedel. All rights reserved.
//

import UIKit
import CoreMotion
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    let ipAddress = "http://192.168.0.1:5000/"
    let motionManager = CMMotionManager()
    @IBOutlet weak var webView: WKWebView!
    var shouldDrive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        motionManager.accelerometerUpdateInterval = 0.5

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
            
            
            let json = [ "leftWheelSpeed": leftWheelSpeed,
                         "rightWheelSpeed": rightWheelSpeed ]
            print(json)
            if (self.shouldDrive) {
                self.getURL(url: URL(string: "\(self.ipAddress)setWheelSpeed/")!, json: json)
            }

        }
        
        self.webView.navigationDelegate = self
        self.webView.isUserInteractionEnabled = false
        self.webView.load(URLRequest(url: URL(string: "http://10.200.79.4:8880/html/")!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func stop(_ sender: Any) {
        executeDrivingCommand(command: "stop")
    }
    
    @IBAction func moveForward(_ sender: Any) {
        executeDrivingCommand(command: " ")
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

        request.httpMethod = "POST"
        if let json = json {
            request.httpBody = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let task = session.dataTask(with: request) {
            (data, response, error) in
            if error == nil {
                //JSONSerialization
            }
        }
        task.resume()
    
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("toggle_fullscreen(document.getElementById(\"mjpeg_dest\"));", completionHandler: nil)
    }
    
    @IBAction func accelerate(_ sender: Any) {
        shouldDrive = true
    }
    
 
    @IBAction func stopCar(_ sender: Any) {
        shouldDrive = false
        executeDrivingCommand(command: "stop")
    }
    
}

