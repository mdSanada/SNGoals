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
    let repository = GoalsRepository()
    let request = PublishSubject<Void>()
    var disposeBag = DisposeBag()

    override func configure() {
        request
            .subscribe(onNext: { [weak self] _ in
                self?.emit(.loading(true))
                self?.repository.getCollection { loading in
                    self?.emit(.loading(loading))
                } onSuccess: { goals in
                    self?.emit(.success(""))
                } onError: { error in
                    self?.emit(.error(""))
                }
            })
            .disposed(by: disposeBag)
    }
}

extension GoalsViewModel {
}
