//
//  Observer.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/23/20.
//

import Foundation

class Subject<T> {
    /// @var array List of subscribers. In real life, the list of subscribers
    /// can be stored more comprehensively (categorized by event type, etc.).
    private lazy var observers = [Observer<T>]()

    /// The subscription management methods.
    func attach(_ observer: Observer<T>) {
        print("Subject: Attached an observer.\n")
        observers.append(observer)
    }

    func detach(_ observer: Observer<T>) {
        if let idx = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: idx)
            print("Subject: Detached an observer.\n")
        }
    }

    /// Trigger an update in each subscriber.
    func notify(value: T) {
        print("Subject: Notifying observers...\n")
        observers.forEach({
            $0.update(value: value)
        })
    }
}

class Observer<T> {
    let subject: Subject<T>
    
    var updateDelgate: ((T)->Void)?
    
    init(subject: Subject<T>) {
        self.subject = subject
    }
    
    func update(value: T) {
        updateDelgate?(value)
    }
    
    func unsubscribe() {
        self.subject.detach(self)
    }
}
