//
//  SignUpViewController.swift
//  NotForgot
//
//  Created by Разработчик on 31.03.2021.
//

import UIKit
import Alamofire
import Loaf

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordValidateTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeAllTextField()
        dismissKeyboard()
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

    
    @IBAction func CreateUserAccountAndSignIn(_ sender: UICustomButton) {
        guard let firstName = firstNameTextField.text else{
            return
        }
        guard let lastName = lastNameTextField.text else{
            return
        }
        guard let email = emailTextField.text else{
            return
        }
        guard let password = passwordTextField.text else{
            return
        }
        guard let passwordValidate = passwordValidateTextField.text else{
            return
        }
        if email.isValidEmail() == false{
            showAlert(message: "Введите почтовый ящик")
        }else{
            if password != passwordValidate{
                showAlert(message: "Пароли не совпадаютс")
            }else{
                if firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || passwordValidate.isEmpty{
                    showAlert(message: "Не все поля заполнены")
                } else{
                    WorkWithServer.registerRequest(email: email, name: firstName+" "+lastName, password: password) { [weak self] flag in
                        guard let self = self else {return}
                        DispatchQueue.main.async {
                            if flag{
                                Loaf("Регистрация успешна", state: .success, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
                                self.performSegue(withIdentifier: "goBackSignIn", sender: nil)
                            }else{
                                Loaf("Ошибка регистрации", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func showAlert(message: String){
        let alertController = UIAlertController(title: "Предупреждение", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func goBackSignIn(_ sender: Any) {
        self.performSegue(withIdentifier: "goBackSignIn", sender: nil)
    }
}



//MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.emailTextField{
            if let text = textField.text{
                if text.isValidEmail() == false{
                    Loaf("Неправильный почтовый ящик", state: .warning, location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
                }
            }
        }
        
        if textField == self.passwordValidateTextField{
            if let text = textField.text{
                if text != self.passwordTextField.text{
                    Loaf("Пароли не совпадают", state: .warning, location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
                    self.passwordValidateTextField.text = ""
                }
            }
        }
    }
}
