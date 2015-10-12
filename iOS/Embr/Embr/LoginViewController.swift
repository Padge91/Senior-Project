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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "attemptLogin")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            resignFirstResponder()
            attemptLogin()
        }
        return true;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == passwordTextField {
            textField.text = ""
        }
    }
    
    func attemptLogin() {
        userDataSource.attemptLogin(usernameTextField.text!, password: passwordTextField.text!, completionHandler: loginCompletionHandler)
    }
    
    private func alertError(errorMessage error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    private func succesfulLogin(sessionId session: String) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.userDataSource.storeSession(sessionId: session)
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    func loginCompletionHandler (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void {
        if data != nil {
            do {
                let response = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                if let sessionResponse = response["success"], session = sessionResponse["session"] as? String {
                    succesfulLogin(sessionId: session)
                } else if let sessionResponse = response["error"] {
                    alertError(errorMessage: sessionResponse as? String ?? "Invalid session")
                }
            } catch {
                alertError(errorMessage: "Invalid response")
            }
        }
    }
    
}
