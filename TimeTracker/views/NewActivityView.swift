import UIKit
import CoreData


protocol NewActivityDelegate {
    func slideActivityViewUp()
}

class NewActivityView: UIView, UITextFieldDelegate {

    var textField: ActivityTextfield = ActivityTextfield()
    var delegate: NewActivityDelegate?


    init(frame: CGRect, delegate: NewActivityDelegate) {
        let label = UILabel()
        label.frame = CGRect(x: 10.0, y: 10.0, width: frame.width-20.0, height: 40.0)
        label.text = "Enter the name of your activity"
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.numberOfLines = 0

        self.textField = ActivityTextfield()
        self.textField.frame = CGRect(x: 10.0, y: frame.height - 40.0, width: label.frame.width, height: 30.0)

        self.delegate = delegate
        super.init(frame: frame)

        self.textField.delegate = self
        self.addSubview(self.textField)
        self.addSubview(label)

        backgroundColor = UIColor.white
        layer.cornerRadius = 2.0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

   
    func saveItem() {
        let activityName = textField.text
        if activityName?.characters.count == 0 {
            textField.text = ""
            slideViewUp()
        } else {
            if DataHandler.sharedInstance.isDuplicate(activityName: activityName!) == true {
                let alertView = UIAlertView(title: "Duplicate", message: "This activity is already in your activity list.", delegate: nil, cancelButtonTitle: "Ok")
                alertView.show()
            } else {
                DataHandler.sharedInstance.addNewActivityName(name: activityName!)

                textField.text = ""
                slideViewUp()
                delegate?.slideActivityViewUp()
            }
        }
    }

    /**
        Slide the view down with animation and make the textfield active.
    */
    func slideViewDown() {
        var frame = self.frame
        frame.origin.y = -10

        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.frame = frame
            }, completion: { (finished) -> Void in
                self.textField.becomeFirstResponder()
        }) 
    }

    /**
        Slide the view up with animation and make the textfield inactive.
    */
    func slideViewUp() {
        var frame = self.frame
        frame.origin.y = -100

        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.frame = frame
            }, completion: { (finished) -> Void in
                self.textField.resignFirstResponder()
        }) 
    }

    /**
        Asks the delegate if the text field should process the pressing of the return button. Animate the view back up and save the item to core data if possible.
    - param textField The text field whose return button was pressed.
    - return BOOL YES if the text field should implement its default behavior for the return button; otherwise, NO.
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveItem()
        return true
    }

}
