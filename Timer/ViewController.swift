//
//  ViewController.swift
//  Timer
//
//  Created by Zeqiang on 2019/2/26.
//  Copyright © 2019 Zeqiang. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    private let countListHeight : CGFloat = 131
    
    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var leftButton: NSButton!
    @IBOutlet weak var rightButton: NSButton!
    @IBOutlet weak var countListButton: NSButton!
    
    private var api = TimerAPI.shared
    
    override func viewWillAppear() {
        let styleMask: NSWindow.StyleMask = [.titled, .fullSizeContentView]
        self.view.window?.animator().styleMask = styleMask
    }
    
    override func viewDidLoad() {
        api.delegate = self
    }
    
    @IBAction func countListButtonClicked(_ sender: Any) {
        if let window = self.view.window {
            var frame : NSRect
            if countListButton.state == .on {
                // show count list
                let origin = NSPoint(x: window.frame.origin.x, y: window.frame.origin.y - countListHeight)
                let size = CGSize(width: window.frame.size.width, height: window.frame.size.height + countListHeight)
                frame = NSRect(origin: origin, size: size)
            } else {
                // hide count list
                let origin = NSPoint(x: window.frame.origin.x, y: window.frame.origin.y + countListHeight)
                let size = CGSize(width: window.frame.size.width, height: window.frame.size.height - countListHeight)
                frame = NSRect(origin: origin, size: size)
            }
            window.setFrame(frame, display: true, animate: true)
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func leftButtonClicked(_ sender: Any) {
        if leftButton.state == .on {
            api.count()
        } else {
            api.reset()
        }
    }
    
    @IBAction func rightButtonClicked(_ sender: Any) {
        print("START Button Clicked")
        if rightButton.state == .on {
            api.start()
            leftButton.state = .on
        } else{
            api.stop()
            leftButton.state = .off
        }
        updateButtonUI()
    }
    
    func updateButtonUI() {
        // TODO: shorten the code
        print("Update UI")
        if rightButton.state == .off {
            rightButton.title = "START"
        } else {
            rightButton.title = "STOP"
        }
        
        if leftButton.state == .off {
            leftButton.title = "COUNT"
        } else{
            leftButton.title = "RESET"
        }
    }
}

extension ViewController {
    private enum BtnState {
        case start
        case stop
        case count
        case reset
    }
}

extension ViewController: TimerAPIDelegate {
    func tickHandler(timePast: Int) {
        self.timeLabel.stringValue = timePast.toFormatedTimeString()
    }
    
    func resetHandler() {
        self.timeLabel.stringValue = 0.toFormatedTimeString()
    }
}

