//
//  AppLauncher.swift
//  Sanada
//
//  Created by Matheus D Sanada on 10/09/22.
//

import Foundation
import SnapKit

final class AppLauncher: Launcher {
    var window: UIWindow?
    private var child: SNCoordinator?
    
    private var viewController: UIViewController? {
        return child?.navigation?.topViewController
    }

    init() {
    }
        
    private func runOnMainThread(block: () -> Void) {
        if Thread.isMainThread {
            block()
        } else { 
            DispatchQueue.main.sync { [weak self] in
                block()
            }
        }
    }
        
    private func finishApp() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        sleep(1)
        exit(0)
    }

    func launch(window: UIWindow) {
        self.window = window
        startFromMainThread()
    }
    
    func startFromMainThread() {
        if Thread.isMainThread {
            self.startMain()
        } else {
            DispatchQueue.main.async {
                self.startMain()
            }
        }
    }
        
    func startMain(showTransition: Bool = false) {
//        let coordinator = LoginCoordinator(with: .init())
//        self.window?.rootViewController = coordinator.presenter
//        self.window?.makeKeyAndVisible()
//        child = coordinator
//        child?.start()
    }
}
