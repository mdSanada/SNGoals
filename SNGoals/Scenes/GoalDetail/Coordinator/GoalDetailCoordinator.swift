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
    var presentNavigation: UINavigationController?
    weak var dismissable: SNCoordinatorDismissable?

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
        
        if let tintColor = group.color {
            navigation?.navigationBar.tintColor = UIColor.fromHex(tintColor)
        }
        
        viewController.modalPresentationStyle = .overCurrentContext
        
        if let sheet = viewController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        
        presentNavigation = UINavigationController(rootViewController: viewController)
        guard let presentNavigation = presentNavigation else { return }
        navigation?.present(presentNavigation, animated: true)
    }

    func back() {
        self.navigation?.popViewController(animated: true)
    }
}
extension GoalDetailCoordinator: GoalDetailProtocol {
    func dismiss() {
        navigation?.dismiss(animated: true, completion: { [weak self] in
            self?.dismissable?.dismissing()
        })
    }
    
    func edit() {
        guard let navigation = presentNavigation, let uuid = group.uuid else { return }
        let coordinator = CreateGoalCoordinator(group: group,
                                                action: .edit(uuid: uuid),
                                                navigation: navigation)
        child = coordinator
        coordinator.present(animated: true)
    }
    
    
    func clear() {
        dismissable?.dismissing()
    }
}
