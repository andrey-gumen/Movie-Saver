import Combine
import Foundation

protocol AddNewMovieViewModelInputs {
    var nameSubject: any Subject<String?, Never> { get }
    var ratingSubject: any Subject<Float?, Never> { get }
    var releaseDateSubject: any Subject<Date?, Never>{ get }
    var youtubeLinkSubject: any Subject<String?, Never> { get }
}

protocol AddNewMovieViewModelOutputs {
    var movedFromParentSubject: any Subject<Void, Never> { get }
    var saveMovieSubject: any Subject<Movie, Never> { get }
    
    var nameSubject: any Subject<String?, Never> { get }
    var ratingSubject: any Subject<Float?, Never> { get }
    var releaseDateSubject: any Subject<Date?, Never>{ get }
    var youtubeLinkSubject: any Subject<String?, Never> { get }
}

final class AddNewMovieViewModel {
    
    let inputs: AddNewMovieViewModelInputs = Inputs()
    let outputs: AddNewMovieViewModelOutputs = Outputs()
    
    private var cancellables: Set<AnyCancellable> = []
    init() {
        outputs.saveMovieSubject
            .sink { CoreDataManager.instance.save(movie: $0) }
            .store(in: &cancellables)
    }
    
    private struct Inputs: AddNewMovieViewModelInputs {
        let nameSubject: any Subject<String?, Never> = PassthroughSubject<String?, Never>()
        let ratingSubject: any Subject<Float?, Never> = PassthroughSubject<Float?, Never>()
        let releaseDateSubject: any Subject<Date?, Never> = PassthroughSubject<Date?, Never>()
        let youtubeLinkSubject: any Subject<String?, Never> = PassthroughSubject<String?, Never>()
    }

    private struct Outputs: AddNewMovieViewModelOutputs {
        let movedFromParentSubject: any Subject<Void, Never> = PassthroughSubject<Void, Never>()
        let saveMovieSubject: any Subject<Movie, Never> = PassthroughSubject<Movie, Never>()
        
        let nameSubject: any Subject<String?, Never> = PassthroughSubject<String?, Never>()
        let ratingSubject: any Subject<Float?, Never> = PassthroughSubject<Float?, Never>()
        let releaseDateSubject: any Subject<Date?, Never> = PassthroughSubject<Date?, Never>()
        let youtubeLinkSubject: any Subject<String?, Never> = PassthroughSubject<String?, Never>()
    }
    
}
