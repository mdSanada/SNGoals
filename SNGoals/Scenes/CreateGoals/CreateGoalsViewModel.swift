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
        // TODO: - Add Owner
        var result = CreateGoalsRequest(name: "",
                                        color: "",
                                        iconGroup: "",
                                        icon: "",
                                        owner: nil,
                                        shared: nil,
                                        date: nil)
        data.forEach { goal in
            switch goal.type {
            case .text(let text):
                result.name = text.text
            case .date(let date):
                result.date = date.date ?? Date()
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
        emit(.loading(true))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.emit(.success("Salvo"))
            self?.emit(.loading(false))
        }
    }
}
