import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate = self
        username.returnKeyType = .Next
        password.delegate = self
        password.returnKeyType = .Next
        password.secureTextEntry = true
        email.delegate = self
        email.returnKeyType = .Next
        confirmPassword.delegate = self
        confirmPassword.returnKeyType = .Done
        confirmPassword.secureTextEntry = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "signUp")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case username:
            email.becomeFirstResponder()
        case email:
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
        UserDataSource.signUp(username.text!, email: email.text!, password: password.text!, confirmPassword: confirmPassword.text!, completionHandler: signUpCompletionHandler)
    }
    
    func signUpCompletionHandler(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void {
        if data != nil {
            do {
                let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                if jsonResponse["success"] as! Bool {
                    dispatch_async(dispatch_get_main_queue()) {
                        UserDataSource.attemptLogin(self.username.text!, password: self.password.text!, completionHandler: self.loginCompletionHandler)
                    }
                } else {
                    let alertMessage = jsonResponse["response"] as? String
                    let alert = UIAlertController(title: "Invalid Sign Up", message: alertMessage, preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.addAction(cancelAction)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            } catch {}
        }
    }
    
    private func alertError(errorMessage error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
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
                } else {
                    alertError(errorMessage: jsonResponse["response"] as! String)
                }
            } catch {
                alertError(errorMessage: "Invalid response")
            }
        }
    }

}
