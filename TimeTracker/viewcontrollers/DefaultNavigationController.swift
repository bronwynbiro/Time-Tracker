import UIKit

class DefaultNavigationController: UINavigationController {

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        navigationBar.tintColor = UIColor.white
        navigationBar.barTintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        view.backgroundColor = color.pink()
    }

}
