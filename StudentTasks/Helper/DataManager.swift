//
//  DataManager.swift
//  StudentCourses
//
//  Created by Ahmed Naser on 12/16/20.
//

import Foundation

class DataManager {
    static let sharedInstance = DataManager() // Static unimmutable variable which has instance of this class
    
    private var dataLoaded: Bool = false
    
    private init() { // Private constructor (this class cannot be initlized from the outside)
    }
    
    func loadData() {
        Course.loadData()
        // ... load any other data
        
        dataLoaded = true
    }
    
    func saveData() {
        guard dataLoaded == true else { return }
        
        Course.saveData()
        // ... save any other data
    }
    
    // TODO: Implement observer pattern for other controllers to subscribe
}
