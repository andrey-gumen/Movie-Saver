import Combine
import Foundation

final class MainListViewModel {
    
    let inputs = Inputs()
    var outputs = Outputs()
    
    private var cancellables: Set<AnyCancellable> = []
    init() {
        inputs.reloadDataSubject
            .sink { [weak self] in self?.reloadData() }
            .store(in: &cancellables)
    }
    
    private func reloadData() {
        outputs.movies = CoreDataManager.instance.getMovies()
        
        DispatchQueue.main.async { [weak self] in
            self?.outputs.updateTableSubject.send()
        }
    }
    
    // MARK: Inputs / Outputs types
    
    struct Outputs {
        var movies: [Movie] = []
        let showAddNewFlowSubject = PassthroughSubject<Void, Never>()
        let showDetailsScreenSubject = PassthroughSubject<Void, Never>()
        let updateTableSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Inputs {
        let reloadDataSubject = PassthroughSubject<Void, Never>()
    }
    
}
