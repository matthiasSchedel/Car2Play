//
//  CameraController.swift
//  Car2Play
//
//  Created by Leo Mehlig on 28.10.17.
//  Copyright © 2017 Frederik Riedel. All rights reserved.
//

import UIKit
import WebKit

class CameraController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.navigationDelegate = self
        self.webView.isUserInteractionEnabled = false
        self.webView.load(URLRequest(url: URL(string: "http://10.200.79.4:8880/html/")!))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("toggle_fullscreen(document.getElementById(\"mjpeg_dest\"));", completionHandler: nil)
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }

}
