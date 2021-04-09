//
//  CheckBox.swift
//  NotForgot
//
//  Created by Разработчик on 01.04.2021.
//

import UIKit

class CheckBox: UIButton {

    // Images
        let checkedImage = UIImage(named: "checkBox_On")! as UIImage
        let uncheckedImage = UIImage(named: "checkBox_Off")! as UIImage
        
        // Bool property
        var isChecked: Bool = false {
            didSet {
                if isChecked == true {
                    self.setBackgroundImage(checkedImage, for: UIControl.State.normal)
                } else {
                    self.setBackgroundImage(uncheckedImage, for: UIControl.State.normal)
                }
            }
        }
            
        override func awakeFromNib() {
            self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
            self.isChecked = false
        }
            
        @objc func buttonClicked(sender: UIButton) {
            if sender == self {
                isChecked = !isChecked
            }
        }
}
