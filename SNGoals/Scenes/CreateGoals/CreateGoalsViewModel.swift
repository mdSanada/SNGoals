//
//  CreateGoalsViewModel.swift
//  SNCreateGoals
//
//  Created by Matheus D Sanada on 06/01/23.
//

import Foundation
import RxSwift
import RxCocoa

enum CreateGoalsStates: SNStateful {
    case success(String)
    case loading(Bool)
    case error(String)
}

class CreateGoalsViewModel: SNViewModel<CreateGoalsStates> {
    let login = PublishSubject<(LoginModel)>()
    var disposeBag = DisposeBag()

    override func configure() {
    }
}

extension CreateGoalsViewModel {
}
