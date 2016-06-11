//
//  HeaderView.swift
//  TimeTracker
//


import UIKit

//Custom view for the tableView headers


class HeaderView: UIView {

    /**
    Initializes the view with given frame and title

    - parameter frame: frame to use
    - parameter title: title to set

    - returns: self
    */
    init(frame: CGRect, title: NSString) {
        super.init(frame: frame)
        addSubview(createLabelWithFrame(frame, title: title))
        backgroundColor = color.pink()
    }

    /**
    Init

    - parameter aDecoder: decoder

    - returns: self
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /**
    Creates a label with given frame and title

    - parameter frame: frame to use
    - parameter title: title to set

    - returns: created label
    */
    func createLabelWithFrame(frame: CGRect, title: NSString) -> UILabel {
        let titleLabel = UILabel(frame: frame)
        titleLabel.text = title as String
        titleLabel.textColor = .blackColor()
        titleLabel.textAlignment = .Left
        titleLabel.font = UIFont(name: "Avenir-Book", size: 16)
    

        return titleLabel
    }

}
