//
//  UIImageViewExtension.swift
//  NotForgot
//
//  Created by Разработчик on 08.04.2021.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global(qos: .utility).async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}
