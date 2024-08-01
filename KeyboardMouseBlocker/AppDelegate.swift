//
//  AppDelegate.swift
//  KeyboardMouseBlocker
//
//  Created by Guillermo von Stolzmann on 15.06.24.
//

import Cocoa
import Foundation
import CoreGraphics
@main
class AppDelegate: NSObject, NSApplicationDelegate{
    var allowInput: Bool = false
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        InputBlocker.shared.startBlocking()
        CFRunLoopRun()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    
}
