import UIKit
import Combine

final class AddNewCoordinator {
    
    let rootNavigationController: UINavigationController
    private var cancellables: Set<AnyCancellable> = []
    private var flowFinalizer: (() -> Void)?
    
    private let nameTransferSubject = PassthroughSubject<String, Never>()
    private let youtubeLinkTransferSubject = PassthroughSubject<String, Never>()
    
    init(_ rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    func start(flowFinalizer: @escaping () -> Void) {
        self.flowFinalizer = flowFinalizer
        
        let viewModel = AddNewViewModel()
        let view = AddNewView()
        view.viewModel = viewModel
        rootNavigationController.pushViewController(view, animated: true)
        
        viewModel.movedFromParentSubject
            .sink { [weak self] in
                self?.flowFinalizer?()
            }
            .store(in: &cancellables)
        
        viewModel.changeNameSubject
            .sink { [weak self] in
                self?.showChangeNameScreen()
            }
            .store(in: &cancellables)
        
        viewModel.changeYoutubeLinkSubject
            .sink { [weak self] in
                self?.showChangeYoutubeScreen()
            }
            .store(in: &cancellables)
        
        nameTransferSubject
            .sink { value in
                viewModel.nameValueSubject.send(value)
            }
            .store(in: &cancellables)
        
        youtubeLinkTransferSubject
            .sink { value in
                viewModel.youtubeLinkValueSubject.send(value)
            }
            .store(in: &cancellables)
    }
    
    func showChangeNameScreen() {
        let viewModel = ChangeStringValueViewModel()
        let view = ChangeStringValueView(title: "Film name")
        view.viewModel = viewModel
        
        rootNavigationController.pushViewController(view, animated: true)
        
        viewModel.valueSubject
            .sink { [weak self] value in
                self?.nameTransferSubject.send(value)
            }
            .store(in: &cancellables)
    }
    
    func showChangeYoutubeScreen() {
        let viewModel = ChangeStringValueViewModel()
        let view = ChangeStringValueView(title: "Toutube Link")
        view.viewModel = viewModel
        
        rootNavigationController.pushViewController(view, animated: true)
        
        viewModel.valueSubject
            .sink { [weak self] value in
                self?.youtubeLinkTransferSubject.send(value)
            }
            .store(in: &cancellables)
    }
    
}
