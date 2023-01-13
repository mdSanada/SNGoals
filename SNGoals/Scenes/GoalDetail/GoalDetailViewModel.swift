//
//  GoalDetailViewModel.swift
//  SNGoalDetails
//
//  Created by Matheus D Sanada on 06/01/23.
//

import Foundation
import RxSwift
import RxCocoa

enum GoalDetailStates: SNStateful {
    case success(String)
    case loading(Bool)
    case error(String)
}

class GoalDetailViewModel: SNViewModel<GoalDetailStates> {
    var disposeBag = DisposeBag()

    override func configure() {
    }
}

extension GoalDetailViewModel {
}
