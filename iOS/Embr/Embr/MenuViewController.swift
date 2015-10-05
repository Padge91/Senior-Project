import UIKit

class MenuViewController: UITableViewController {
    private let loginSegueIdentifier = "segueToLogin"
    private let signUpSegueIdentifier = "segueToSignUp"
    private let settingsSegueIdentifier = "segueToSettings"
    var menu = ["Login", "Logout", "Sign Up", "Settings"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = nil
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
        case menu.indexOf("Login")!:
            performSegueWithIdentifier(loginSegueIdentifier, sender: nil)
        case menu.indexOf("Logout")!:
            confirmLogout()
        case menu.indexOf("Sign Up")!:
            performSegueWithIdentifier(signUpSegueIdentifier, sender: nil)
        case menu.indexOf("Settings")!:
            performSegueWithIdentifier(settingsSegueIdentifier, sender: nil)
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
        // Perform logout
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
}