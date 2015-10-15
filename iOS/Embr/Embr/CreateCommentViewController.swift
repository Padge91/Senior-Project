import UIKit

public class CreateCommentViewController : UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var mediaItem: MediaItem?
    private let placeholderText = "Write a comment..."
    @IBOutlet weak var mediaItemTitle: UILabel!
    @IBOutlet weak var body: UITextView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        assert(mediaItem != nil)
        mediaItemTitle.text = mediaItem!.title
        setupBody()
        setupNavigationBar()
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