import Combine

final class ChangeStringValueViewModel {
    let valueSubject = CurrentValueSubject<String, Never>("")
    
    init(_ value: String) {
        valueSubject.value = value
    }
}
