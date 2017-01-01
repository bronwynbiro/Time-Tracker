import UIKit


class HistoryCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    
    
    /**
        Customize the look of the cell
    */
    override func awakeFromNib() {
        super.awakeFromNib()

        nameLabel.textColor = UIColor.black
        durationLabel.textColor = UIColor.black
        timeLabel.textColor = UIColor.black
        backgroundColor = UIColor.white
    }

    /**
    Toggles the receiver into and out of editing mode. When YES, hide the durationLabel with animation.

    - parameter editing:  YES to enter editing mode, NO to leave it. The default value is NO
    - parameter animated: YES to animate the appearance or disappearance of the insertion/deletion control and the reordering control, NO to make the transition immediate.
    */
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing == true {
            durationLabel.alpha = 0
        } else {
            durationLabel.alpha = 1
        }
    }

}
