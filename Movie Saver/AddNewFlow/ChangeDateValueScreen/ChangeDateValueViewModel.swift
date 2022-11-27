import Combine
import Foundation

final class ChangeDateValueViewModel {
    let valueSubject = CurrentValueSubject<Date?, Never>(nil)
    
    init(_ value: Date?) {
        valueSubject.value = value
    }
}
