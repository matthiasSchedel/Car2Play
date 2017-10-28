//
//  ViewController.swift
//  Car2Play
//
//  Created by Frederik Riedel on 10/28/17.
//  Copyright © 2017 Frederik Riedel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let ipAddress = "http://192.168.0.1:5000/"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        getURL(url: URL(string: "\(ipAddress)\(command)")!)
    }
    
    func getURL(url: URL) {
        let urlSesstion = URLSession(configuration: .default)
        urlSesstion.dataTask(with: url).resume()
    }
}

