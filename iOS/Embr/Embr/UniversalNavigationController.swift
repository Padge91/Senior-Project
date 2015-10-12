import UIKit

class UniversalNavigationController: UINavigationController {
    let librariesSegueIdentifier = "segueToLibraries"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let librariesButton = UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: self, action: nil)
        toolbarItems!.append(librariesButton)        
    }

    func navigateToLibraries() {
        performSegueWithIdentifier(librariesSegueIdentifier, sender: nil)
    }
}