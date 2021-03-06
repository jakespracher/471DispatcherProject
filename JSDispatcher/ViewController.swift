//
//  ViewController.swift
//  JSDispatcher
//
//  Created by Jake Spracher on 9/28/15.
//  Copyright © 2015 Jake Spracher. All rights reserved.
//

import Cocoa

struct ManagedProcess {
    var PID: Int
    var process: Process
    var priority: Int
    
    init(nPID: Int, nProcess: Process, nPriority: Int) {
        PID = nPID
        process = nProcess
        priority = nPriority
    }
}

class ViewController: NSViewController {
    
    @IBOutlet weak var processTableView: NSTableView!
    
    var currentProcess: ManagedProcess!
    var readyList = [Int: ManagedProcess]()
    var blockedList = [Int: ManagedProcess]()
    var tableData = [ManagedProcess]()
    var randomNumber = [Int](0...100)
    var highestPID = 100
    
    @IBOutlet var newProcessPriority: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initializeProcesses()
        
    }
    
    func initializeProcesses() {
        let p1 =  Process()
        let p2 =  Process()
        let p3 =  Process()
        let p4 =  Process()
        let p5 =  Process()
        
        generateRandomPIDs(randomNumber)
        
        // add to ready list and assign priorities
        makeNewProcess(p1)
        makeNewProcess(p2)
        makeNewProcess(p3)
        makeNewProcess(p4)
        
        // choose the first process
        currentProcess = ManagedProcess(nPID: getPID(), nProcess: p5, nPriority: Int(rand() % 50))
        
        refreshTableData()
    }
    
    // MARK: - UI Actions
    
    @IBAction func reset(sender: NSButton) {
        readyList.removeAll()
        blockedList.removeAll()
        currentProcess = nil

        initializeProcesses()
        
    }
    
    @IBAction func killAll(sender: NSButton) {
        readyList.removeAll()
        blockedList.removeAll()
        currentProcess = nil
        refreshTableData()
    }
    
    @IBAction func newProcess(sender: NSButton) {
        let process = Process()
        let newPID = getPID()
        
        readyList[newPID] = ManagedProcess(nPID: newPID, nProcess: process, nPriority: newProcessPriority.integerValue)
        refreshTableData()
        
        newProcessPriority.stringValue = ""
    }
    
    // MARK: - PID Generation
    
    func getPID() -> Int {
        if randomNumber.count == 0 {
            randomNumber = [Int]((highestPID + 1)...(highestPID + 100))
            generateRandomPIDs(randomNumber)
            highestPID += 100
        }
        let num  = randomNumber.popLast()!
        print(num)
        return num
    }
    
    func generateRandomPIDs(seedList: [Int]) -> [Int] {
        return seedList.shuffle()
    }
    
    func refreshTableData() {
        self.tableData.removeAll()
        
        for p1 in readyList {
            tableData.append(p1.1)
        }
        
        for p2 in blockedList {
            tableData.append(p2.1)
        }
        
        processTableView.reloadData()
        
    }
    
    // MARK: - Process Dispatcher
    
    func makeNewProcess(process: Process) {
        let newPID = getPID()
        readyList[newPID] = ManagedProcess(nPID: newPID, nProcess: process, nPriority: Int(rand() % 50))
    }
    
    func contextSwitchNext() {
        if readyList.count > 0 {
            var max = 0
            
            if currentProcess != nil {
                blockedList[currentProcess.PID] = currentProcess
            }
            
            for (PID, currProcess) in readyList {
                if currProcess.priority > max {
                    max = currProcess.priority
                    currentProcess = currProcess
                }
            }
            
            readyList[currentProcess.PID] = nil
            refreshTableData()
            
        } else {
            currentProcess = nil
            
            let myPopup: NSAlert = NSAlert()
            myPopup.messageText = "No Proceses Available to Run"
            myPopup.informativeText = "Move some processes to the ready list"
            myPopup.alertStyle = NSAlertStyle.WarningAlertStyle
            myPopup.addButtonWithTitle("OK")
            myPopup.addButtonWithTitle("Cancel")
            myPopup.runModal()
        }
    }
}

