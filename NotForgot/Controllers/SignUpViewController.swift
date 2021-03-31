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
    var user = User()
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goBackSignIn" {
            if let vc = segue.destination as? SignInViewController{
                if let param = sender as? [String]{
                    vc.emailTextField.text = param[0]
                    vc.passwordTextField.text = param[1]
                }
            }
        }
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
      
        if firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || passwordValidate.isEmpty{
            let alertController = UIAlertController(title: "Предупреждение", message: "Не все поля заполнены", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        } else{
            user.setFirstName(firstname: firstName)
            user.setLastName(lastName: lastName)
            user.setEMail(email: email)
            user.setPassword(password: password)
            print("Данные записаны")
            self.performSegue(withIdentifier: "goBackSignIn", sender: [email,password])
        }
    }
    
    @IBAction func goBackSignIn(_ sender: Any) {
        self.performSegue(withIdentifier: "goBackSignIn", sender: nil)
    }
}



//MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate{
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == self.emailTextField{
            if let text = textField.text{
                if User().validateEMail(Email: text) == false{
                    let alertController = UIAlertController(title: "Предупреждение", message: "Введите почтовый ящик", preferredStyle: .actionSheet)
                    let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                    textField.resignFirstResponder()
                    return true
                }
            }
        }
        if textField == self.passwordValidateTextField{
            if let text = textField.text{
                if text != self.passwordTextField.text{
                    let alertController = UIAlertController(title: "Предупреждение", message: "Пароли не совпадают", preferredStyle: .actionSheet)
                    let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                    textField.resignFirstResponder()
                    return true
                }
            }
        }
        textField.resignFirstResponder()
        return true
    }
    
}
