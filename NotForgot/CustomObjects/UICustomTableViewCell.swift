//
//  UICustomTableViewCell.swift
//  NotForgot
//
//  Created by Разработчик on 08.04.2021.
//

import UIKit

class UICustomTableViewCell: UITableViewCell {

    @IBOutlet weak var body: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var checkBoxButton: CheckBox!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.body.layer.cornerRadius = self.body.frame.height/4
        self.titleLabel.textColor = .white
        self.subtitleLabel.textColor = .white
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
