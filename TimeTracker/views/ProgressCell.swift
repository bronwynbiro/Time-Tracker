//
//  HistoryCell.swift
//  TimeTracker
//


import UIKit

/**
 Custom cell to display History objects' properties.
 */

class ProgressCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    /**
     Customize the look of the cell
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.textColor = UIColor.blackColor()
        percentLabel.textColor = UIColor.blackColor()
        timeLabel.textColor = UIColor.blackColor()
        backgroundColor = UIColor.whiteColor()
    }
    
}