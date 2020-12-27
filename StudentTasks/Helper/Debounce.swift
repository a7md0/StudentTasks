//
//  Debounce.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/23/20.
//

import Foundation
import Dispatch

/**
 https://stackoverflow.com/a/59296478/1738413
*/
class Debounce<T: Equatable> {

    private init() {}

    static func input(_ input: T,
                      comparedAgainst current: @escaping @autoclosure () -> (T),
                      perform: @escaping (T) -> ()) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            if input == current() { perform(input) }
        }
    }
}
