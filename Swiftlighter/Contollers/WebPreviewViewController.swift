//
//  WebPreviewViewController.swift
//  Swiftlighter
//
//  Created by Ramil Salimov on 27/03/2019.
//  Copyright © 2019 Ramil Salimov. All rights reserved.
//

import Cocoa
import WebKit

class WebPreviewViewController: NSViewController {
    
    var webCode: String!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        updateWebView()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
    }
    
    func updateWebView(){
        if let code = webCode{
            webView.loadHTMLString(code, baseURL: nil)
        }
    }
}
