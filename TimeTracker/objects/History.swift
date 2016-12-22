import Foundation
import RealmSwift

class History: Object {
    var saveTime: String?
    var startDate: Date?
    var name: String?
    var endDate: Date?
    var duration: NSNumber?

}
