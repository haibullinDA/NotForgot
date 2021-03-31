//
//  ViewController.swift
//  NotForgot
//
//  Created by Разработчик on 30.03.2021.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let user = User()
    
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeAllTextField()
        if let temp = user.getEMail(){
            print(temp)
        }
        
        if let temp = user.getPassword(){
            print(temp)
        }

        // Do any additional setup after loading the view.
    }

    private func customizeAllTextField(){
        customizeTextField(object: emailTextField)
        customizeTextField(object: passwordTextField)
        passwordTextField.isSecureTextEntry = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    private func customizeTextField(object: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: object.frame.height - 1, width: object.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        object.borderStyle = .none
        object.layer.addSublayer(bottomLine)
    }

}

//MARK: - UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate{

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }// return NO to not change text

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }// called when clear button pressed. return NO to ignore (no notifications)

    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    } // called when 'return' key pressed. return NO to ignore.
}
