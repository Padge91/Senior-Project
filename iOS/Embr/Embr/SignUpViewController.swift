//
//  SignUpViewController.swift
//  Embr
//
//  Created by Alex Ronquillo on 10/7/15.
//  Copyright © 2015 SeniorProject. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate = self
        username.returnKeyType = .Next
        password.delegate = self
        password.returnKeyType = .Next
        confirmPassword.delegate = self
        confirmPassword.returnKeyType = .Done
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "signUp")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case username:
            password.becomeFirstResponder()
        case password:
            confirmPassword.becomeFirstResponder()
        case confirmPassword:
            signUp()
        default:
            return false
        }
        return true
    }
    
    func signUp() {
        if validateFields() {
            if passwordsMatch() {
                if passwordsAreStrong() {
                    // Todo: Attempt sign up
                    navigationController?.popViewControllerAnimated(true)
                } else {
                    let weakPasswordAlert = UIAlertController(title: "Weak Password", message: "Your password must be at least 9 characters long.", preferredStyle: .Alert)
                    weakPasswordAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(weakPasswordAlert, animated: true, completion: nil)
                }
            } else {
                let mismatchedPasswordAlert = UIAlertController(title: "Password Mismatch", message: "The passwords you entered do not match.", preferredStyle: .Alert)
                mismatchedPasswordAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                presentViewController(mismatchedPasswordAlert, animated: true, completion: nil)
            }
        } else {
            let validationAlert = UIAlertController(title: "Empty Fields", message: "You must enter a username, password, and confirmation password.", preferredStyle: .Alert)
            validationAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(validationAlert, animated: true, completion: nil)
        }
    }
    
    private func validateFields() -> Bool {
        return username.text! != "" && password.text! != "" && confirmPassword.text! != ""
    }
    
    private func passwordsMatch() -> Bool {
        if let pass1 = password.text {
            if let pass2 = confirmPassword.text {
                return pass1 == pass2
            }
        }
        return false
    }
    
    private func passwordsAreStrong() -> Bool {
        let minPasswordLength = 9
        if let password = self.password.text {
            // Todo: Check password strength
            return password.characters.count >= minPasswordLength
        }
        return false
    }

}
