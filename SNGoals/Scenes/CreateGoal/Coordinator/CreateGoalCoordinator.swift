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
    var group: GoalsModel
        
    lazy var storyboard: UIStoryboard = {
        return .init(name: "MainStoryboard", bundle: nil)
    }()
    
    deinit {
        Sanada.print("Deinitializing \(self)")
    }

    init(group model: GoalsModel, navigation: UINavigationController) {
        self.group = model
        self.presenter = navigation
    }

    func start() {
        let viewModel = CreateGoalViewModel()
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "CreateGoal") as? CreateGoalViewController else {
            return
        }
        viewController.set(viewModel: viewModel)
        
        viewController.group = group
        viewController.delegate = self
        navigation?.present(viewController, animated: true)
    }

    func back() {
        self.navigation?.popViewController(animated: true)
    }
}
extension CreateGoalCoordinator: CreateGoalProtocol {
    func dismiss() {
        navigation?.dismiss(animated: true)
    }
}
