import UIKit
import Combine

final class SceneCoordinator {
    
    private let rootNavigationController: UINavigationController
    private var coordinators: [AnyObject] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init(_ rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    func start() {
        let coordinator = GalleryCoordinator(rootNavigationController)
        
        coordinator.showAddNewFlowSubject
            .sink { [weak self] in
                self?.showAddNewFlow()
            }
            .store(in: &cancellables)
        
        coordinators.append(coordinator)
        coordinator.start()
    }
    
    func showAddNewFlow() {
        let coordinator = AddNewCoordinator(rootNavigationController)
        
        coordinators.append(coordinator)
        coordinator.start() { [weak self] in
            // remove AddNewCoordinator from memory
            let _ = self?.coordinators.removeLast()
        }
    }
    
}
