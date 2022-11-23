import UIKit
import Combine

final class AddNewCoordinator {
    
    let rootNavigationController: UINavigationController
    private var cancellables: Set<AnyCancellable> = []
    private var flowFinalizer: (() -> Void)?
    
    init(_ rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    func start(flowFinalizer: @escaping () -> Void) {
        self.flowFinalizer = flowFinalizer
        
        let viewModel = AddNewViewModel()
        let view = AddNewView()
        view.viewModel = viewModel
        rootNavigationController.pushViewController(view, animated: true)
        
        viewModel.viewDidDisapearSubject
            .sink { [weak self] in
                // если в стеке нету главного экрана флоу то финализирует его
                let addNewViewController = self?.rootNavigationController.viewControllers.first(where: { $0 == view })
                if addNewViewController == nil {
                    self?.flowFinalizer?()
                }
            }
            .store(in: &cancellables)
    }
    
}
