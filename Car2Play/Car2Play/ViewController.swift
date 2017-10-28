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
        getURL(url: URL(string: "\(ipAddress)stop")!)
    }
    
    @IBAction func moveForward(_ sender: Any) {
        getURL(url: URL(string: "\(ipAddress)forward")!)
    }
    
    @IBAction func moveRight(_ sender: Any) {
        getURL(url: URL(string: "\(ipAddress)right")!)
    }
    
    @IBAction func moveBackwards(_ sender: Any) {
        getURL(url: URL(string: "\(ipAddress)backward")!)
    }
    
    @IBAction func moveLeft(_ sender: Any) {
        getURL(url: URL(string: "\(ipAddress)left")!)
    }
    
    func getURL(url: URL) {
        let urlSesstion = URLSession(configuration: .default)
        urlSesstion.dataTask(with: url).resume()
    }
}

