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
    case success
    case loading(Bool)
    case error(String)
}

class CreateGoalViewModel: SNViewModel<CreateGoalStates> {
    let repository = GoalRepository()
    let groupUUID = PublishSubject<FirestoreId>()
    let save = PublishSubject<(action: CreateActions, data: [CreateModel])>()
    var disposeBag = DisposeBag()

    override func configure() {
        save
            .withLatestFrom(groupUUID, resultSelector: {(groupUUID: $1, data: $0)})
            .subscribe(onNext: { [weak self] result in
                self?.saveRequest(at: result.groupUUID,
                                  action: result.data.action,
                                  data: result.data.data)
            })
            .disposed(by: disposeBag)
    }
}

extension CreateGoalViewModel {
    private func createRequest(data: [CreateModel]) -> CreateGoalRequest {
        var result = CreateGoalRequest(name: nil,
                                       type: nil,
                                       value: 0,
                                       goal: nil,
                                       iconGroup: nil,
                                       icon: nil)
        data.forEach { goal in
            switch goal.type {
            case .text(let text):
                switch text.id.uppercased() {
                case "NAME":
                    result.name = text.text
                case "VALUE":
                    switch text.type {
                    case .text, .percent:
                        break
                    case .currency:
                        result.goal = (text.text?.currency ?? 0)
                    case .number:
                        result.goal = (text.text?.number ?? 0)
                    }
                default:
                    break
                }
            case .icon(let icon):
                let selectedGroup = icon.first(where: { $0.isSelected })
                result.iconGroup = selectedGroup?.group
                result.icon = selectedGroup?.icons.first(where: { $0.isSelected })?.icon
            case .segmented(let segmented):
                result.type = segmented.segment?.id.rawValue
            case .color:
                break
            case .date:
                break
            }
        }
        
        return result
    }
    
    fileprivate func saveRequest(at uuid: FirestoreId, action: CreateActions, data: [CreateModel]) {
        emit(.loading(true))
        switch action {
        case .create:
            repository.save(at: uuid,
                            goal: createRequest(data: data)) { [weak self] loading in
                self?.emit(.loading(loading))
            } onSuccess: { [weak self] goals in
                self?.emit(.success)
            } onError: { [weak self] error in
                self?.emit(.error("Algo inesperado aconteceu!"))
            }
        case .edit(let uuid):
            repository.edit(at: uuid,
                            goal: createRequest(data: data), with: uuid) { [weak self] loading in
                self?.emit(.loading(loading))
            } onSuccess: { [weak self] goals in
                self?.emit(.success)
                SNNotificationCenter.post(notification: SNNotificationCenter.didChangeGoals.notification,
                                          arguments: ["goals": goals])
            } onError: { [weak self] error in
                self?.emit(.error("Algo inesperado aconteceu!"))
            }
        }
    }
}
