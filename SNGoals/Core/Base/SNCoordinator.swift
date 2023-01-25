//
//  SNCoordinator.swift
//  Sanada
//
//  Created by Matheus D Sanada on 23/03/22.
//

import UIKit

public protocol SNCoordinator: AnyObject {
    var presenter: UIViewController { get }
    var navigation: UINavigationController? { get }
    var child: SNCoordinator? { get set }
    
    func start()
}

public protocol SNCoordinatorDismissable: AnyObject {
    func dismissing()
}

public extension SNCoordinator {
    var navigation: UINavigationController? {
        let nav = presenter as? UINavigationController
        return nav
    }
}
