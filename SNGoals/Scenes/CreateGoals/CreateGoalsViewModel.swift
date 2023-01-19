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
    case success
    case loading(Bool)
    case error(String)
}

class CreateGoalsViewModel: SNViewModel<CreateGoalsStates> {
    let repository = GoalsRepository()
    let save = PublishSubject<(action: CreateActions, data: [CreateModel])>()
    var disposeBag = DisposeBag()

    override func configure() {
        save
            .subscribe(onNext: { [weak self] (action, data) in
                self?.saveRequest(action: action, data: data)
            })
            .disposed(by: disposeBag)
    }
}

extension CreateGoalsViewModel {
    private func createRequest(data: [CreateModel]) -> CreateGoalsRequest {
        var result = CreateGoalsRequest(name: "",
                                        color: "",
                                        iconGroup: "",
                                        icon: "",
                                        date: "")
        data.forEach { goal in
            switch goal.type {
            case .text(let text):
                result.name = text.text
            case .date(let date):
                result.date = (date.date ?? Date()).string(pattern: .api)
            case .color(let color):
                result.color = color.first(where: { $0.isSelected })?.color
            case .icon(let icon):
                let selectedGroup = icon.first(where: { $0.isSelected })
                result.iconGroup = selectedGroup?.group
                result.icon = selectedGroup?.icons.first(where: { $0.isSelected })?.icon
            case .segmented(_):
                break
            }
        }
        
        return result
    }
    
    fileprivate func saveRequest(action: CreateActions, data: [CreateModel]) {
        switch action {
        case .create:
            repository.save(goals: createRequest(data: data)) { [weak self] loading in
                self?.emit(.loading(loading))
            } onSuccess: { [weak self] goals in
                self?.emit(.success)
            } onError: { [weak self] error in
                self?.emit(.error("Algo inesperado aconteceu!"))
            }
        case .edit(let uuid):
            repository.edit(goals: createRequest(data: data), with: uuid) { [weak self] loading in
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
