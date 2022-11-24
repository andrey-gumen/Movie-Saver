import Combine
import Foundation

final class AddNewViewModel {
    // outputs
    let movedFromParentSubject = PassthroughSubject<Void, Never>()
    let changeNameSubject = PassthroughSubject<Void, Never>()
    let changeRatingSubject = PassthroughSubject<Void, Never>()
    let changeReleaseDateSubject = PassthroughSubject<Void, Never>()
    let changeYoutubeLinkSubject = PassthroughSubject<Void, Never>()
    
    // unputs
    let nameValueSubject = PassthroughSubject<String, Never>()
    let ratingValueSubject = PassthroughSubject<Float, Never>()
    let releaseDateValueSubject = PassthroughSubject<Date, Never>()
    let youtubeLinkValueSubject = PassthroughSubject<String, Never>()
}
