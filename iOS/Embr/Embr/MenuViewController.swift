import UIKit

class MenuViewController: UITableViewController {
    private let loginSegueIdentifier = "segueToLogin"
    private let signUpSegueIdentifier = "segueToSignUp"
    private let settingsSegueIdentifier = "segueToSettings"
    private let loginString = "Login"
    private let logoutString = "Logout"
    private let signUpString = "SignUp"
    var menu = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = nil
        menu = [loginString, logoutString, signUpString]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cellId"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        
        cell!.textLabel!.text = menu[indexPath.row]
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case menu.indexOf(loginString)!:
            performSegueWithIdentifier(loginSegueIdentifier, sender: nil)
        case menu.indexOf(logoutString)!:
            confirmLogout()
        case menu.indexOf(signUpString)!:
            performSegueWithIdentifier(signUpSegueIdentifier, sender: nil)
        default:
            break;
        }
    }
    
    func confirmLogout() {
        let logoutConfirmationAlert = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .Alert)
        let yesAction = UIAlertAction(title: "Yes", style: .Default, handler: logout)
        let noAction = UIAlertAction(title: "No", style: .Default, handler: nil)
        logoutConfirmationAlert.addAction(yesAction)
        logoutConfirmationAlert.addAction(noAction)
        presentViewController(logoutConfirmationAlert, animated: true, completion: nil)
    }
    
    func logout(action: UIAlertAction) {
        UserDataSource.getInstance().removeSession()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
}