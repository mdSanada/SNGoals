//
//  CreateGoalViewModel.swift
//  SNCreateGoal
//
//  Created by Matheus D Sanada on 06/01/23.
//

import Foundation
import RxSwift
import RxCocoa

enum CreateGoalStates: SNStateful {
    case success(String)
    case loading(Bool)
    case error(String)
}

class CreateGoalViewModel: SNViewModel<CreateGoalStates> {
    let login = PublishSubject<(LoginModel)>()
    var disposeBag = DisposeBag()

    override func configure() {
    }
}

extension CreateGoalViewModel {
}
