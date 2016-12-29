import Foundation
import RealmSwift

class History: Object {
    dynamic var saveTime: String? = nil
    dynamic var startDate: NSDate? = nil
    dynamic var name: String? = nil
    dynamic var endDate: NSDate? = nil
    dynamic var duration: Double = 0.0
    //var duration = RealmOptional<Double>()
    //let duration = RealmOptional<Int>()

}
