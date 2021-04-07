//
//  SignInRequest.swift
//  NotForgot
//
//  Created by Разработчик on 06.04.2021.
//

import Foundation

struct SignInRequest: Encodable {
    var email: String
    var password: String
}
