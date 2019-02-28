//
//  ViewController.swift
//  Timer
//
//  Created by Zeqiang on 2019/2/26.
//  Copyright © 2019 Zeqiang. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var leftButton: NSButton!
    @IBOutlet weak var rightButton: NSButton!
    @IBOutlet weak var countListButton: NSButton!
    @IBOutlet weak var countListTableView: NSTableView!
    
    private var leftBtnState = BtnState.count
    private var rightBtnState = BtnState.start
    
    private var api = TimerAPI.shared
    
    // Mark: Methods
    
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
                let origin = NSPoint(x: window.frame.origin.x, y: window.frame.origin.y - Constant.countListHeight)
                let size = CGSize(width: window.frame.size.width,
                                  height: window.frame.size.height + Constant.countListHeight)
                frame = NSRect(origin: origin, size: size)
            } else {
                // hide count list
                let origin = NSPoint(x: window.frame.origin.x, y: window.frame.origin.y + Constant.countListHeight)
                let size = CGSize(width: window.frame.size.width,
                                  height: window.frame.size.height - Constant.countListHeight)
                frame = NSRect(origin: origin, size: size)
            }
            window.setFrame(frame, display: true, animate: true)
        }
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
        countListTableView.reloadData()
    }
    
    @IBAction func rightButtonClicked(_ sender: Any) {
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

    private struct Constant {
        static let countListHeight : CGFloat = 131
        static let countListCellIdentifer = NSUserInterfaceItemIdentifier(rawValue: "countListCell")
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

extension ViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return api.countList.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let text = api.countList[row].toFormatedTimeString()
        if let cell = tableView.makeView(withIdentifier: Constant.countListCellIdentifer, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
}
