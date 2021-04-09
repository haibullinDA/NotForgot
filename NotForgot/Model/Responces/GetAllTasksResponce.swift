//
//  GetAllTasksResponce.swift
//  NotForgot
//
//  Created by Разработчик on 08.04.2021.
//

import Foundation

struct GetAllTasksResponce {
    
    var id: Int
    var title: String
    var description: String
    var done: Int
    var deadline: Int
    var category: GetAllCategoriesResponce
    var priority: GetAllPrioritiesResponce
    var created: Int
    
    init() {
        self.id = Int()
        self.title = String()
        self.description = String()
        self.done = Int()
        self.deadline = Int()
        self.category = GetAllCategoriesResponce()
        self.priority = GetAllPrioritiesResponce()
        self.created = Int()
    }
    
    init?(json: [String:Any]) {
        guard let id = json["id"] as? Int,
              let title = json["title"] as? String,
              let done = json["done"] as? Int,
              let deadline = json["deadline"] as? Int,
              let category = json["category"] as? [String:Any],
              let priority = json["priority"] as? [String:Any],
              let created = json["created"] as? Int,
              let description = json["description"] as? String
        else {
            return nil
        }
        
        self.id = id
        self.title = title
        self.description = description
        self.done = done
        self.deadline = deadline
        guard let cat = GetAllCategoriesResponce(json: category) else {
            return nil
        }
        guard let pri = GetAllPrioritiesResponce(json: priority) else {
            return nil
        }
        self.category = cat
        self.priority = pri
        self.created = created
    }
    
    static func getArray(from jsonArray: Any) -> [GetAllTasksResponce]? {

        guard let jsonArray = jsonArray as? Array<[String: Any]> else { return nil }
        var tasks: [GetAllTasksResponce] = []

        for jsonObject in jsonArray {
            if let task = GetAllTasksResponce(json: jsonObject) {
                tasks.append(task)
            }
        }
        return tasks
    }
}
