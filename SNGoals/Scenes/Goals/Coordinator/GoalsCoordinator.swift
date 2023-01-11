//
//  TreatmentCoordinator.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import UIKit

class GoalsCoordinator: SNCoordinator {
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
        let viewModel = GoalsViewModel()
        guard let viewController = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(withIdentifier: "Goals") as? GoalsViewController else {
            presenter = UINavigationController()
            return
        }
        viewController.set(viewModel: viewModel)
        
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.tabBarItem.image = UIImage.init(systemName: "cart")
        navigation.tabBarItem.title = "Goals"
        navigation.navigationBar.prefersLargeTitles = true
        viewController.title = "Goals"
        
        self.presenter = navigation
        viewController.delegate = self
    }

    func start() {
    }

    func back() {
        self.navigation?.popViewController(animated: true)
    }
}
extension GoalsCoordinator: GoalsProtocol {
    func pushGoal(from group: GoalsModel) {
        guard let navigation = navigation else { return }
        let coordinator = GoalCoordinator(from: group, navigation: navigation)
        child = coordinator
        child?.start()
    }
    
    func presentCreateNewGoals() {
        let viewModel = CreateGoalsViewModel()
        guard let viewController = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CreateGoals") as? CreateGoalsViewController else {
            presenter = UINavigationController()
            return
        }
        viewController.set(viewModel: viewModel)
        viewController.delegate = self
        if let sheet = viewController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        navigation?.present(viewController, animated: true)
    }
}

extension GoalsCoordinator: CreateGoalsProtocol {
    
}
