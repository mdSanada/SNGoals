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
    @IBOutlet weak var textField: SNTextField!
    private weak var delegate: CollectionTextFieldProtocol?
    private var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
    
    func change(type: TextFieldTypes) {
        self.textField.change(type: type)
        self.textField.text = nil
    }
    
    func textField(_ textField: SNTextField?, didChange value: Any?, with type: TextFieldTypes) {
        guard let indexPath = indexPath else { return }
        switch type {
        case .text:
            delegate?.collectionViewCell(changed: textField?.text as? String, from: indexPath)
        case .currency:
            let number = (value as? Double)?.asString(digits: 2, minimum: 2)
            delegate?.collectionViewCell(changed: number, from: indexPath)
        case .percent:
            let number = (value as? Double)?.asString(digits: 2, minimum: 0)
            delegate?.collectionViewCell(changed: number, from: indexPath)
        case .number:
            let number = (value as? Double)?.rounded(.down).asString(digits: 0, minimum: 0)
            delegate?.collectionViewCell(changed: number, from: indexPath)
        }
    }
}
