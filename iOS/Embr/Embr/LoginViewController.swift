import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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
        UserDataSource.attemptLogin(usernameTextField.text!, password: passwordTextField.text!, completionHandler: loginCompletionHandler)
    }
    
    private func alertError(errorMessage error: String) {
        let alert = UIAlertController(title: "Invalid Login", message: error, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    private func succesfulLogin(sessionId session: String) {
        dispatch_async(dispatch_get_main_queue()) {
            SessionModel.storeSession(sessionId: session)
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    func loginCompletionHandler (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void {
        if data != nil {
            do {
                let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                if jsonResponse["success"] as! Bool {
                    if let session = jsonResponse["response"] as? String {
                        succesfulLogin(sessionId: session)
                    }
                } else if let error = jsonResponse["response"] {
                    alertError(errorMessage: error as? String ?? "Invalid session")
                }
            } catch {
                alertError(errorMessage: "Invalid response")
            }
        }
    }
    
}
