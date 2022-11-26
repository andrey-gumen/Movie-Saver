import Combine
import Foundation

protocol AddNewMovieViewModelInput {
    var movedFromParentSubject: PassthroughSubject<Void, Never> { get }
}

protocol AddNewMoviewViewModelOutput {
    
}

final class AddNewMovieViewModel {
    // outputs
    let movedFromParentSubject = PassthroughSubject<Void, Never>()
    let changeNameSubject = PassthroughSubject<String, Never>()
    let changeRatingSubject = PassthroughSubject<Void, Never>()
    let changeReleaseDateSubject = PassthroughSubject<Void, Never>()
    let changeYoutubeLinkSubject = PassthroughSubject<Void, Never>()
    
    // unputs
    let nameValueSubject = PassthroughSubject<String, Never>()
    let ratingValueSubject = PassthroughSubject<Float, Never>()
    let releaseDateValueSubject = PassthroughSubject<Date, Never>()
    let youtubeLinkValueSubject = PassthroughSubject<String, Never>()
}
