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
    case goals([GoalsModel])
    case refresh([GoalsModel])
    case loading(Bool)
    case error(String)
}

class GoalsViewModel: SNViewModel<GoalsStates> {
    let repository = GoalsRepository()
    let refresh = PublishSubject<Void>()
    var disposeBag = DisposeBag()
    
    deinit {
        Sanada.print("Deinitializing: \(self)")
        viewState.onCompleted()
    }

    override func configure() {
        configureListeners()
        
        refresh
            .subscribe(onNext: { [weak self] _ in
                self?.getGoals()
            })
            .disposed(by: disposeBag)
    }
}

extension GoalsViewModel {
    fileprivate func getGoals() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.repository.getCollection { [weak self] loading in
                self?.emit(.loading(loading))
            } onSuccess: { [weak self] goals in
                self?.emit(.refresh(goals))
            } onError: { [weak self] error in
                self?.emit(.error("Algo inesperado aconteceu!"))
            }
        }
    }
    
    fileprivate func configureListeners() {
        repository.collectionAddSnapshop { [weak self] loading in
            Sanada.print("Loading from Snapsot: \(loading)")
        } onSuccess: { [weak self] goals in
            self?.emit(.goals(goals))
        } onError: { [weak self] error in
            self?.emit(.error("Algo inesperado aconteceu!"))
        }
    }
}
