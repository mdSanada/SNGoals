//
//  TreatmentCoordinator.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import UIKit

class GoalCoordinator: SNCoordinator {
    var parent: MainCoordinator?
    var presenter: UIViewController
    var child: SNCoordinator?
    var groupGoals: GoalsModel?
        
    lazy var storyboard: UIStoryboard = {
        return .init(name: "MainStoryboard", bundle: nil)
    }()
    
    deinit {
        Sanada.print("Deinitializing \(self)")
    }

    init(from group: GoalsModel, navigation: UINavigationController) {
        self.presenter = navigation
        self.groupGoals = group
    }

    func start() {
        let viewModel = GoalViewModel()
        guard let viewController = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(withIdentifier: "Goal") as? GoalViewController else {
            presenter = UINavigationController()
            return
        }
        viewController.group = groupGoals
        viewController.set(viewModel: viewModel)
        viewController.delegate = self
        if let tintColor = groupGoals?.color {
            navigation?.navigationBar.tintColor = UIColor.fromHex(tintColor)
        }
        navigation?.pushViewController(viewController, animated: true)
    }

    func back() {
        self.child = nil
        self.navigation?.popViewController(animated: true)
    }
}
extension GoalCoordinator: GoalProtocol, SNCoordinatorDismissable {
    func addGoal() {
        guard let groupGoals = groupGoals, let navigation = navigation else { return }
        let coordinator = CreateGoalCoordinator(group: groupGoals, action: .create, navigation: navigation)
        coordinator.dismissable = self
        child = coordinator
        child?.start()
    }
    
    func presentEditGroup() {
        guard let navigation = navigation, let uuid = groupGoals?.uuid else { return }
        let coordinator = CreateGoalsCoordinator(type: .edit(uuid: uuid), navigation: navigation, goals: groupGoals)
        coordinator.dismissable = self
        child = coordinator
        child?.start()
    }
    
    func detail(goal: GoalModel) {
        guard let navigation = navigation, let groupGoals = groupGoals else { return }
        let coordinator = GoalDetailCoordinator(group: groupGoals,
                                                goal: goal,
                                                action: .create,
                                                navigation: navigation)
        coordinator.dismissable = self
        child = coordinator
        child?.start()
    }
    
    func didChangeGoals(_ goals: GoalsModel) {
        self.groupGoals = goals
        if let tintColor = groupGoals?.color {
            navigation?.navigationBar.tintColor = UIColor.fromHex(tintColor)
        }
    }
    
    func dismissing() {
        child = nil
    }
}
