import UIKit
import Combine

final class GalleryCoordinator {
    
    let rootNavigationController: UINavigationController
    private var cancellables: Set<AnyCancellable> = []
    
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    func start() {
        let viewModel = MainListViewModel()
        let view = MainListView()
        view.viewModel = viewModel
        rootNavigationController.pushViewController(view, animated: true)
    }
    
}
