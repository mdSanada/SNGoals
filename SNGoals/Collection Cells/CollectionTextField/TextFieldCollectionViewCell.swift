//
//  TextFieldCollectionViewCell.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 06/01/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class TextFieldCollectionViewCell: UICollectionViewCell, UITextFieldDelegate, SNTextFieldDelegate {
    @IBOutlet private weak var textField: SNTextField!
    private weak var delegate: CollectionTextFieldProtocol?
    private var indexPath: IndexPath?
    private var disposeBag = DisposeBag()
    public var isValidSubject = PublishSubject<Bool>()
    public var isValid: Bool = false
    
    deinit {
        disposeBag = DisposeBag()
        Sanada.print("Deinit: \(self)")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        configureBindings()
    }
        
    func configure(delegate: CollectionTextFieldProtocol,
                   indexPath: IndexPath,
                   text: String?,
                   placeholder: String?,
                   type: TextFieldTypes,
                   tint color: HEXColor?) {
        self.delegate = delegate
        self.indexPath = indexPath
        self.textField.configure(delegate: self, type: type)
        self.textField.placeholder(placeholder)
        self.textField.configureError(validate: .equalMore(count: 1))
        self.textField.setField(text ?? "")
        guard let color = color else { return }
        self.textField.tintColor = UIColor.fromHex(color)
    }
    
    private func configureBindings() {
        textField.isValidSubject
            .bind(to: isValidSubject)
            .disposed(by: disposeBag)
        
        isValidSubject
            .subscribe(onNext: { [weak self] isValid in
                guard let textFieldCell = self, let indexPath = self?.indexPath else { return }
                textFieldCell.delegate?.collectionViewCell(textFieldCell, isValid: isValid, from: indexPath)
            })
            .disposed(by: disposeBag)
    }
    
    func change(type: TextFieldTypes) {
        self.textField.change(type: type)
        self.textField.text = nil
    }
    
    func textField(_ textField: SNTextField?, didChange value: Any?, with type: TextFieldTypes) {
        guard let indexPath = indexPath else { return }
        switch type {
        case .text:
            delegate?.collectionViewCell(self, changed: textField?.text as? String, from: indexPath)
        case .currency:
            let number = (value as? Double)?.asString(digits: 2, minimum: 2)
            delegate?.collectionViewCell(self, changed: number, from: indexPath)
        case .percent:
            let number = (value as? Double)?.asString(digits: 2, minimum: 0)
            delegate?.collectionViewCell(self, changed: number, from: indexPath)
        case .number:
            let number = (value as? Double)?.rounded(.down).asString(digits: 0, minimum: 0)
            delegate?.collectionViewCell(self, changed: number, from: indexPath)
        }
    }
}
