//
//  LoginViewModel.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 05/01/23.
//

import Foundation
import RxSwift
import RxCocoa

enum LoginStates: SNStateful {
    case success(String)
    case loading(Bool)
    case error(String)
}

class LoginViewModel: SNViewModel<LoginStates> {
    let login = PublishSubject<(LoginModel)>()
    var disposeBag = DisposeBag()

    override func configure() {
        login
            .subscribe(onNext: { [weak self] login in
                self?.emit(.loading(true))
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.emit(.success("Autenticado com sucesso!"))
                    self?.emit(.loading(false))
                }
            })
            .disposed(by: disposeBag)
    }
}

extension LoginModel {
}
