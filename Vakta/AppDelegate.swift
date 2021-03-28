//
//  AppDelegate.swift
//  Vakta
//
//  Created by Johannes Sörensen on 2021-03-28.
//

import Cocoa

func coregraphicsReconfiguration(display:CGDirectDisplayID, flags:CGDisplayChangeSummaryFlags, userInfo:UnsafeMutableRawPointer?) -> Void
{
    sleep(1)
    let isUsingIntegrated = GPU.global.IsUsingIntegrated()
    let message = isUsingIntegrated ? "Integrated graphics are now being used!" : "Dedicated graphics are now being used!"
    Notifications.global.send(message: message)
}

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {        
        CGDisplayRegisterReconfigurationCallback(coregraphicsReconfiguration, nil)
        
        if let button = self.statusItem.button {
            button.title = "V"
          }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
}
