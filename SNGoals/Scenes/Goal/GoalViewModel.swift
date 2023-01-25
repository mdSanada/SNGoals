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
    case goals([GoalModel])
    case refresh([GoalModel])
    case delete
    case deleteLoading(Bool)
    case loading(Bool)
    case error(String)
}

class GoalViewModel: SNViewModel<GoalStates> {
    let goalsRepository = GoalsRepository()
    let goalRepository = GoalRepository()
    let uuid = PublishSubject<FirestoreId>()
    let refresh = PublishSubject<Void>()
    let delete = PublishSubject<FirestoreId>()
    var disposeBag = DisposeBag()

    override func configure() {
        uuid.subscribe(onNext: { [weak self] uuid in
            self?.configureListeners(uuid: uuid)
        })
        .disposed(by: disposeBag)
        
        refresh
            .withLatestFrom(uuid)
            .subscribe(onNext: { [weak self] uuid in
                self?.getGoal(uuid: uuid)
            })
            .disposed(by: disposeBag)
        
        delete
            .subscribe(onNext: { [weak self] uuid in
                self?.deleteGoal(with: uuid)
            })
            .disposed(by: disposeBag)
    }
}

extension GoalViewModel {
    fileprivate func deleteGoal(with uuid: FirestoreId) {
        goalsRepository.delete(with: uuid) { [weak self] loading in
            self?.emit(.deleteLoading(loading))
        } onSuccess: { [weak self] in
            self?.emit(.delete)
        } onError: { [weak self] error in
            self?.emit(.error("Algo inesperado aconteceu!"))
        }
    }

    
    fileprivate func getGoal(uuid: FirestoreId) {
        goalRepository.getCollection(at: uuid) { [weak self] loading in
            self?.emit(.loading(loading))
        } onSuccess: { [weak self] goal in
            self?.emit(.refresh(goal))
        } onError: { [weak self] error in
            self?.emit(.error("Algo inesperado aconteceu!"))
        }
    }
    
    fileprivate func configureListeners(uuid: FirestoreId) {
        goalRepository.collectionAddSnapshop(at: uuid) { [weak self] loading in
            Sanada.print("Loading from Snapsot at \(uuid): \(loading)")
        } onSuccess: { [weak self] goal in
            self?.emit(.goals(goal))
        } onError: { [weak self] error in
            self?.emit(.error("Algo inesperado aconteceu!"))
        }
    }
}
