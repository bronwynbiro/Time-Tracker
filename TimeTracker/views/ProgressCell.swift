import UIKit

class ProgressCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.textColor = UIColor.black
        percentLabel.textColor = UIColor.black
        timeLabel.textColor = UIColor.black
        backgroundColor = UIColor.white
    }
    
}
