import Combine

final class ChangeStringValueViewModel {
    let valueSubject = CurrentValueSubject<String?, Never>(nil)
    
    init(_ value: String?) {
        valueSubject.value = value
    }
}
