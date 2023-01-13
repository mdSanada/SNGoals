//
//  Extension + UINavigationController.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 11/01/23.
//

import UIKit

extension UINavigationController {
    func pushWithHiddenBar(_ viewController: UIViewController) {
        setNavigationBarHidden(true, animated: false)
        pushViewController(viewController, animated: true)
    }

    func pushFromLeft(_ viewController: UIViewController, hiddenNavBar: Bool = true) {
        guard let window = view.window else { return }
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .default)
        window.layer.add(transition, forKey: kCATransition)
        setNavigationBarHidden(hiddenNavBar, animated: false)
        pushViewController(viewController, animated: false)
    }

    func pushFromRight(_ viewController: UIViewController, hiddenNavBar: Bool = true) {
        guard let window = view.window else { return }
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: .default)
        window.layer.add(transition, forKey: kCATransition)
        setNavigationBarHidden(hiddenNavBar, animated: false)
        pushViewController(viewController, animated: false)
    }

    func popToLeft() {
        guard let window = view.window else { return }
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: .default)
        window.layer.add(transition, forKey: kCATransition)
        popViewController(animated: false)
    }
    
    func popToRight() {
        guard let window = view.window else { return }
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .default)
        window.layer.add(transition, forKey: kCATransition)
        popViewController(animated: false)
    }
    
    func pushFromBottom(_ viewController: UIViewController, hiddenNavBar: Bool = true) {
        guard let window = view.window else { return }
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
        window.layer.add(transition, forKey: kCATransition)
        setNavigationBarHidden(hiddenNavBar, animated: false)
        pushViewController(viewController, animated: false)
    }
    
    func popToBottom() {
        guard let window = view.window else { return }
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
        window.layer.add(transition, forKey: kCATransition)
        popViewController(animated: false)
    }
    
    func popToRootBottom() {
        guard let window = view.window else { return }
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
        window.layer.add(transition, forKey: kCATransition)
        popToRootViewController(animated: false)
    }
    
    func dismissToBottom(_ completion: @escaping (() -> Void)) {
        guard let window = view.window else { return }
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
        window.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: completion)
    }
}

extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
}
