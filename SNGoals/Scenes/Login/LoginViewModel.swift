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
    let repository = AuthRepository()
    let login = PublishSubject<(LoginModel)>()
    var disposeBag = DisposeBag()

    override func configure() {
        login
            .subscribe(onNext: { [weak self] login in
                self?.emit(.loading(true))
                self?.repository.authenticate(with: login.email,
                                              and: login.password,
                                              completion: { success in
                    self?.emit(.loading(false))
                    if success {
                        self?.emit(.success("Autenticado com sucesso!"))
                    } else {
                        self?.emit(.error("Email ou senha incorreto."))
                    }
                })
            })
            .disposed(by: disposeBag)
    }
}

extension LoginModel {
}
