//
//  DataManagerController.swift
//  StudentCourses
//
//  Created by Ahmed Naser on 12/16/20.
//

import Foundation

class DataManagerController {
    static let sharedInstance = DataManagerController() // Static unimmutable variable which has instance of this class
    
    private init() { // Private constructor (this class cannot be initlized from the outside)
    }
    
    func loadData() {
        Course.loadData()
        // ... load any other data
    }
    
    func saveData() {
        Course.saveData()
        // ... save any other data
    }
    
    // TODO: Implement observer pattern for other controllers to subscribe
}
