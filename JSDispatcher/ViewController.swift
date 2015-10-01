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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
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
        
        if tableColumn!.identifier == "" {


        }
        
        return cellView
    }
}

// MARK: - NSTableViewDelegate
extension ViewController: NSTableViewDelegate {
    
    
}