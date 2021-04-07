//
//  GetAllCategoriesResponce.swift
//  NotForgot
//
//  Created by Разработчик on 07.04.2021.
//

import Foundation

struct GetAllCategoriesResponce {
    var id: Int
    var name: String
    
    init() {
        self.id = Int()
        self.name = String()
    }
    
    init(id: Int,name: String) {
        self.id = id
        self.name = name
    }
    
    init?(json: [String:Any]) {
        guard let id = json["id"] as? Int,
              let name = json["name"] as? String
        else {
            return nil
        }
        
        self.id = id
        self.name = name
    }
    
    static func getArray(from jsonArray: Any) -> [GetAllCategoriesResponce]? {

        guard let jsonArray = jsonArray as? Array<[String: Any]> else { return nil }
        var categories: [GetAllCategoriesResponce] = []

        for jsonObject in jsonArray {
            if let category = GetAllCategoriesResponce(json: jsonObject) {
                categories.append(category)
            }
        }
        return categories
    }
}
