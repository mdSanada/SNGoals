//
//  Dynamic.swift
//  Sanada
//
//  Created by Matheus D Sanada on 23/03/22.
//

import Foundation

public class SNDynamic<T> {
    public typealias Listener = (T) -> ()
    private var listener: [Listener?] = []
    
    deinit {
        listener = []
        listener.removeAll(keepingCapacity: false)
    }

    public func bind(_ listener: Listener?) {
        self.listener.append(listener)
    }
    
    public func subscribe(_ listener: Listener?) {
        self.listener.append(listener)
        listener?(value)
    }
    
    public func onCompleted() {
        listener = []
        listener.removeAll(keepingCapacity: false)
    }
    
    public func onNext(_ value: T) {
        self.value = value
    }
    
    public var value: T {
        didSet {
            listener.forEach { $0?(value) }
        }
    }
    
    public init(_ v: T) {
        value = v
    }
}
