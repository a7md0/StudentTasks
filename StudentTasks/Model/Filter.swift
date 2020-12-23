//
//  Search.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/23/20.
//

import Foundation

class Filter {
    var searchQuery: String?
    var filters: [String:Any]
    
    convenience init() {
        self.init(searchQuery: nil, filters: [:])
    }
    
    convenience init(searchQuery: String) {
        self.init(searchQuery: searchQuery, filters: [:])
    }
    
    init(searchQuery: String?, filters: [String:Any]) {
        self.searchQuery = searchQuery
        self.filters = filters
    }
}
