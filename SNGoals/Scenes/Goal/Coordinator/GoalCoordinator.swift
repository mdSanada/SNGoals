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
        viewController.title = groupGoals?.name ?? ""
        viewController.color = groupGoals?.color ?? ""
        viewController.set(viewModel: viewModel)
        viewController.delegate = self
        if let tintColor = groupGoals?.color {
            navigation?.navigationBar.tintColor = UIColor.fromHex(tintColor)
        }
        navigation?.pushViewController(viewController, animated: true)
    }

    func back() {
        self.navigation?.popViewController(animated: true)
    }
}
extension GoalCoordinator: GoalProtocol {
    func addGoal() {
        guard let groupGoals = groupGoals, let navigation = navigation else { return }
        let coordinator = CreateGoalCoordinator(group: groupGoals, navigation: navigation)
        child = coordinator
        child?.start()
    }
    
    func pushDetailed() {
    }
}
