//
//  SignUpResponce.swift
//  NotForgot
//
//  Created by Разработчик on 06.04.2021.
//

import Foundation

struct SignUpResponce: Decodable {
    var email: String
    var name: String
    var id: Int
    var api_token: String
}
