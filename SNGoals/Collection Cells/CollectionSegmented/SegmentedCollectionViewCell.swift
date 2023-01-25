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

class SegmentedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private weak var delegate: CollectionSegmentedProtocol?
    private var indexPath: IndexPath?
    private var selectedSegment: Int?
    private var segments: [(name: String, id: GoalType)]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func configure(delegate: CollectionSegmentedProtocol,
                   indexPath: IndexPath,
                   segments: [(name: String, id: GoalType)],
                   selected segment: Int,
                   tint color: HEXColor?) {
        self.delegate = delegate
        self.indexPath = indexPath
        self.selectedSegment = segment
        self.segments = segments
        guard let color = color else { return }
        self.segmentedControl.selectedSegmentTintColor = UIColor.fromHex(color)
        self.segmentedControl.replaceSegments(segments: segments.map { $0.name })
        if segment <= segments.count {
            segmentedControl.selectedSegmentIndex = segment
            segmentedControl.sendActions(for: .valueChanged)
        }
    }
    @IBAction func didChange(_ sender: UISegmentedControl) {
        guard let indexPath = indexPath else { return }
        delegate?.collectionViewCell(changed: sender.selectedSegmentIndex, from: indexPath)
    }
}

extension UISegmentedControl {
    func replaceSegments(segments: Array<String>) {
        self.removeAllSegments()
        for segment in segments {
            self.insertSegment(withTitle: segment, at: self.numberOfSegments, animated: false)
        }
    }
}
