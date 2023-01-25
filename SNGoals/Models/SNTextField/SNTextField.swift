//
//  SNTextField.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 24/01/23.
//

import UIKit
import RxCocoa
import RxSwift

class SNTextField: UITextField, UITextFieldDelegate {
    private var textFieldType: TextFieldTypes = .percent
    private weak var interactor: SNTextFieldDelegate? = nil
    private var validateSubject = PublishSubject<Validator>()
    public var isValidSubject = PublishSubject<Bool>()
    private var disposeBag = DisposeBag()
    public var isValid: Bool = false
    
    deinit {
        disposeBag = DisposeBag()
        Sanada.print("Deinit: \(self)")
    }
    
    private let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.delegate = self
        configureBindings()
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 10
        layer.masksToBounds = true
        borderStyle = .none
    }
    
    func configure(delegate: SNTextFieldDelegate, type: TextFieldTypes) {
        self.interactor = delegate
        self.keyboardType = type.keyboard()
        self.textFieldType = type
    }
    
    func configureBindings() {
        configureValidator()
        configureTextOutput()
        
        isValidSubject
            .subscribe(onNext: { [weak self] isValid in
                self?.isValid = isValid
            })
            .disposed(by: disposeBag)
    }
    
    public func setField(_ text: String?) {
        guard let text = text else { return }
        let newString = numberfy(string: text, type: textFieldType)
        self.rx.text.onNext(newString)
    }
    
    public func change(type: TextFieldTypes) {
        self.textFieldType = type
        self.rx.text.onNext("")
    }
    
    public func placeholder(_ text: String?) {
        self.placeholder = text
    }
    
    public func configureError(validate: Validator) {
        validateSubject.onNext(validate)
    }
    
    private func configureTextOutput() {
        self.rx.text
            .changed
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] text in
                guard let textField = self else { return }
                let type = textField.textFieldType
                
                switch self?.textFieldType {
                case .text:
                    self?.interactor?.textField(textField,
                                                didChange: text,
                                                with: type)
                case .currency:
                    self?.interactor?.textField(textField,
                                                didChange: text.decimalInputFormatting(),
                                                with: type)
                case .percent:
                    self?.interactor?.textField(textField,
                                                didChange: text.percentInputFormatting(),
                                                with: type)
                case .number:
                    self?.interactor?.textField(textField,
                                                didChange: text.digits.number,
                                                with: type)
                default:
                    self?.interactor?.textField(textField,
                                                didChange: text,
                                                with: type)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func configureValidator() {
        self.rx
            .text
            .changed
            .withLatestFrom(validateSubject, resultSelector: {(text: $0, validator: $1)})
            .map { [weak self] result in
                result.validator.validate(result.text ?? "")
            }
            .bind(to: isValidSubject)
            .disposed(by: disposeBag)

        self.rx
            .text
            .changed
            .withLatestFrom(validateSubject, resultSelector: {(text: $0, validator: $1)})
            .filter { [weak self] result in
                result.validator.validate(result.text ?? "")
            }
            .map { [weak self] result in
                result.validator.validate(result.text ?? "")
            }
            .bind(to: isValidSubject)
            .disposed(by: disposeBag)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text else { return false }
        switch textFieldType {
        case .currency:
            guard lenght(textField: textField, range: range, string: string) else {
                return false
            }
            if string.isEmpty {
                let oldDigits = textField.text?.digits
                textField.text = String(oldDigits?.dropLast() ?? "").currencyInputFormatting()
            } else {
                let newNumber = (oldText as NSString).replacingCharacters(in: range, with: string).digits
                textField.text = newNumber.currencyInputFormatting()
            }
        case .percent:
            guard lenght(textField: textField, range: range, string: string) else {
                return false
            }
            if string.isEmpty {
                let oldDigits = textField.text?.digits
                textField.text = String(oldDigits?.dropLast() ?? "").percentFormatting()
            } else {
                let newNumber = (oldText as NSString).replacingCharacters(in: range, with: string).digits
                textField.text =  newNumber.percentFormatting()
            }
        case .number:
            guard lenght(textField: textField, range: range, string: string) else {
                return false
            }
            if string.isEmpty {
                
                let oldDigits = textField.text?.digits
                textField.text = String(oldDigits?.dropLast() ?? "").numberFormatting()
            } else {
                let newNumber = (oldText as NSString).replacingCharacters(in: range, with: string).digits
                textField.text =  newNumber.numberFormatting()
            }
        default:
            return true
        }
        textField.sendActions(for: UIControl.Event.editingChanged)
        return false
    }
    
    fileprivate func numberfy(string: String, type: TextFieldTypes) -> String {
        switch textFieldType {
        case .currency:
            let oldDigits = string.digits
            return oldDigits.currencyInputFormatting()
        case .percent:
            let oldDigits = string.digits
            return oldDigits.percentFormatting()
        case .number:
            let oldDigits = string.digits
            return oldDigits.numberFormatting()
        case .text:
            return string
        }
    }
    
    private func lenght(textField: UITextField, range: NSRange, string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.onlyNumbers().count - substringToReplace.count + string.count
        return count <= 12
    }
}
