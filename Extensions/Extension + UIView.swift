//
//  Extension + UIView.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 05/01/23.
//

import UIKit

extension UIView {
    func addGradient() {
        let gradient = UIView()
        
        self.backgroundColor = .clear
        
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 0.953, green: 0.251, blue: 0.576, alpha: 1).cgColor,
            UIColor(red: 0, green: 0.925, blue: 0.757, alpha: 1).cgColor
        ]
        layer.locations = [0, 1]
        layer.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1,
                                                                             b: 1,
                                                                             c: -0.8,
                                                                             d: 0.8,
                                                                             tx: 0.4,
                                                                             ty: -0.4))
        layer.bounds = self.bounds.insetBy(dx: -0.5 * self.bounds.size.width,
                                           dy: -0.5 * self.bounds.size.height)
        
        layer.position = self.center
        
        gradient.layer.addSublayer(layer)
        
        self.addSubview(gradient)
        
        self.sendSubviewToBack(gradient)
        
        gradient.snp.makeConstraints { make in
            make.top.bottom.trailing.leading.equalToSuperview()
        }
    }
    
    func addBorders(withEdges edges: UIRectEdge...,
                    withColor color: UIColor,
                    withAlpha alpha: CGFloat,
                    withThickness thickness: CGFloat,
                    cornerRadius: CGFloat) {
        layer.borderColor = color.withAlphaComponent(alpha).cgColor
        layer.borderWidth = thickness
        layer.cornerRadius = cornerRadius
        edges.forEach({ edge in
            
            switch edge {
            case .left:
                layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
                
            case .right:
                layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
                
            case .top:
                layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                
            case .bottom:
                layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                
            case .all:
                layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
                
            default:
                break
            }
        })
    }
}
