//
//  AppDelegate.swift
//  Vakta
//
//  Created by submarines on 2021-03-28.
//

import Cocoa

func onGraphicSwitch(display:CGDirectDisplayID, flags:CGDisplayChangeSummaryFlags, userInfo:UnsafeMutableRawPointer?) -> Void
{
    sleep(1)
    let usedGpu = GPU.global.GetActiveGPU()
    
    if(usedGpu == GPUType.Unchanged){
        return
    }
    
    var message = ""
    switch usedGpu {
    case GPUType.Integrated:
        message = "Integrated graphics are now being used!"
    case GPUType.Discrete:
        message = "Discrete graphics are now being used!"
    default:
        message = "Error occured when determining graphics card."
    }
    
    NotificationCenter.default.post(name: Notification.Name.DidGraphicsChange, object: usedGpu)
    Notifications.global.send(message: message)
}

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    
    // on app load
    func applicationDidFinishLaunching(_ aNotification: Notification) {        
        
        // set initial button text
        if let button = self.statusItem.button {
            let usedGpu = GPU.global.GetActiveGPU()
            button.title = self.getLetterForUsedGpuType(type: usedGpu)
        }
        
        // register for updating the button text
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.graphicsChangedCallback),
            name: Notification.Name.DidGraphicsChange,
            object: nil)
        
        // register to notify users
        CGDisplayRegisterReconfigurationCallback(onGraphicSwitch, nil)
    }
    
    // graphics changed callback that will change the button text
    @objc private func graphicsChangedCallback(notification: NSNotification){
        if let type = notification.object as? GPUType {
            if let button = self.statusItem.button {
                button.title = self.getLetterForUsedGpuType(type: type)
            }
        }
    }
    
    // get I / D / V button text for current used gpu type
    private func getLetterForUsedGpuType(type: GPUType) -> String {
        switch type {
        case GPUType.Integrated:
            return "I"
        case GPUType.Discrete:
            return "D"
        default:
            return "V" // ???
        }
    }
    
    
    
    
    // teardown stuff, currently nothing
    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
}
