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
            print(accelerometerData!.acceleration.x, accelerometerData!.acceleration.y, accelerometerData!.acceleration.z)
            var leftWheelSpeed = 0
            var rightWheelSpeed = 0
            let speed = accelerometerData!.acceleration.z * -100
            if ((accelerometerData?.acceleration.y)! > 0) {
                // wants to drive to the right side
                leftWheelSpeed = Int(speed)
                rightWheelSpeed = Int((1 - (accelerometerData?.acceleration.y)!) * speed)
            } else {
                // wants to drive to the left side
                rightWheelSpeed = Int(speed)
                leftWheelSpeed = Int((1 + (accelerometerData?.acceleration.y)!) * speed)
            }
            
            
            let json = [ "leftWheelSpeed": max(min(leftWheelSpeed, 100), -100),
                         "rightWheelSpeed": max(min(rightWheelSpeed, 100), -100) ]
            print(json)
            if (self.shouldDrive) {
                self.getURL(url: URL(string: "\(self.ipAddress)setWheelSpeed/")!, json: json, method: "POST")
            }
            
        }
        
        self.webView.navigationDelegate = self
        self.webView.isUserInteractionEnabled = false
        self.webView.load(URLRequest(url: URL(string: "http://192.168.0.1:8080/cam/")!))
        self.view.sendSubview(toBack: self.webView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stop(_ sender: Any) {
        self.stop()
    }
    
    func stop() {
        executeDrivingCommand(command: "stop")
    }
    
    func executeDrivingCommand(command: String) {
        getURL(url: URL(string: "\(ipAddress)\(command)/")!, json: nil)
    }
    
    func getURL(url: URL, json: Dictionary<String, Any>?, method: String = "GET") {
        let session = URLSession(configuration: .default)
        var request = URLRequest(url:url)
        
        request.httpMethod = method
        if let json = json {
            request.httpBody = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            print(error, url)
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

