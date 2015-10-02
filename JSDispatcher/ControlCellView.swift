//
//  ControlCellView.swift
//  JSDispatcher
//
//  Created by Jake Spracher on 10/1/15.
//  Copyright © 2015 Jake Spracher. All rights reserved.
//

import Cocoa

protocol ControlCellViewDelegate {
    func deleteProcess(var process: ManagedProcess)
    func blockProcess(var process: ManagedProcess)
    func readyProcess(process: ManagedProcess)
}

class ControlCellView: NSTableCellView {

    var cellProcess: ManagedProcess!
    var delegate: ControlCellViewDelegate!
    @IBOutlet var segmentedControl: NSSegmentedControl!
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        // Drawing code here.
    }
    
    @IBAction func segmentChanged(segment: NSSegmentedControl) {
        switch segment.selectedSegment {
        case 0:
            delegate.readyProcess(self.cellProcess)
        case 1:
            delegate.blockProcess(self.cellProcess)
        case 2:
            delegate.deleteProcess(self.cellProcess)
        default:
            break
        }
    }
    
}
