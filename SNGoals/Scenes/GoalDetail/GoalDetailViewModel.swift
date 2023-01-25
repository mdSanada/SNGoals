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
    case success
    case didChangeStepValue(Double)
    case didChangeTextValue(String)
    case didChangeProgress(Double)
    case loading(Bool)
    case error(String)
}

class GoalDetailViewModel: SNViewModel<GoalDetailStates> {
    let save = PublishSubject<(uuid: FirestoreId, group: GoalsModel, value: Double)>()
    let didChangeTextValue = PublishSubject<Double?>()
    let didChangeStepper = PublishSubject<Double?>()
    let goalType = PublishSubject<GoalType?>()
    let goal = PublishSubject<GoalModel?>()
    var disposeBag = DisposeBag()
    let delete = PublishSubject<FirestoreId>()


    override func configure() {
        save
            .subscribe(onNext: { [weak self] (value) in
                self?.saveRequest(uuid: value.uuid,
                                  group: value.group,
                                  value: value.value)
            })
            .disposed(by: disposeBag)
        
        didChangeTextValue
            .filter { ($0 ?? 0) > 0 }
            .subscribe(onNext: { [weak self] number in
                self?.emit(.didChangeStepValue(number ?? 1))
            })
            .disposed(by: disposeBag)
        
        didChangeStepper
            .withLatestFrom(goalType, resultSelector: {(stepper: $0, type: $1)})
            .compactMap { (value, type) in
                var result: String? = nil
                switch type {
                case .number:
                    let number = (value)?.asString(digits: 2, minimum: 0)
                    result = number
                case .money:
                    let currency = (value)?.asMoney(digits: 2, minimum: 2)
                    result = currency
                case .none:
                    return nil
                }
                return result
            }
            .subscribe(onNext: { [weak self] value in
                self?.emit(.didChangeTextValue(value))
            })
            .disposed(by: disposeBag)
        
        didChangeStepper
            .withLatestFrom(goal, resultSelector: {(value: $0, goal: $1)})
            .map { result in
                switch result.goal?.type {
                case .money:
                    return (result.value ?? 0) / (result.goal?.goal ?? 0)
                case .number:
                    return (result.value ?? 0) / (result.goal?.goal ?? 0).rounded(.down)
                case .none:
                    return .greatestFiniteMagnitude
                }
            }
            .subscribe(onNext: { [weak self] value in
                self?.emit(.didChangeProgress(value))
            })
            .disposed(by: disposeBag)
    }
}

extension GoalDetailViewModel {
    fileprivate func saveRequest(uuid: FirestoreId, group: GoalsModel, value: Double) {
        emit(.loading(true))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.emit(.loading(false))
            self?.emit(.success)
        }
    }

}
