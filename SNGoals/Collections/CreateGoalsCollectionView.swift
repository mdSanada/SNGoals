//
//  CreateGoalsCollectionView.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 11/01/23.
//

import UIKit

class CreateGoalsCollectionView: UICollectionView {
    private var dataBase: [CreateModel] = []
    private let sectionInsets = UIEdgeInsets(top: 0, left: 20.0, bottom: 20.0, right: 20.0)
    public weak var interactor: CreateGoalsCollectionInteractor?
    private(set) var selectionColor: HEXColor? = nil

    private func configureCollection() {
        self.delegate = self
        self.dataSource = self
        
        self.register(UINib(nibName: CreateGroupCollection.Text.nib, bundle: nil),
                      forCellWithReuseIdentifier: CreateGroupCollection.Text.identifier)
        self.register(UINib(nibName: CreateGroupCollection.Date.nib, bundle: nil),
                      forCellWithReuseIdentifier: CreateGroupCollection.Date.identifier)
        self.register(UINib(nibName: CreateGroupCollection.Color.nib, bundle: nil),
                      forCellWithReuseIdentifier: CreateGroupCollection.Color.identifier)
        self.register(UINib(nibName: CreateGroupCollection.Icon.nib, bundle: nil),
                      forCellWithReuseIdentifier: CreateGroupCollection.Icon.identifier)
        self.register(UINib(nibName: CreateGroupCollection.Segmented.nib, bundle: nil),
                      forCellWithReuseIdentifier: CreateGroupCollection.Segmented.identifier)

        self.register(CollectionHeader.self,
                      forSupplementaryViewOfKind: CreateGroupCollection.Header.element,
                      withReuseIdentifier: CreateGroupCollection.Header.identifier)
    }
    
    public func register() {
        configureCollection()
    }
    
    public func force(selection colorHex: HEXColor?) {
        selectionColor = colorHex
    }
    
    public func set(_ dataBase: [CreateModel]) {
        self.dataBase = dataBase
        let accent = UIColor.accent.toHex()
        self.interactor?.collectionView(self, didChange: (selectionColor ?? dataBase.selectedColor()) ?? accent)
        self.reloadData()
    }
    
    public func getData() -> [CreateModel] {
        return dataBase
    }
}

extension CreateGoalsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataBase.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let item = dataBase[section]
        switch item.type {
        case .text:
            return 1
        case .date:
            return 1
        case .segmented:
            return 1
        case .color(let colors):
            return colors.count
        case .icon(let icons):
            let selected = icons.first { icon in
                return icon.isSelected
            }
            return selected?.icons.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 34)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CreateGroupCollection.Header.identifier, for: indexPath) as? CollectionHeader else { return UICollectionReusableView() }
        
        let item = dataBase[indexPath.section]
        sectionHeader.label.text = item.section
        
        switch item.type {
        case .icon(let icons):
            let selected = icons.first { icon in
                return icon.isSelected
            }
            guard let selected = selected else { return sectionHeader }
            let menu = icons.compactMap { item in
                return item.group
            }
            sectionHeader.configureMenu(delegate: self,
                                        at: indexPath,items: menu,
                                        selected: selected.group,
                                        tint: selectionColor ?? dataBase.selectedColor())
        default:
            sectionHeader.removeMenu()
        }
        return sectionHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = dataBase[indexPath.section].type
        switch item {
        case .text(let text):
            let cell: TextFieldCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateGroupCollection.Text.identifier, for: indexPath) as! TextFieldCollectionViewCell
            cell.configure(delegate: self,
                           indexPath: indexPath,
                           text: text.text,
                           tint: selectionColor ?? dataBase.selectedColor())
            return cell
        case .date(let date):
            let cell: DateCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateGroupCollection.Date.identifier, for: indexPath) as! DateCollectionViewCell
            cell.configure(delegate: self,
                           indexPath: indexPath,
                           date: date.date,
                           tint: selectionColor ?? dataBase.selectedColor())
            return cell
        case .segmented(let segmented):
            let cell: SegmentedCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateGroupCollection.Segmented.identifier, for: indexPath) as! SegmentedCollectionViewCell
            cell.configure(delegate: self,
                           indexPath: indexPath,
                           segments: segmented.segmenteds,
                           selected: segmented.selected,
                           tint: selectionColor ?? dataBase.selectedColor())
            return cell
        case .color(let colors):
            let color = colors[indexPath.row]
            let cell: ColorCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateGroupCollection.Color.identifier, for: indexPath) as! ColorCollectionViewCell
            cell.configure(delegate: self,
                           indexPath: indexPath,
                           color: color.color,
                           isSelected: color.isSelected)
            return cell
        case .icon(let icons):
            guard let icon = icons.first(where: { $0.isSelected })?.icons[indexPath.row] else { return UICollectionViewCell() }
            let cell: IconCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateGroupCollection.Icon.identifier, for: indexPath) as! IconCollectionViewCell
            cell.configure(delegate: self,
                           indexPath: indexPath,
                           icon: icon.icon,
                           isSelected: icon.isSelected,
                           tint: selectionColor ?? dataBase.selectedColor())
            return cell
        }
    }
}

