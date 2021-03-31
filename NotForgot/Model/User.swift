//
//  User.swift
//  NotForgot
//
//  Created by Разработчик on 31.03.2021.
//

import Foundation

class User{
    
    var userDefaults = UserDefaults.standard
    
    public func remove(){
        self.userDefaults.removeObject(forKey: "firstname")
        self.userDefaults.removeObject(forKey: "lastName")
        self.userDefaults.removeObject(forKey: "email")
        self.userDefaults.removeObject(forKey: "password")
    }
    
    public func setFirstName(firstname: String){
        self.userDefaults.setValue(firstname, forKey: "firstname")
    }
    public func setLastName(lastName: String){
        self.userDefaults.setValue(lastName, forKey: "lastName")
    }
    public func setEMail(email: String){
        self.userDefaults.setValue(email, forKey: "email")
    }
    public func setPassword(password: String){
        self.userDefaults.setValue(password, forKey: "password")
    }
    
    public func getEMail() -> String?{
        if let email = self.userDefaults.object(forKey: "email"){
            return email as? String
        }
        return nil
    }
    
    public func getPassword() -> String?{
        if let password = self.userDefaults.object(forKey: "password"){
            return password as? String
        }
        return nil
    }
    public func validateEMail(Email target: String) -> Bool{
        return target.isValidEmail()
    }
    
    public func validateDate(email: String,password: String) -> Bool{
        if email == self.getEMail() && password == self.getPassword(){
            return true
        }
        return false
    }
}
extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let pattern = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
