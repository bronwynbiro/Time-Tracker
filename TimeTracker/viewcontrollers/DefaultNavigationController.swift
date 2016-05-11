//
//  DefaultNavigationController.swift
//  TimeTracker
//


import UIKit

/** 
    Custom navigation controller so that we could customise it
*/

class DefaultNavigationController: UINavigationController {

    /**
        The preferred status bar style for the view controller.

        - returns: UIStatusBarStyle the statusbar style
    */
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    /**
        Prepares the receiver for service after it has been loaded from an Interface Builder archive, or nib file.
        Sets the navigation bar and buttons according to iOS system
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.barTintColor = UIColor.whiteColor()
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        view.backgroundColor = color.pink()
    }

}
