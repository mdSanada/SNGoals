//
//  ViewController.swift
//  Sanada
//
//  Created by sanada on 22/03/22.
//

import UIKit

// MARK: - View Controller
open class SNViewController<States: SNStateful, VM: SNViewModel<States>>: UIViewController, SNViewControllerProtocol {
    public typealias States = States
    private(set) public var viewModel: VM?
    
    deinit {
        Sanada.print("Deinitializing: \(self)")
    }
    
    public required init(nib: String) {
        super.init(nibName: nib, bundle: Bundle(for: Self.self))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureViews()
        configureBindings()
        fetch()
    }
    
    internal func set(viewModel: VM) {
        self.viewModel = viewModel
    }
    
    private func configure() {
        self.viewModel?.viewState.bind({ [weak self] state in
            guard let state = state else { return }
            DispatchQueue.main.async {
                self?.render(states: state)
            }
        })
    }
    
    open func render(states: States) {
        fatalError("render() must be overridden in concrete implementations of ViewController")
    }
    
    open func configureViews() {}
    open func configureBindings() {}
    open func fetch() {}
}

extension SNViewController {
    static public func create(with viewModel: VM) -> Self {
        let controller = Self(nib: String(Self.description().split(separator: ".").last ?? ""))
        controller.set(viewModel: viewModel)
        return controller
    }
    
    @discardableResult
    public func inject(viewModel: VM) {
        self.set(viewModel: viewModel)
    }
}
