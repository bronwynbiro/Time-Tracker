//
//  NewActivityView.swift
//  TimeTracker
//


import UIKit

/**
    Delegate protocol.
*/
protocol NewActivityDelegate {
    /**
        Delegate method to tell the view controller that an activity has been saved.
    */
    func slideActivityViewUp()
}

/**
    A view to add new activities.
*/

class NewActivityView: UIView, UITextFieldDelegate {

    var textField: ActivityTextfield = ActivityTextfield()

    var delegate: NewActivityDelegate?

    /**
    Custom initaliser

    - parameter frame:    frame
    - parameter delegate: delegate

    - returns: self
    */
    init(frame: CGRect, delegate: NewActivityDelegate) {
        let label = UILabel()
        label.frame = CGRectMake(10.0, 10.0, CGRectGetWidth(frame)-20.0, 40.0)
        label.text = "Enter the name of your activity"
        label.textColor = color.blue()
        label.textAlignment = .Center
        label.backgroundColor = UIColor.clearColor()
        label.font = UIFont.boldSystemFontOfSize(14.0)
        label.numberOfLines = 0

        self.textField = ActivityTextfield()
        self.textField.frame = CGRectMake(10.0, CGRectGetHeight(frame) - 40.0, CGRectGetWidth(label.frame), 30.0)

        self.delegate = delegate
        super.init(frame: frame)

        self.textField.delegate = self
        self.addSubview(self.textField)
        self.addSubview(label)

        backgroundColor = UIColor.whiteColor()
        layer.cornerRadius = 2.0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /**
        Save an activity to core data if it is not already in the core data or not null.
    */
    func saveItem() {
        let activityName = textField.text
        if activityName?.characters.count == 0 {
            textField.text = ""
            slideViewUp()
        } else {
            if CoreDataHandler.sharedInstance.isDuplicate(activityName!) == true {
                let alertView = UIAlertView(title: "Duplicate", message: "This activity is already in your activity list.", delegate: nil, cancelButtonTitle: "Ok")
                alertView.show()
            } else {
                CoreDataHandler.sharedInstance.addNewActivityName(activityName!)

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

        UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.frame = frame
            }) { (finished) -> Void in
                self.textField.becomeFirstResponder()
        }
    }

    /**
        Slide the view up with animation and make the textfield inactive.
    */
    func slideViewUp() {
        var frame = self.frame
        frame.origin.y = -100

        UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.frame = frame
            }) { (finished) -> Void in
                self.textField.resignFirstResponder()
        }
    }

    /**
        Asks the delegate if the text field should process the pressing of the return button. Animate the view back up and save the item to core data if possible.
    - param textField The text field whose return button was pressed.
    - return BOOL YES if the text field should implement its default behavior for the return button; otherwise, NO.
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        saveItem()
        return true
    }

}
