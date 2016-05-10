//
//  GlobalColors.swift
//  TimeTracker
//

import Foundation
import UIKit

/**
    Have all colors in one separate class
*/
extension UIColor {}
struct color {
    static func blue() ->UIColor {
        return UIColor(red: 130/255, green: 159/255, blue: 252/255, alpha: 1)
    }
    static func purple() -> UIColor {
        return UIColor(red: 190/255, green: 128/255, blue: 253/255, alpha: 1)
    }
    static func pink() -> UIColor {
        return UIColor(red: 240/255, green: 152/255, blue: 214/255, alpha: 1)
    }
}



//////
/*

extension UIColor {

    class func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }

    /**
      Color of navigation bar
    - returns: UIColor color to use
    */
    
    //light blue 
    class func navigationBarColor() -> UIColor {
        return UIColor(red: 65/255, green: 186/255, blue: 252/255, alpha: 0.9700000286102295)}
 }
    /**
      Color of view background
    - returns: UIColor color to use
    */

    class func backgroundColor() -> UIColor { return rgbColor(217, green: 87, blue: 43) }
    /**
      Color of tableView background
    - returns: UIColor color to use
    */
    class func tableViewBackgroundColor() -> UIColor { return rgbColor(242, green: 157, blue: 73) }
    /**
      Color of cell background
    - returns: UIColor color to use
    */
    class func cellBackgroundColor() -> UIColor { return rgbColor(242, green: 182, blue: 121) }
    /**
      Color of activity cell label
    - returns: UIColor color to use
    */
    class func activityCellLabelColor() -> UIColor { return rgbColor(102, green: 41, blue: 20) }
    /**
      Color of tableView separator
    - returns: UIColor color to use
    */
    class func tableViewSeparatorColor() -> UIColor { return rgbColor(204, green: 133, blue: 61) }
    /**
      Color of tableView headerView background
    - returns: UIColor color to use
    */
    class func tableViewHeaderViewBackgroundColor() -> UIColor { return navigationBarColor() }

    // Mark - new activity view colors
    /**
      Color of activity view's background
    - returns: UIColor color to use
    */
    class func activityViewBackgroundColor() -> UIColor { return rgbColor(155, green: 62, blue: 31) }
    /**
      Color of activity textfield background
    - returns: UIColor color to use
    */
    class func activityTextFieldBackgroundColor() -> UIColor { return rgbColor(128, green: 51, blue: 26) }
    /**
      Color of activity textfield stroke
    - returns: UIColor color to use
    */
    class func activityTextFieldStrokeColor() -> UIColor { return backgroundColor() }
    /**
      Color of activity textfield's placeholder text
    - returns: UIColor color to use
    */
    class func activityTextFieldPlaceHolderColor() -> UIColor { return activityViewBackgroundColor() }

    // Mark - history cell colors
    /**
      Color of duration label
    - returns: UIColor color to use
    */
    class func durationLabelColor() -> UIColor { return activityViewBackgroundColor() }
    /**
      Color of title label
    - returns: UIColor color to use
    */
    class func titleLabelColor() -> UIColor { return activityCellLabelColor() }
    /**
      Color of timeframe label
    - returns: UIColor color to use
    */
    class func timeframeLabelColor() -> UIColor { return durationLabelColor() } 
}
  */