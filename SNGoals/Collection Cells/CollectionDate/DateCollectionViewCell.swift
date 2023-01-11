//
//  DateCollectionViewCell.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 06/01/23.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    static let identifier = "Date"
    static let nib = UINib(nibName: "DateCollectionViewCell", bundle: nil)
    
    @IBOutlet weak var datePicker: UIDatePicker!

    private var delegate: CollectionDateProtocol?
    private var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        configureBindings()
    }
    
    private func configureBindings() {
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        guard let indexPath = indexPath else { return }
        delegate?.collectionViewCell(changed: picker.date, from: indexPath)
    }
        
    func configure(delegate: CollectionDateProtocol, indexPath: IndexPath, date: Date?, tint color: String?) {
        self.delegate = delegate
        self.indexPath = indexPath
        self.datePicker.minimumDate = Date()
        if let color = color {
            self.datePicker.tintColor = UIColor.fromHex(color)
        }
        guard let date = date else { return }
        self.datePicker.date = date
    }
}
