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
        //user.remove() Удалить данные для проверки регистрации
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if user.getEMail() != nil && user.getPassword() != nil{
            performSegue(withIdentifier: "goToListTask", sender: nil)
        }
    }

    @IBAction func createAccauntButton(_ sender: Any) {
        performSegue(withIdentifier: "goToSignUp", sender: nil)
    }
    
    @IBAction func signIn(_ sender: Any) {
        guard let email = self.emailTextField.text else{
            return
        }
        guard let password = self.passwordTextField.text else {
            return
        }
        if user.validateDate(email: email, password: password){
            performSegue(withIdentifier: "goToListTask", sender: nil)
        }else{
            let alertController = UIAlertController(title: "Предупреждение", message: "Введены неверные данные", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func unwindSegueToSignIn(for segue: UIStoryboardSegue){
        
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
