//
//  BaseViewModel.swift
//  Sanada
//
//  Created by sanada on 22/03/22.
//
//
import Foundation

// MARK: - View Model

open class SNViewModel<States: SNStateful>: SNViewModelProtocol {
    public typealias States = States
    private var states: States? {
        didSet {
            viewState.value = states!
        }
    }
    
    var viewState: SNDynamic<States?> = SNDynamic(.none)
    
    deinit {
        Sanada.print("Deinitializing: \(self)")
        viewState.onCompleted()
        states = nil
    }
    
    public init() {
        configure()
    }
    
    public func emit(_ state: States) {
        states = state
    }
    
    open func configure() {
        fatalError("configure() must be overridden in concrete implementations of ViewModel")
    }
}
