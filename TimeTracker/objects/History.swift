import Foundation
import CoreData

class History: NSManagedObject {
    
    var saveTime: String?
    var startDate: Date?
    var name: String?
    var endDate: Date?
    var duration: NSNumber?

}
