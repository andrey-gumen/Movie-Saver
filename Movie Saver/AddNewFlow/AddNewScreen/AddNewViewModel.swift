import Combine

final class AddNewViewModel {
    let movedFromParentSubject = PassthroughSubject<Void, Never>()
    let changeNameSubject = PassthroughSubject<Void, Never>()
    let changeRatingSubject = PassthroughSubject<Void, Never>()
    let changeReleaseDateSubject = PassthroughSubject<Void, Never>()
    let changeYoutubeLinkSubject = PassthroughSubject<Void, Never>()
}
