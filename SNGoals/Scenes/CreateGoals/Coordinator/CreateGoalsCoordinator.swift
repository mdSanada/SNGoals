//
//  TreatmentCoordinator.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import UIKit

class CreateGoalsCoordinator: SNCoordinator {
    var parent: MainCoordinator?
    var presenter: UIViewController
    var child: SNCoordinator?
    var actions: CreateActions
    var goals: GoalsModel?
        
    lazy var storyboard: UIStoryboard = {
        return .init(name: "MainStoryboard", bundle: nil)
    }()
    
    deinit {
        Sanada.print("Deinitializing \(self)")
    }

    init(type: CreateActions, navigation: UINavigationController, goals: GoalsModel? = nil) {
        self.actions = type
        self.presenter = navigation
        self.goals = goals
    }

    func start() {
        let viewModel = CreateGoalsViewModel()
        guard let viewController = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CreateGoals") as? CreateGoalsViewController else {
            presenter = UINavigationController()
            return
        }
        viewController.set(viewModel: viewModel)
        viewController.delegate = self
        viewController.title = "Criar novo grupo"
        viewController.goals = goals
        viewController.actions = actions
        if let sheet = viewController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }

        navigation?.present(viewController, animated: true)
    }

    func back() {
        self.navigation?.popViewController(animated: true)
    }
}
extension CreateGoalsCoordinator: CreateGoalsProtocol {
    func dismiss() {
        navigation?.dismiss(animated: true)
    }
}
