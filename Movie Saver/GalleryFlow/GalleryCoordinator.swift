import UIKit
import Combine

final class GalleryCoordinator {
    
    let showAddNewFlowSubject = PassthroughSubject<Void, Never>()
    private let rootNavigationController: UINavigationController
    private var cancellables: Set<AnyCancellable> = []
    
    init(_ rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    func start() {
        let viewModel = MainListViewModel()
        let view = MainListView()
        view.viewModel = viewModel
        
        rootNavigationController.pushViewController(view, animated: true)
        
        viewModel.outputs.showAddNewFlowSubject
            .sink { [weak self] in
                self?.showAddNewFlowSubject.send()
            }
            .store(in: &cancellables)
        
        viewModel.outputs.showDetailsScreenSubject
            .sink { [weak self] movie in
                self?.showDetailsScreen(movie: movie)
            }
            .store(in: &cancellables)
    }
    
    func showDetailsScreen(movie: Movie?) {
        let viewModel = DetailsViewModel(movie: movie)
        let view = DetailsView()
        view.viewModel = viewModel
        
        rootNavigationController.pushViewController(view, animated: true)
    }
    
}
