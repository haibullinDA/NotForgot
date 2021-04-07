//
//  GetAllPrioritiesResponce.swift
//  NotForgot
//
//  Created by Разработчик on 07.04.2021.
//

import Foundation

struct GetAllPrioritiesResponce{
    var id: Int
    var name: String
    var color: String
    
    init() {
        self.id = Int()
        self.name = String()
        self.color = String()
    }
    
    init?(json: [String:Any]) {
        guard let id = json["id"] as? Int,
              let name = json["name"] as? String,
              let color = json["color"] as? String
        else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.color = color
    }
    
    static func getArray(from jsonArray: Any) -> [GetAllPrioritiesResponce]? {

        guard let jsonArray = jsonArray as? Array<[String: Any]> else { return nil }
        var priorities: [GetAllPrioritiesResponce] = []

        for jsonObject in jsonArray {
            if let priority = GetAllPrioritiesResponce(json: jsonObject) {
                priorities.append(priority)
            }
        }
        return priorities
    }
}
