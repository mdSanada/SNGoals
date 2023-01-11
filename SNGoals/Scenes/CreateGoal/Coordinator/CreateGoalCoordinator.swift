//
//  TreatmentCoordinator.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import UIKit

class CreateGoalCoordinator: SNCoordinator {
    var parent: MainCoordinator?
    var presenter: UIViewController
    var child: SNCoordinator?
        
    lazy var storyboard: UIStoryboard = {
        return .init(name: "MainStoryboard", bundle: nil)
    }()
    
    deinit {
        Sanada.print("Deinitializing \(self)")
    }

    init() {
        let viewModel = CreateGoalViewModel()
        guard let viewController = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CreateGoal") as? CreateGoalViewController else {
            presenter = UINavigationController()
            return
        }
        viewController.set(viewModel: viewModel)
        
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.tabBarItem.image = UIImage.init(systemName: "cart")
        navigation.tabBarItem.title = "CreateGoal"
        navigation.navigationBar.prefersLargeTitles = true
        viewController.title = "CreateGoal"
        
        self.presenter = navigation
        viewController.delegate = self
    }

    func start() {
    }

    func back() {
        self.navigation?.popViewController(animated: true)
    }
}
extension CreateGoalCoordinator: CreateGoalProtocol {
}
