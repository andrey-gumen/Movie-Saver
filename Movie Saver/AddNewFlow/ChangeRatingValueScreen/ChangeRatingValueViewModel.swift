import Combine

final class ChangeRatingValueViewModel {
    let valueSubject = CurrentValueSubject<Float?, Never>(nil)
    
    init(_ value: Float?) {
        valueSubject.value = value
    }
}
