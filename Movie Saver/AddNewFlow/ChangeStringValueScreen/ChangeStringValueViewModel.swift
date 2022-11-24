import Combine

final class ChangeStringValueViewModel {
    let valueSubject = CurrentValueSubject<String, Never>("")
}
