//
//  SignUpViewController.swift
//  NotForgot
//
//  Created by Разработчик on 31.03.2021.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordValidateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customizeAllTextField()
    }
    
    private func customizeAllTextField(){
        customizeTextField(object: emailTextField)
        customizeTextField(object: firstNameTextField)
        customizeTextField(object: lastNameTextField)
        customizeTextField(object: passwordTextField)
        customizeTextField(object: passwordValidateTextField)
        
        passwordTextField.isSecureTextEntry = true
        passwordValidateTextField.isSecureTextEntry = true
        emailTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        passwordTextField.delegate = self
        passwordValidateTextField.delegate = self
    }
    private func customizeTextField(object: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: object.frame.height - 1, width: object.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        object.borderStyle = .none
        object.layer.addSublayer(bottomLine)
    }
}

extension SignUpViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}
