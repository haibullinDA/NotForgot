//
//  ViewController.swift
//  NotForgot
//
//  Created by Разработчик on 30.03.2021.
//

import UIKit
import Alamofire
import Loaf

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeAllTextField()
        dismissKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let ud = UserDefaults.standard
        do {
            let _ = try ud.getObject(forKey: WorkWithServer.key, castTo: UserData.self)
            performSegue(withIdentifier: "goToListTask", sender: nil)
        } catch {
            print(error.localizedDescription)
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
        WorkWithServer.logInRequest(email: email, password: password) { [weak self] flag in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if flag {
                    self.performSegue(withIdentifier: "goToListTask", sender: nil)
                }else{
                    let alertController = UIAlertController(title: "Предупреждение", message: "Введены неверные данные", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func customizeAllTextField(){
        customizeTextField(object: emailTextField)
        customizeTextField(object: passwordTextField)
        passwordTextField.isSecureTextEntry = true
    }
    
    private func customizeTextField(object: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: object.frame.height - 1, width: object.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        object.borderStyle = .none
        object.layer.addSublayer(bottomLine)
    }
    
    @IBAction func unwindSegueToSignIn(for segue: UIStoryboardSegue){}
    @IBAction func unwindSegueExit(for segue: UIStoryboardSegue){}
}

