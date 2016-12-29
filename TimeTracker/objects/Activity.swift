import Foundation
import RealmSwift

class Activity: Object {
    dynamic var startDate: NSDate? = nil
    dynamic var endDate: NSDate? = nil
    dynamic var name: String? = nil
}
