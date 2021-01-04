//
//  Debounce.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/23/20.
//

import Foundation
import Dispatch

/**
 Source: https://stackoverflow.com/a/40634366/1738413
 Author: d4Rk
*/
typealias Debounce<T> = (_ : T) -> Void

func debounce<T>(interval: Int, queue: DispatchQueue, action: @escaping Debounce<T>) -> Debounce<T> {
    var lastFireTime = DispatchTime.now()
    let dispatchDelay = DispatchTimeInterval.milliseconds(interval)

    return { param in
        lastFireTime = DispatchTime.now()
        let dispatchTime: DispatchTime = DispatchTime.now() + dispatchDelay

        queue.asyncAfter(deadline: dispatchTime) {
            let when: DispatchTime = lastFireTime + dispatchDelay
            let now = DispatchTime.now()

            if now.rawValue >= when.rawValue {
                action(param)
            }
        }
    }
}

func debounce(interval: Int, queue: DispatchQueue, action: @escaping (() -> Void)) -> () -> Void {
    var lastFireTime = DispatchTime.now()
    let dispatchDelay = DispatchTimeInterval.milliseconds(interval)

    return {
        lastFireTime = DispatchTime.now()
        let dispatchTime: DispatchTime = DispatchTime.now() + dispatchDelay

        queue.asyncAfter(deadline: dispatchTime) {
            let when: DispatchTime = lastFireTime + dispatchDelay
            let now = DispatchTime.now()
            if now.rawValue >= when.rawValue {
                action()
            }
        }
    }
}

