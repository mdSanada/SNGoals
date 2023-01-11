//
//  ViewController.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 05/01/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class LoginViewController: SNViewController<LoginStates, LoginViewModel> {
    @IBOutlet weak var fieldEmail: UITextField!
    @IBOutlet weak var fieldPassword: UITextField!
    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var buttonSignUp: UIButton!
    
    var disposeBag = DisposeBag()
    var delegate: LoginDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSignIn.isEnabled = false
    }
    
    override func configureBindings() {
        configureFields()
    }
    
    override func configureViews() {
        view.addGradient()
    }
    
    private func configureFields() {
        Observable.combineLatest(fieldEmail.rx.text.changed,
                                 fieldPassword.rx.text.changed)
        .map({ (email, password) in
            let emailValid = Validator.email.validate(email ?? "")
            let passwordValid = Validator.equalMore(count: 3).validate(password ?? "")
            return emailValid && passwordValid
        })
        .bind(to: buttonSignIn.rx.isEnabled)
        .disposed(by: disposeBag)
    }
    
    @IBAction func doSignIn(_ sender: Any) {
        guard let email = fieldEmail.text,
              let password = fieldPassword.text else {
            handleLoginError()
            return
        }
        let login = LoginModel(email: email,
                               password: password)
        viewModel?.login.onNext(login)
    }
    
    @IBAction func goToCreateAccount(_ sender: Any) {
    }
    
    func handleLoginError() {
        print("Handle Error")
    }
    
    override func render(states: LoginStates) {
        switch states {
        case .success(let string):
            Sanada.print(string)
            delegate?.pushHome()
            delegate = nil
        case .loading(let loading):
            view.isUserInteractionEnabled = !loading
            buttonIsLoading(loading)
        case .error(let string):
            break
        }
    }
    
    private func buttonIsLoading(_ loading: Bool) {
        buttonSignIn.isEnabled = !loading
        buttonSignIn.configuration?.showsActivityIndicator = loading
        buttonSignIn.configuration?.title = loading ? "" : "Entrar"
    }
}
