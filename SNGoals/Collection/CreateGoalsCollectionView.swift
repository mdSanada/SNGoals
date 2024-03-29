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
    public var interactor: CreateGoalsCollectionInteractor?

    private func configureCollection() {
        self.delegate = self
        self.dataSource = self
        
        self.register(TextFieldCollectionViewCell.nib,
                      forCellWithReuseIdentifier: TextFieldCollectionViewCell.identifier)
        self.register(DateCollectionViewCell.nib,
                      forCellWithReuseIdentifier: DateCollectionViewCell.identifier)
        self.register(ColorCollectionViewCell.nib,
                      forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
        self.register(IconCollectionViewCell.nib,
                      forCellWithReuseIdentifier: IconCollectionViewCell.identifier)
        
        self.register(CollectionHeader.self,
                      forSupplementaryViewOfKind: CollectionHeader.element,
                      withReuseIdentifier: CollectionHeader.identifier)
    }
    
    public func register() {
        configureCollection()
    }
    
    public func set(_ dataBase: [CreateModel]) {
        self.dataBase = dataBase
        let accent = UIColor.accent.toHex()
        self.interactor?.collectionView(self, didChange: dataBase.selectedColor() ?? accent)
        self.reloadData()
    }
    
    public func getData() -> CreateGoalsRequest {
        return dataBase.save()
    }
}

extension CreateGoalsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataBase.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let item = dataBase[section]
        switch item.type {
        case .text(let texts):
            return texts.count
        case .date(let dates):
            return dates.count
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
        guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeader.identifier, for: indexPath) as? CollectionHeader else { return UICollectionReusableView() }
        
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
                                        tint: dataBase.selectedColor())
        default:
            sectionHeader.removeMenu()
        }
        return sectionHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = dataBase[indexPath.section].type
        switch item {
        case .text(let texts):
            let text = texts[indexPath.row]
            let cell: TextFieldCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldCollectionViewCell.identifier, for: indexPath) as! TextFieldCollectionViewCell
            cell.configure(delegate: self,
                           indexPath: indexPath,
                           text: text.text,
                           tint: dataBase.selectedColor())
            return cell
        case .date(let dates):
            let date = dates[indexPath.row]
            let cell: DateCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionViewCell.identifier, for: indexPath) as! DateCollectionViewCell
            cell.configure(delegate: self,
                           indexPath: indexPath,
                           date: date.date,
                           tint: dataBase.selectedColor())
            return cell
        case .color(let colors):
            let color = colors[indexPath.row]
            let cell: ColorCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath) as! ColorCollectionViewCell
            cell.configure(delegate: self,
                           indexPath: indexPath,
                           color: color.color,
                           isSelected: color.isSelected)
            return cell
        case .icon(let icons):
            guard let icon = icons.first(where: { $0.isSelected })?.icons[indexPath.row] else { return UICollectionViewCell() }
            let cell: IconCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCollectionViewCell.identifier, for: indexPath) as! IconCollectionViewCell
            cell.configure(delegate: self,
                           indexPath: indexPath,
                           icon: icon.icon,
                           isSelected: icon.isSelected,
                           tint: dataBase.selectedColor())
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

extension CreateGoalsCollectionView: CollectionColorProtocol {
    func collectionViewCell(_ cell: ColorCollectionViewCell, changed color: String?, from indexPath: IndexPath) {
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
