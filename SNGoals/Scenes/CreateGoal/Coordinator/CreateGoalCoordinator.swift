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
    var actions: CreateActions
    weak var dismissable: SNCoordinatorDismissable?
    var presentNavigation: UINavigationController?

    lazy var storyboard: UIStoryboard = {
        return .init(name: "MainStoryboard", bundle: nil)
    }()
    
    deinit {
        Sanada.print("Deinitializing \(self)")
    }

    init(group model: GoalsModel, action: CreateActions, navigation: UINavigationController) {
        self.group = model
        self.presenter = navigation
        self.actions = action
    }

    func start() {
        let viewModel = CreateGoalViewModel()
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "CreateGoal") as? CreateGoalViewController else {
            return
        }
        viewController.set(viewModel: viewModel)
        
        viewController.group = group
        viewController.delegate = self
        viewController.title = "Criar nova meta"
        viewController.actions = actions
        
        if let sheet = viewController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        
        presentNavigation = UINavigationController(rootViewController: viewController)
        guard let presentNavigation = presentNavigation else { return }
        navigation?.present(presentNavigation, animated: true)
    }
    
    func present(animated: Bool) {
        let viewModel = CreateGoalViewModel()
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "CreateGoal") as? CreateGoalViewController else {
            return
        }
        viewController.set(viewModel: viewModel)
        
        viewController.group = group
        viewController.delegate = self
        viewController.title = "Criar nova meta"
        viewController.actions = actions
        
        viewController.modalPresentationStyle = .overCurrentContext
        if let sheet = viewController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        
        navigation?.present(viewController, animated: animated)
    }

    func back() {
        self.navigation?.popViewController(animated: true)
    }
}
extension CreateGoalCoordinator: CreateGoalProtocol {
    func dismiss() {
        navigation?.dismiss(animated: true, completion: { [weak self] in
            self?.dismissable?.dismissing()
        })
    }
    
    func clear() {
        dismissable?.dismissing()
    }
}
