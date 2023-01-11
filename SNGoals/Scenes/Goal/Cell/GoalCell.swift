//
//  GoalsCell.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 05/01/23.
//

import UIKit

class GoalCell: UITableViewCell {
    @IBOutlet weak var imageItem: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewIconBackground: UIView!
    @IBOutlet weak var progressGoal: UIProgressView!
    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var labelGoal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func render(title: String, image: String, color: String, type: String, value: Double, goal: Double) {
        self.labelTitle.text = title
        self.imageItem.image = UIImage(systemName: image)
        self.viewIconBackground.backgroundColor = UIColor.fromHex(color)
        configureProgress(color: color, value: value, goal: goal)
        configureLabels(type: type, value: value, goal: goal)
    }
    
    private func configureLabels(type: String, value: Double, goal: Double) {
        if type == "MONEY" {
            labelValue.text = value.asMoney()
            labelGoal.text = "/ \(goal.asMoney())"
        } else {
            labelValue.text = value.asString(digits: 0, minimum: 0)
            labelGoal.text = "/ \(goal.asString(digits: 0, minimum: 0))"
        }
    }
    
    private func configureProgress(color: String, value: Double, goal: Double) {
        self.progressGoal.tintColor = UIColor.secondarySystemBackground
        self.progressGoal.progressTintColor = UIColor.fromHex(color)
        self.progressGoal.progress = Float(value / goal)
    }
}
