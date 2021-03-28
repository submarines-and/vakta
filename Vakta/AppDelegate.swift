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
    print(isUsingIntegrated)
}

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {        
        CGDisplayRegisterReconfigurationCallback(coregraphicsReconfiguration, nil)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
}
