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
extension GoalsCoordinator: GoalsProtocol, SNCoordinatorDismissable {
    func pushGoal(from group: GoalsModel) {
        guard let navigation = navigation else { return }
        let coordinator = GoalCoordinator(from: group, navigation: navigation)
        child = coordinator
        child?.start()
    }
    
    func presentCreateNewGoals() {
        guard let navigation = navigation else { return }
        let coordinator = CreateGoalsCoordinator(type: .create, navigation: navigation)
        coordinator.dismissable = self
        child = coordinator
        child?.start()
    }
    
    func presentEditGoal(goal: GoalsModel) {
        guard let navigation = navigation, let uuid = goal.uuid else { return }
        let coordinator = CreateGoalsCoordinator(type: .edit(uuid: uuid),
                                                             navigation: navigation,
                                                             goals: goal)
        coordinator.dismissable = self
        child = coordinator
        child?.start()
    }
    
    func dismissing() {
        child = nil
    }
}
