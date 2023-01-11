//
//  CollectionHeader.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 06/01/23.
//

import UIKit

class CollectionHeader: UICollectionReusableView {
    static let identifier = "CollectionHeader"
    static let element = UICollectionView.elementKindSectionHeader
    
    private weak var delegate: CollectionHeaderProtocol?
    
    var stack: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    var label: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.sizeToFit()
        return label
    }()
    
    var button: UIButton = {
        let button: UIButton = .init()
        button.setTitle("", for: .normal)
        button.tintColor = .tintColor
        button.setTitleColor(.tintColor, for: .normal)
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    var menu: UIMenu = {
        let list = UIMenu(title: "",
                          options: .singleSelection,
                          children: [UIAction(title: "teste", handler: { _ in
            Sanada.print("teste")
        })])
        
        return list
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(button)
        button.isHidden = true
    }
        
    func configureMenu(delegate: CollectionHeaderProtocol,
                       at indexPath: IndexPath,
                       items: [String],
                       selected: String,
                       tint color: String?) {
        self.delegate = delegate
        button.isHidden = false
        button.setTitle(selected, for: .normal)
        var elements: [UIAction] = []
        items.forEach { item in
            let action = UIAction(title: item) { [weak self] _ in
                self?.delegate?.collectionViewHeader(changed: item, from: indexPath)
                self?.button.setTitle(item, for: .normal)
            }
            action.state = action.title == selected ? .on : .off
            elements.append(action)
        }
        let newMenu = menu.replacingChildren(elements)
        button.menu = newMenu
        if let color = color {
            button.setTitleColor(UIColor.fromHex(color), for: .normal)
        }
    }
    
    func removeMenu() {
        button.isHidden = true
        button.menu = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
