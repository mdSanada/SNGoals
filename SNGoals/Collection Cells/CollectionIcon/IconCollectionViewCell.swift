//
//  IconCollectionViewCell.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 06/01/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class IconCollectionViewCell: UICollectionViewCell {
    static let identifier = "Icon"
    static let nib = UINib(nibName: "IconCollectionViewCell", bundle: nil)
    
    @IBOutlet weak var viewCircle: UIView!
    @IBOutlet weak var imageCell: UIImageView!
    
    private var delegate: CollectionIconProtocol?
    private var indexPath: IndexPath?
    private var indexPathSubject = PublishSubject<IndexPath>()
    private var iconSubject = PublishSubject<String>()
    private var disposeBag = DisposeBag()
    private var isSelectedCell: Bool? {
        didSet {
            if let isSelectedCell = isSelectedCell {
                isSelected(isSelectedCell)
            }
        }
    }
    private let cornerRadius: CGFloat = 25
    private var color: UIColor = .tintColor
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        configureBindings()
    }

    private func configureViews() {
        viewCircle.layer.cornerRadius = cornerRadius
        viewCircle.layer.masksToBounds = true
        viewCircle.backgroundColor = .secondarySystemBackground
    }
    
    private func configureBindings() {
        viewCircle.rx
            .tapGesture()
            .when(.recognized)
            .withLatestFrom(indexPathSubject, resultSelector: {(index: $1, action: $0)})
            .withLatestFrom(iconSubject, resultSelector: {(index: $0.index, icon: $1)})
            .subscribe(onNext: { [weak self] (index, icon) in
                guard let self = self else { return }
                self.delegate?.collectionViewCell(self, changed: icon, from: index)
            })
            .disposed(by: disposeBag)
    }
    
    private func isSelected(_ selected: Bool) {
        if selected {
            imageCell.tintColor = color
        } else {
            imageCell.tintColor = .darkGray
        }
    }
    
    func configure(delegate: CollectionIconProtocol, indexPath: IndexPath, icon: String, isSelected: Bool, tint color: String?) {
        if let color = color {
            self.color = UIColor.fromHex(color)
        }
        self.delegate = delegate
        self.indexPath = indexPath
        self.isSelected(isSelected)
        iconSubject.onNext(icon)
        indexPathSubject.onNext(indexPath)
        imageCell.image = UIImage(systemName: icon)
        configureViews()
    }

}
