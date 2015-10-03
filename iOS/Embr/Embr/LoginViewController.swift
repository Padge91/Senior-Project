//
//  LoginViewController.swift
//  Embr
//
//  Created by Alex Ronquillo on 10/3/15.
//  Copyright © 2015 SeniorProject. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.secureTextEntry = true
    }
    
}
