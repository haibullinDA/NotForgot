//
//  UICustomButton.swift
//  SpaceInvaders
//
//  Created by Разработчик on 19.03.2021.
//

import UIKit
@IBDesignable
class UICustomButton: UIButton {

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor = .clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0.0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    

}
