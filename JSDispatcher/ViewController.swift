//
//  ViewController.swift
//  JSDispatcher
//
//  Created by Jake Spracher on 9/28/15.
//  Copyright © 2015 Jake Spracher. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var currentProcess: Process!
    var readyList: [(process: Process, priority: Int)] = []
    var blockedList: [(process: Process, priority: Int)] = []
    
    @IBOutlet var newProcessName: NSTextField!
    @IBOutlet var newProcessPriority: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // initialize processes
        let p1 =  Process()
        p1.processNumber = 1
        let p2 =  Process()
        p2.processNumber = 2
        let p3 =  Process()
        p3.processNumber = 3
        let p4 =  Process()
        p4.processNumber = 4
        let p5 =  Process()
        p5.processNumber = 5
        
        // add to ready list and assign priorities
        readyList.append((p1, 9))
        readyList.append((p2, 3))
        readyList.append((p3, 7))
        readyList.append((p4, 11))
        readyList.append((p5, 6))
        
        // start the most important process
        contextSwitchNext()
        
    }

    // MARK: - Process Dispatcher
    
    @IBAction func makeNewProcess(sender: NSButton) {
        
    }
    
    
    
    func contextSwitchNext() {
        if readyList.count > 0 {
            var max = readyList[0].priority
            var maxIndex = 0
            for i in 1...(readyList.count - 1) {
                if readyList[i].priority > max {
                    max = readyList[0].priority
                    maxIndex = i
                }
            }
            
            currentProcess = readyList[maxIndex].process
            readyList.removeAtIndex(maxIndex)
        } else {
            print("no processes to run")
        }
    }

}

// MARK: - NSTableViewDataSource
extension ViewController: NSTableViewDataSource {
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        return readyList.count + blockedList.count + 1
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {

        let cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        
        let currentArray = readyList + blockedList
        
        if tableColumn!.identifier == "PID" {
            if row == 0 {
                cellView.textField!.stringValue = String(currentProcess.processNumber)
            } else {
                cellView.textField!.stringValue = String(currentArray[row - 1].process.processNumber)
            }
        } else if tableColumn!.identifier == "Status" {
            if row == 0 {
                cellView.textField!.stringValue = "Current Process"
            } else if row - 1 < readyList.count {
                cellView.textField!.stringValue = "Ready"
            } else if row - 1 >= readyList.count && row - 1 < blockedList.count {
                cellView.textField!.stringValue = "Blocked"
            }
        } else if tableColumn!.identifier == "Control" {

        }
        
        return cellView
    }
}

// MARK: - NSTableViewDelegate
extension ViewController: NSTableViewDelegate {
    
    
}