import UIKit

class DefaultNavigationController: UINavigationController {

    /**
        The preferred status bar style for the view controller.

        - returns: UIStatusBarStyle the statusbar style
    */
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    /**
        Prepares the receiver for service after it has been loaded from an Interface Builder archive, or nib file.
        Sets the navigation bar and buttons according to iOS system
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        navigationBar.tintColor = UIColor.white
        navigationBar.barTintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        view.backgroundColor = color.pink()
    }

}
