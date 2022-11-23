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
        
        viewModel.showAddNewFlowSubject
            .sink { [weak self] in
                self?.showAddNewFlowSubject.send()
            }
            .store(in: &cancellables)
    }
    
}
