//
//  User.swift
//  NotForgot
//
//  Created by Разработчик on 31.03.2021.
//

import Foundation

class User{
    
    private var firstName: String
    private var lastName: String
    private var email: String
    private var password: String
    var userDefaults = UserDefaults.standard
    
    init(){
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.password = ""
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
        return ""
    }
    
    public func getPassword() -> String?{
        if let password = self.userDefaults.object(forKey: "password"){
            return password as? String
        }
        return ""
    }
    public func validateEMail(Email target: String) -> Bool{
        return target.isValidEmail()
    }
    
    public func validatePassword(target: String) -> Bool{
        if self.password == target{
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
