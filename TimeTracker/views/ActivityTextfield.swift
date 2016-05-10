//
//  ActivityTextfield.swift
//  TimeTracker
//

import UIKit

/**
    Custom textfield class to display a custom textfield.
*/

class ActivityTextfield: UITextField {

    /**
    Init method

    - parameter frame: frame to set

    - returns: self
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    /**
    Init method

    - parameter aDecoder: decoder

    - returns: self
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    /**
        Customize the look of the textfield.
    */
    func setupView() {
        borderStyle = .None
        placeholder = "Activity name"
        textAlignment = .Center
        font = UIFont.systemFontOfSize(16.0)
        minimumFontSize = 10
        autocorrectionType = .No
        autocapitalizationType = .None
        returnKeyType = .Done
        contentVerticalAlignment = .Center
        leftViewMode = .Always
        leftView = self.leftViewForTextField()

        layer.borderColor = color.purple().CGColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 2.0
        backgroundColor = color.pink()
    }

    /**
    Adds a simple view to the textfield so that the text is not aligned to the left of the field

    - returns: UIView the view to add
    */
    func leftViewForTextField() -> UIView {
        let leftView = UIView(frame: CGRectMake(0.0, 0.0, 10.0, 0.0))
        return leftView
    }

}