// MARK: - ControlCellViewDelegate
extension ViewController: ControlCellViewDelegate {
    func readyProcess(var process: ManagedProcess) {
        if currentProcess != nil && currentProcess.PID == process.PID {
            contextSwitchNext()
            return
        }
        
        process.priority = Int(rand() % 50)
        readyList[process.PID] = process
        blockedList[process.PID] = nil
        
        if currentProcess == nil {
            contextSwitchNext()
        }
        
        refreshTableData()
    }
    
    func blockProcess(var process: ManagedProcess) {
        if currentProcess != nil && process.PID == currentProcess.PID {
            contextSwitchNext()
        }

        readyList[process.PID] = nil
        process.priority = Int(rand() % 50)
        blockedList[process.PID] = process
        
        refreshTableData()
    }
    
    func deleteProcess(process: ManagedProcess) {
        if process.PID == currentProcess.PID {
                currentProcess = nil
        } else {
            readyList[process.PID] = nil
            blockedList[process.PID] = nil
        }
        
        contextSwitchNext()
        refreshTableData()
    }
}

// MARK: - NSTableViewDataSource
extension ViewController: NSTableViewDataSource {
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        if currentProcess == nil {
            return tableData.count
        } else {
            return tableData.count + 1
        }
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 27
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {

        let cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        if currentProcess != nil {
            if tableColumn!.identifier == "PID" {
                if row == 0 {
                    cellView.textField!.stringValue = String(currentProcess.PID)
                } else {
                    cellView.textField!.stringValue = String(tableData[row - 1].PID)
                }
            } else if tableColumn!.identifier == "Status" {
                if row == 0 {
                    cellView.textField!.stringValue = "Current Process"
                } else if row <= readyList.count {
                    cellView.textField!.stringValue = "Ready"
                } else if row > readyList.count {
                    cellView.textField!.stringValue = "Blocked"
                }
            } else if tableColumn!.identifier == "Priority" {
                if row == 0 {
                    cellView.textField!.stringValue = "N/A"
                } else if row <= readyList.count {
                    cellView.textField!.stringValue = String(tableData[row - 1].priority)
                } else if row > readyList.count {
                    cellView.textField!.stringValue = "-1"
                }
                
            } else if tableColumn!.identifier == "Control" {
                let controlCellView: ControlCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! ControlCellView
                controlCellView.delegate = self
                if row == 0 {
                    controlCellView.cellProcess = currentProcess
                    controlCellView.segmentedControl.selectedSegment = -1
                } else if row <= readyList.count {
                    controlCellView.segmentedControl.selectedSegment = 0
                    controlCellView.cellProcess = tableData[row - 1]
                } else if row > readyList.count {
                    controlCellView.segmentedControl.selectedSegment = 1
                    controlCellView.cellProcess = tableData[row - 1]
                }
                
                return controlCellView
            }
        } else {
            if tableColumn!.identifier == "PID" {
                cellView.textField!.stringValue = String(tableData[row].PID)
            } else if tableColumn!.identifier == "Status" {
                if row < readyList.count {
                    cellView.textField!.stringValue = "Ready"
                } else if row >= readyList.count {
                    cellView.textField!.stringValue = "Blocked"
                }
            } else if tableColumn!.identifier == "Priority" {
                if row < readyList.count {
                    cellView.textField!.stringValue = String(tableData[row].priority)
                } else if row >= readyList.count {
                    cellView.textField!.stringValue = "-1"
                }
            } else if tableColumn!.identifier == "Control" {
                let controlCellView: ControlCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! ControlCellView
                controlCellView.delegate = self
                if row < readyList.count {
                    controlCellView.segmentedControl.selectedSegment = 0
                    controlCellView.cellProcess = tableData[row]
                } else if row >= readyList.count {
                    controlCellView.segmentedControl.selectedSegment = 1
                    controlCellView.cellProcess = tableData[row]
                }
                
                return controlCellView
            }
        }
        
        return cellView
    }
}

// MARK: - NSTableViewDelegate
extension ViewController: NSTableViewDelegate {
    
    
}

// MARK: - Fisher Yates Shuffling

extension CollectionType where Index == Int {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}
