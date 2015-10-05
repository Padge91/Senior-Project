//
//  LoginViewController.swift
//  Embr
//
//  Created by Alex Ronquillo on 10/3/15.
//  Copyright © 2015 SeniorProject. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let userDataSource = UserDataSource.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        usernameTextField.returnKeyType = UIReturnKeyType.Next
        passwordTextField.delegate = self
        passwordTextField.secureTextEntry = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            userDataSource.attemptLogin(usernameTextField.text!, password: passwordTextField.text!)
        }
        return true;
    }
    
}
