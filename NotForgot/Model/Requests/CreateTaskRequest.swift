//
//  CreateTaskRequest.swift
//  NotForgot
//
//  Created by Разработчик on 07.04.2021.
//

import Foundation

struct CreateTaskRequest: Encodable {
    var title: String
    var descrition: String
    var done: Int
    var deadline: Int
    var category_id: Int
    var priority_id: Int
}
