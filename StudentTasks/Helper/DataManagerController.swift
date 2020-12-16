//
//  DataManagerController.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/16/20.
//

import Foundation

class DataManagerController {
    static let sharedInstance = DataManagerController() // Static unimmutable variable which has instance of this class
    
    private init() { } // Private constructor (this class cannot be initlized from the outside)
    
    // TODO: Load and parse courses along with tasks
    // TODO: Keep and save data through this class
    // TODO: Implement observer pattern for other controllers to subscribe
}
