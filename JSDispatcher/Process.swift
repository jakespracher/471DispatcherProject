//
//  Process.swift
//  JSDispatcher
//
//  Created by Jake Spracher on 10/1/15.
//  Copyright © 2015 Jake Spracher. All rights reserved.
//

import Cocoa

class Process: NSObject {
    // process control block
    var processNumber: Int!
    var programCounter: Int!
    var registers: [Int] = []
    
}
