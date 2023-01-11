//
//  SettingsCoordinator.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import UIKit

class SettingsCoordinator: SNCoordinator {
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
        let viewController = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(withIdentifier: "Settings") as? SettingsViewController
        let navigation = UINavigationController(rootViewController: viewController!)
        navigation.tabBarItem.image = UIImage.init(systemName: "gear")
        navigation.tabBarItem.title = "Settings"
        navigation.navigationBar.prefersLargeTitles = true
        viewController?.title = "Configurações"
        self.presenter = navigation
        viewController?.delegate = self
    }

    func start() {
    }

    func back() {
        self.navigation?.popViewController(animated: true)
    }
}
extension SettingsCoordinator: SettingsProtocol {
    func signout() {
        parent?.finish()
    }
}
