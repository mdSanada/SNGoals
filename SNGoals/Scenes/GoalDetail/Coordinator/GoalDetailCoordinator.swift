//
//  TreatmentCoordinator.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import UIKit

class GoalDetailCoordinator: SNCoordinator {
    var parent: MainCoordinator?
    var presenter: UIViewController
    var child: SNCoordinator?
    var group: GoalsModel
    var goal: GoalModel
    var actions: CreateActions
    
    lazy var storyboard: UIStoryboard = {
        return .init(name: "MainStoryboard", bundle: nil)
    }()
    
    deinit {
        Sanada.print("Deinitializing \(self)")
    }

    init(group model: GoalsModel, goal: GoalModel, action: CreateActions, navigation: UINavigationController) {
        self.group = model
        self.goal = goal
        self.presenter = navigation
        self.actions = action
    }

    func start() {
        let viewModel = GoalDetailViewModel()
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "GoalDetail") as? GoalDetailViewController else {
            return
        }
        viewController.set(viewModel: viewModel)
        
        viewController.group = group
        viewController.goal = goal
        viewController.action = actions
        viewController.delegate = self
        
        if let sheet = viewController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        
        navigation?.present(viewController, animated: true)
    }

    func back() {
        self.navigation?.popViewController(animated: true)
    }
}
extension GoalDetailCoordinator: GoalDetailProtocol {
    func dismiss() {
        navigation?.dismiss(animated: true)
    }
}