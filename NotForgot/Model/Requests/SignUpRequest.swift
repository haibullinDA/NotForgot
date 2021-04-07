//
//  SignUpRequest.swift
//  NotForgot
//
//  Created by Разработчик on 06.04.2021.
//

import Foundation

struct SignUpRequest: Encodable {
    var email: String
    var name: String
    var password: String
}
