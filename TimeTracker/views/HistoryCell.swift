//
//  HistoryCell.swift
//  TimeTracker
//


import UIKit

/**
    Custom cell to display History objects' properties.
*/

class HistoryCell: UITableViewCell {

    /// display the name of the history item
    @IBOutlet weak var nameLabel: UILabel!
    /// display the duration of the history item
    @IBOutlet weak var durationLabel: UILabel!
    /// display the end date of the history item
    @IBOutlet weak var timeLabel: UILabel!

    
    
    /**
        Customize the look of the cell
    */
    override func awakeFromNib() {
        super.awakeFromNib()

        nameLabel.textColor = UIColor.blackColor()
        durationLabel.textColor = UIColor.blackColor()
        timeLabel.textColor = UIColor.blackColor()
        backgroundColor = UIColor.whiteColor()
    }

    /**
    Toggles the receiver into and out of editing mode. When YES, hide the durationLabel with animation.

    - parameter editing:  YES to enter editing mode, NO to leave it. The default value is NO
    - parameter animated: YES to animate the appearance or disappearance of the insertion/deletion control and the reordering control, NO to make the transition immediate.
    */
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing == true {
            durationLabel.alpha = 0
        } else {
            durationLabel.alpha = 1
        }
    }

}