extension CreateGoalsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemsPerRow: CGFloat = 1
        var width: CGFloat = 0
        var height: CGFloat = 0
        let item = dataBase[indexPath.section].type
        switch item {
        case .text:
            itemsPerRow = 1
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = self.frame.width - paddingSpace
            width = availableWidth / itemsPerRow
            height = 42
        case .date:
            itemsPerRow = 1
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = self.frame.width - paddingSpace
            width = availableWidth / itemsPerRow
            height = 42
        case .segmented:
            itemsPerRow = 1
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = self.frame.width - paddingSpace
            width = availableWidth / itemsPerRow
            height = 42
        case .color:
            width = 50
            height = 50
        case .icon:
            width = 50
            height = 50
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension CreateGoalsCollectionView: CollectionTextFieldProtocol {
    func collectionViewCell(changed value: String?, from indexPath: IndexPath) {
        guard let value = value else { return }
        dataBase[indexPath.section].type.change(text: value, at: indexPath)
    }
}

extension CreateGoalsCollectionView: CollectionDateProtocol {
    func collectionViewCell(changed date: Date?, from indexPath: IndexPath) {
        guard let date = date else { return }
        dataBase[indexPath.section].type.change(date: date, at: indexPath)
    }
}

extension CreateGoalsCollectionView: CollectionSegmentedProtocol {
    func collectionViewCell(changed segment: Int?, from indexPath: IndexPath) {
        guard let segment = segment else { return }
        dataBase[indexPath.section].type.change(segmented: segment, at: indexPath)
    }
}

extension CreateGoalsCollectionView: CollectionColorProtocol {
    func collectionViewCell(_ cell: ColorCollectionViewCell, changed color: HEXColor?, from indexPath: IndexPath) {
        guard let color = color else { return }
        dataBase[indexPath.section].type.change(color: color, at: indexPath)
        interactor?.collectionView(self, didChange: color)
        self.reloadData()
    }
}

extension CreateGoalsCollectionView: CollectionIconProtocol {
    func collectionViewCell(_ cell: IconCollectionViewCell, changed icon: String?, from indexPath: IndexPath) {
        guard let icon = icon else { return }
        dataBase[indexPath.section].type.change(icon: icon, at: indexPath)
        UIView.performWithoutAnimation { [weak self] in
            self?.reloadSections(IndexSet(integer: indexPath.section))
        }
    }
}

extension CreateGoalsCollectionView: CollectionHeaderProtocol {
    func collectionViewHeader(changed menu: String, from indexPath: IndexPath) {
        let item = dataBase[indexPath.section]
        item.type.select(iconMenu: menu, at: indexPath)
        UIView.performWithoutAnimation { [weak self] in
            self?.reloadSections(IndexSet(integer: indexPath.section))
        }
    }
}
