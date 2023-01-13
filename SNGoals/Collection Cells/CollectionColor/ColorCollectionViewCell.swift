//
//  ColorCollectionViewCell.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 06/01/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class ColorCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewCircle: UIView!
    
    private weak var delegate: CollectionColorProtocol?
    private var indexPath: IndexPath?
    private var isSelectedCell: Bool? {
        didSet {
            if let isSelectedCell = isSelectedCell {
                isSelected(isSelectedCell)
            }
        }
    }
    private let cornerRadius: CGFloat = 25
    private var indexPathSubject = PublishSubject<IndexPath>()
    private var colorSubject = PublishSubject<String>()
    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        configureBindings()
    }
    
    override func setNeedsUpdateConfiguration() {
        super.setNeedsUpdateConfiguration()
        if let isSelectedCell = isSelectedCell {
            isSelected(isSelectedCell)
        }
    }
    
    private func configureBindings() {
        viewCircle.rx
            .tapGesture()
            .when(.recognized)
            .withLatestFrom(indexPathSubject, resultSelector: {(index: $1, action: $0)})
            .withLatestFrom(colorSubject, resultSelector: {(index: $0.index, color: $1)})
            .subscribe(onNext: { [weak self] (index, color) in
                guard let self = self else { return }
                self.delegate?.collectionViewCell(self, changed: color, from: index)
            })
            .disposed(by: disposeBag)
    }

    private func configureViews() {
        viewCircle.layer.cornerRadius = cornerRadius
        viewCircle.layer.masksToBounds = true
    }
    
    private func isSelected(_ selected: Bool) {
        if selected {
            viewCircle.addBorders(withEdges: .all,
                                  withColor: .black,
                                  withAlpha: 0.4,
                                  withThickness: 5,
                                  cornerRadius: cornerRadius)
        } else {
            viewCircle.addBorders(withEdges: .all,
                                  withColor: .secondarySystemBackground,
                                  withAlpha: 0.7,
                                  withThickness: 5,
                                  cornerRadius: cornerRadius)
        }
    }
    
    func configure(delegate: CollectionColorProtocol, indexPath: IndexPath, color: HEXColor, isSelected: Bool) {
        self.delegate = delegate
        self.indexPath = indexPath
        self.indexPathSubject.onNext(indexPath)
        self.colorSubject.onNext(color)
        self.isSelectedCell = isSelected
        configureViews()
        viewCircle.backgroundColor = UIColor.fromHex(color)
    }
}
