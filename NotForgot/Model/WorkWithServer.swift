//
//  WorkWithServer.swift
//  NotForgot
//
//  Created by Разработчик on 06.04.2021.
//

import Foundation
import Alamofire

final class WorkWithServer{

    static let header: HTTPHeaders = [ "Accept" : "application/json"]
    static let key: String = "data"
    
    
    static func registerRequest(email: String,name: String,password: String,completion: @escaping (Bool)->Void){
        let param = SignUpRequest(email: email, name: name, password: password)
        let url = "http://practice.mobile.kreosoft.ru/api/register"
        AF.request(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default, headers: self.header ).validate().responseDecodable(of: SignUpResponce.self){
            responce in
            switch responce.result{
            case .success:
                if let emailTemp = responce.value?.email{
                    if let nameTemp = responce.value?.name{
                        if let idTemp = responce.value?.id{
                            if let api_tokenTemp = responce.value?.api_token{
                                self.saveUserData(email: emailTemp, name: nameTemp, id: idTemp, api_token: api_tokenTemp)
                                let flag = true
                                completion(flag)
                            }
                        }
                    }
                }
            case let .failure(error):
                print(error)
                let flag = false
                completion(flag)
            }
        }
    }
    
    static func saveUserData(email: String,name: String,id: Int,api_token: String){
        let ud = UserDefaults.standard
        let userData = UserData(email: email, name: name, id: id, api_token: api_token)
        do {
            try ud.setObject(userData, forKey: key)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    static func getApiToken() -> String{
        let ud = UserDefaults.standard
        do {
            let userData = try ud.getObject(forKey: key, castTo: UserData.self)
            return userData.api_token
        } catch {
            print(error.localizedDescription)
            return String()
        }
    }
    
    static func logInRequest(email: String,password: String,completion: @escaping (Bool)->Void){
        let param = SignInRequest(email: email, password: password)
        let url = "http://practice.mobile.kreosoft.ru/api/login"
  
        AF.request(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default, headers: self.header ).validate().responseDecodable(of: SignInResponce.self){
            responce in
            switch responce.result{
            case .success:
                if let api_token = responce.value?.api_token{
                    self.saveUserData(email: email, name: String(), id: Int(), api_token: api_token)
                    let flag = true
                    completion(flag)
                }
            case let .failure(error):
                print(error)
                let flag = false
                completion(flag)
            }
        }
    }

    static func getAllPrioritiesRequest(completion: @escaping ([GetAllPrioritiesResponce]) -> Void){
        let url = "http://practice.mobile.kreosoft.ru/api/priorities"
        
        let header: HTTPHeaders = [
            "accept":"application/json",
            "authorization":"Bearer " + self.getApiToken()
        ]
        AF.request(url, method: .get, headers: header).validate().responseJSON { responceJSON in
            switch responceJSON.result {
                case .success(let value):
                    guard let priorities = GetAllPrioritiesResponce.getArray(from: value) else { return }
                    completion(priorities)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    static func newCategoryRequest(name: String,completion: @escaping (GetAllCategoriesResponce) -> Void){
        let param = NewCategoryRequest(name: name)
        let url = "http://practice.mobile.kreosoft.ru/api/categories"
        let header: HTTPHeaders = [
            "accept":"application/json",
            "authorization":"Bearer " + self.getApiToken()
        ]
        
        AF.request(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default, headers: header ).validate().responseDecodable(of: NewCategoryResponce.self){
            responce in
            switch responce.result{
            case .success:
                guard let id = responce.value?.id,
                      let name = responce.value?.name else {
                    return
                }
                let temp = GetAllCategoriesResponce(id: id, name: name)
                print(temp)
                completion(temp)
            case let .failure(error):
                print(error)
            }
        }
        
    }
    
    static func getAllCategoriesResponce(completion: @escaping ([GetAllCategoriesResponce]) -> Void){
        let url = "http://practice.mobile.kreosoft.ru/api/categories"
        
        let header: HTTPHeaders = [
            "accept":"application/json",
            "authorization":"Bearer " + self.getApiToken()
        ]
        AF.request(url, method: .get, headers: header).validate().responseJSON { responceJSON in
            switch responceJSON.result {
                case .success(let value):
                    guard let categories = GetAllCategoriesResponce.getArray(from: value) else { return }
                    completion(categories)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    static func newTaskRequest(title: String,description: String,done: Int,deadline: Int,category_id: Int,priority_id:Int,completion: @escaping (Bool)->Void){
        let url = "http://practice.mobile.kreosoft.ru/api/tasks"
        let param = CreateTaskRequest(title: title, description: description, done: done, deadline: deadline, category_id: category_id, priority_id: priority_id)
        
        let header: HTTPHeaders = [
            "accept":"application/json",
            "authorization":"Bearer " + self.getApiToken()
        ]
        
        AF.request(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default, headers: header).validate().responseJSON { (responceJSON) in
            switch responceJSON.result{
            case .success:
                let flag = true
                completion(flag)
            case let .failure(error):
                let flag = false
                completion(flag)
                print(error)
            }
        }
    }
    
    static func getAllTasksResponce(completion: @escaping ([GetAllTasksResponce]) -> Void){
        let url = "http://practice.mobile.kreosoft.ru/api/tasks"
        
        let header: HTTPHeaders = [
            "accept":"application/json",
            "authorization":"Bearer " + self.getApiToken()
        ]
        
        AF.request(url,method: .get,headers: header).validate().responseJSON { responceJSON in
            switch responceJSON.result {
                case .success(let value):
                    guard let tasks = GetAllTasksResponce.getArray(from: value) else { return }
                    completion(tasks)
                case .failure(let error):
                    print(error)
                }
        }
        
    }
    
    static func removeTask(id: Int,completion: @escaping (Bool)->Void){
        let url = "http://practice.mobile.kreosoft.ru/api/tasks/\(id)"
        
        let header: HTTPHeaders = [
            "accept":"application/json",
            "authorization":"Bearer " + self.getApiToken()
        ]
        
        AF.request(url,method: .delete,headers: header).validate().response { (responce) in
            switch responce.result{
            case .success:
                let flag = true
                completion(flag)
            case let .failure(error):
                let flag = false
                print(error)
                completion(flag)
            }
        }
    }
    
    static func taskUpdating(id: Int,title: String,description: String,done: Int,deadline: Int,category_id: Int,priority_id:Int,completion: @escaping (Bool)->Void){
        let url = "http://practice.mobile.kreosoft.ru/api/tasks/\(id)"
        let param = CreateTaskRequest(title: title, description: description, done: done, deadline: deadline, category_id: category_id, priority_id: priority_id)
        
        let header: HTTPHeaders = [
            "accept":"application/json",
            "authorization":"Bearer " + self.getApiToken()
        ]
        
        AF.request(url, method: .patch, parameters: param, encoder: JSONParameterEncoder.default, headers: header).validate().response { (responce) in
            switch responce.result{
            case .success:
                let flag = true
                completion(flag)
            case let .failure(error):
                print(error)
                let flag = false
                completion(flag)
            }
        }
    }
}
