//
//  AppDelegate.swift
//  Swiftlighter
//
//  Created by Ramil Salimov on 22/03/2019.
//  Copyright © 2019 Ramil Salimov. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    @IBAction func helpItemTapped(_ sender: NSMenuItem) {
        if let url = URL(string: "https://mr-uberdeviant.blogspot.com/p/swiftlighter.html"){
            NSWorkspace.shared.open(url)
        }
    }
    

}

