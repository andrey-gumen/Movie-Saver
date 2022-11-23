import UIKit
import Combine

final class AddNewCoordinator {
    
    let rootNavigationController: UINavigationController
    private var cancellables: Set<AnyCancellable> = []
    
    init(_ rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    func start() {
        let viewModel = AddNewViewModel()
        let view = AddNewView()
        view.viewModel = viewModel
        rootNavigationController.pushViewController(view, animated: true)
    }
    
}
