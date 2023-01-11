//
//  MyReceiptCoordinator.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 10/09/22.
//

import UIKit
class LoginCoordinator: SNCoordinator {
    var presenter: UIViewController
    var child: SNCoordinator?
        
    lazy var storyboard: UIStoryboard = {
        return .init(name: "Login", bundle: nil)
    }()
    
    deinit {
        Sanada.print("Deinitializing \(self)")
    }

    init(with navigation: UINavigationController) {
        self.presenter = navigation
    }

    func start() {
        let viewModel = LoginViewModel()
        guard let viewController = storyboard.instantiateInitialViewController() as? LoginViewController else { return }
        viewController.set(viewModel: viewModel)
        viewController.delegate = self
        navigation?.pushViewController(viewController, animated: true)
    }
    
    static func restartStack(navigation: UINavigationController = .init() ) {
        let viewModel = LoginViewModel()
        guard let viewController = UIStoryboard(name: "Login",
                                                bundle: nil)
            .instantiateInitialViewController() as? LoginViewController else { return }
        viewController.set(viewModel: viewModel)
        
        let coordinator = LoginCoordinator(with: navigation)
        
        viewController.delegate = coordinator
        UIApplication.shared.keyWindow?.rootViewController = coordinator.presenter
        
        navigation.setNavigationBarHidden(true, animated: false)
        navigation.pushViewController(viewController, animated: false)
    }

    
    func back() {
        self.navigation?.popViewController(animated: true)
    }
}

extension LoginCoordinator: LoginDelegate {
    func pushHome() {
        MainCoordinator.restartStack()
    }
}
