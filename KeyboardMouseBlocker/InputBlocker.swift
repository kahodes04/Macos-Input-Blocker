//
//  InputBlocker.swift
//  KeyboardMouseBlocker
//
//  Created by Guillermo von Stolzmann on 27.07.24.
//

import Foundation
import Cocoa
import Quartz
class InputBlocker {
    
    static let shared = InputBlocker()
    
    var runLoopSource: CFRunLoopSource?
    var eventTap: CFMachPort?
    var keyDownStartTime: Date?
    let requiredHoldTime: TimeInterval = 3.0
    
    let requiredKeyCombination: CGEventFlags = [.maskCommand, .maskControl, .maskAlternate]
    var allowInput: Bool = false
    
    
    private init() {}
    
    func startBlocking() {
        var runLoopSource: CFRunLoopSource?
        
        let keyboardEventMask = CGEventMask(1 << CGEventType.keyDown.rawValue) |
        CGEventMask(1 << CGEventType.keyUp.rawValue) |
        CGEventMask(1 << CGEventType.flagsChanged.rawValue)
        let mouseEventMask =
        CGEventMask(1 << CGEventType.leftMouseDown.rawValue) |
        CGEventMask(1 << CGEventType.leftMouseUp.rawValue) |
        CGEventMask(1 << CGEventType.rightMouseDown.rawValue) |
        CGEventMask(1 << CGEventType.rightMouseUp.rawValue) |
        CGEventMask(1 << CGEventType.scrollWheel.rawValue)
        let eventMask = keyboardEventMask | mouseEventMask
        
        let eventTap = CGEvent.tapCreate(tap: .cghidEventTap, place: .headInsertEventTap, options: .defaultTap, eventsOfInterest: eventMask, callback: myCGEventCallback, userInfo: nil)
        
        guard let eventTap = eventTap else {
            print("Couldn't create event tap!")
            return
        }
        
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        CFRunLoopRun()
    }
    
    let myCGEventCallback: CGEventTapCallBack = { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
        let blocker = InputBlocker.shared
            if event.flags.contains(blocker.requiredKeyCombination) {
                if blocker.allowInput{
                    blocker.allowInput = false
                }else{
                    blocker.allowInput = true
                }
            }else if blocker.allowInput{
                return Unmanaged.passRetained(event)
            }
        return nil
    }
}
