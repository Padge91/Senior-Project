import UIKit

public class CreateCommentViewController : UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var mediaItem: MediaItem?
    var parentComment: Comment?
    private let placeholderText = "Write a comment..."
    @IBOutlet weak var mediaItemTitle: UILabel!
    @IBOutlet weak var body: UITextView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if mediaItem != nil {
            mediaItemTitle.text = mediaItem!.title
        } else {
            let truncateIndex = parentComment!.body.startIndex.advancedBy(10)
            mediaItemTitle.text = parentComment!.body.substringToIndex(truncateIndex)
        }
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
        var parentType: CommentParentType
        var parentId: Int
        if mediaItem != nil {
            parentType = CommentParentType.Item
            parentId = mediaItem!.id
        } else {
            parentType = CommentParentType.Comment
            parentId = parentComment!.id
        }
        CommentsDataSource.insertComment(parentType, parentId: parentId, body: body.text)
        navigationController?.popToRootViewControllerAnimated(true)
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