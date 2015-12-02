import UIKit

let copyright = "The information and images are protected under the GNU free documentation license provided by wikipedia"

func alertError(controller: UIViewController, errorMessage error: String) {
    let alert = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    dispatch_async(dispatch_get_main_queue()){
        controller.presentViewController(alert, animated: true, completion: nil)
    }
}

func printError(errorHeader: String, errorMessage: String) {
    print("\(errorHeader)\n\(errorMessage)")
}

func succesfulLogin(sessionId session: String) {
    dispatch_async(dispatch_get_main_queue()) {
        SessionModel.storeSession(sessionId: session)
    }
}

func displayLoginAlert(controller: UIViewController, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
    let alert = UIAlertController(title: "Login", message: "Login to view your libraries:", preferredStyle: .Alert)
    alert.addTextFieldWithConfigurationHandler({(textfield: UITextField) in textfield.placeholder = "Username"})
    alert.addTextFieldWithConfigurationHandler({(textfield: UITextField) in
        textfield.secureTextEntry = true
        textfield.placeholder = "Password"
    })
    let loginAction = UIAlertAction(title: "Login", style: .Default, handler: {(action: UIAlertAction) in
        if let username = alert.textFields![0].text, password = alert.textFields![1].text {
            UserDataSource.attemptLogin(username, password: password, completionHandler: completionHandler)
        }
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    alert.addAction(loginAction)
    alert.addAction(cancelAction)
    controller.presentViewController(alert, animated: true, completion: nil)
}