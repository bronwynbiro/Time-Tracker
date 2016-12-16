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
        borderStyle = .none
        placeholder = "Activity name"
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 16.0)
        minimumFontSize = 10
        autocorrectionType = .no
        autocapitalizationType = .none
        returnKeyType = .done
        contentVerticalAlignment = .center
        leftViewMode = .always
        leftView = self.leftViewForTextField()
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 2.0
        backgroundColor = UIColor.white
    }

    /**
    Adds a simple view to the textfield so that the text is not aligned to the left of the field

    - returns: UIView the view to add
    */
    func leftViewForTextField() -> UIView {
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        return leftView
    }

}
