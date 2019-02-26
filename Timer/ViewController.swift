//
//  ViewController.swift
//  Timer
//
//  Created by Zeqiang on 2019/2/26.
//  Copyright © 2019 Zeqiang. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var leftButton: NSButton!
    @IBOutlet weak var rightButton: NSButton!
    
    private var leftBtnState = BtnState.count
    private var rightBtnState = BtnState.start
    
    private var api = TimerAPI.shared
    
    override func viewWillAppear() {
        let styleMask: NSWindow.StyleMask = [.titled, .fullSizeContentView]
        self.view.window?.animator().styleMask = styleMask
    }
    
    override func viewDidLoad() {
        api.delegate = self
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func leftButtonClicked(_ sender: Any) {
        if leftBtnState == .count {
            api.count()
        } else if leftBtnState == .reset{
            api.reset()
        }
    }
    
    @IBAction func rightButtonClicked(_ sender: Any) {
        print("START Button Clicked")
        if rightBtnState == .start {
            api.start()
            rightBtnState = .stop
            leftBtnState = .count
        } else if rightBtnState == .stop {
            api.stop()
            rightBtnState = .start
            leftBtnState = .reset
        }
        updateButtonUI()
    }
    
    func updateButtonUI() {
        // TODO: shorten the code
        print("Update UI")
        if rightBtnState == .start {
            rightButton.title = "START"
        } else if rightBtnState == .stop {
            rightButton.title = "STOP"
        }
        
        if leftBtnState == .count {
            leftButton.title = "COUNT"
        } else if leftBtnState == .reset{
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

