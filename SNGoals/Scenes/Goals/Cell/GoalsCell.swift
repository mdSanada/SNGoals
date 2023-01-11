//
//  GoalsCell.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 05/01/23.
//

import UIKit

class GoalsCell: UITableViewCell {
    @IBOutlet weak var imageItem: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var viewIconBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func render(title: String, date: Date, image: String, color: String) {
        self.labelTitle.text = title
        self.labelDescription.text = date.string(pattern: .complete)
        self.imageItem.image = UIImage(systemName: image)
        self.viewIconBackground.backgroundColor = UIColor.fromHex(color)
    }
}
