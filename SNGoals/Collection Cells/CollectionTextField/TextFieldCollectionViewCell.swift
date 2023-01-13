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

class TextFieldCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    private weak var delegate: CollectionTextFieldProtocol?
    private var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textField.delegate = self
    }
    
    func configure(delegate: CollectionTextFieldProtocol, indexPath: IndexPath, text: String?, tint color: HEXColor?) {
        self.delegate = delegate
        self.indexPath = indexPath
        self.textField.text = text
        guard let color = color else { return }
        self.textField.tintColor = UIColor.fromHex(color)
    }
        
    @IBAction func didChange(_ sender: UITextField) {
        guard let indexPath = indexPath else { return }
        delegate?.collectionViewCell(changed: sender.text, from: indexPath)
    }
}
