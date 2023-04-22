//
//  DateCollectionViewCell.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 06/01/23.
//

import UIKit
import RxSwift
import RxCocoa

class DateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var datePicker: UIDatePicker!

    private weak var delegate: CollectionDateProtocol?
    private var indexPath: IndexPath?
    private var disposeBag = DisposeBag()
    
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
    
    private func configureBindings() {
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        
        datePicker.rx
            .value
            .changed
            .subscribe(onNext: { [weak self] _ in
                guard let dateCell = self, let indexPath = dateCell.indexPath else { return }
                dateCell.delegate?.collectionViewCell(dateCell, isValid: true, from: indexPath)
            })
            .disposed(by: disposeBag)
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        guard let indexPath = indexPath else { return }
        delegate?.collectionViewCell(self, changed: picker.date, from: indexPath)
        delegate?.collectionViewCell(self, isValid: true, from: indexPath)
    }
        
    func configure(delegate: CollectionDateProtocol, indexPath: IndexPath, date: Date?, tint color: HEXColor?) {
        self.delegate = delegate
        self.indexPath = indexPath
        self.datePicker.minimumDate = Date()
        if let color = color {
            self.datePicker.tintColor = UIColor.fromHex(color)
        }
        guard let date = date else { return }
        self.datePicker.date = date
        delegate.collectionViewCell(self, isValid: true, from: indexPath)
    }
}
