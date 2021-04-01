//
//  UICustomTableViewCell.swift
//  NotForgot
//
//  Created by Разработчик on 01.04.2021.
//

import UIKit

class UICustomTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitlelabel: UILabel!
    @IBOutlet weak var checkBoxButton: CheckBox!
    @IBOutlet weak var body: UIView!
    
    let colorArray = [UIColor(red: 255/255, green: 209/255, blue: 48/255, alpha: 1),UIColor(red: 101/255, green: 121/255, blue: 234/255, alpha: 1),UIColor(red: 82/255, green: 204/255, blue: 87/255, alpha: 1),UIColor(red: 255/255, green: 104/255, blue: 92/255, alpha: 1)]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.body.layer.cornerRadius = self.body.frame.height/2
        self.body.backgroundColor = self.colorArray.randomElement()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
