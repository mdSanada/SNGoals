//
//  GoalViewModel.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 06/01/23.
//

import Foundation
import RxSwift
import RxCocoa

enum GoalStates: SNStateful {
    case success(String)
    case loading(Bool)
    case error(String)
}

class GoalViewModel: SNViewModel<GoalStates> {
    let login = PublishSubject<(LoginModel)>()
    var disposeBag = DisposeBag()

    override func configure() {
    }
}

extension GoalViewModel {
}
