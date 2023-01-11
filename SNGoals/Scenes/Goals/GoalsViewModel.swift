//
//  GoalsViewModel.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 06/01/23.
//

import Foundation
import RxSwift
import RxCocoa

enum GoalsStates: SNStateful {
    case success(String)
    case loading(Bool)
    case error(String)
}

class GoalsViewModel: SNViewModel<GoalsStates> {
    let login = PublishSubject<(LoginModel)>()
    var disposeBag = DisposeBag()

    override func configure() {
    }
}

extension GoalsViewModel {
}
