import UIKit

public class CreateCommentViewController : UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    private let placeholderText = "Write a comment..."
    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var body: UITextView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupSubject()
        setupBody()
        setupNavigationBar()
    }
    
    private func setupSubject() {
        subject.delegate = self
        subject.returnKeyType = UIReturnKeyType.Next
    }
    
    private func setupBody() {
        body.delegate = self
        body.text = placeholderText
        body.textColor = UIColor.lightGrayColor()
    }
    
    private func setupNavigationBar() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "submitComment")
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func submitComment() {
        // Submit the comment
        navigationController?.popViewControllerAnimated(true)
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        body.becomeFirstResponder()
        return true
    }
    
    public func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        textView.becomeFirstResponder()
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = placeholderText
            textView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
}