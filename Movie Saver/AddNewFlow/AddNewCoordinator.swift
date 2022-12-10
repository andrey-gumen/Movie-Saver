import UIKit
import Combine

final class AddNewCoordinator {
    
    let rootNavigationController: UINavigationController
    private var cancellables: Set<AnyCancellable> = []
    private var flowFinalizer: (() -> Void)?
    
    private let nameTransferSubject = PassthroughSubject<String?, Never>()
    private let youtubeLinkTransferSubject = PassthroughSubject<String?, Never>()
    private let releaseDateTransferSubject = PassthroughSubject<Date?, Never>()
    private let ratingTransferSubject = PassthroughSubject<Float?, Never>()
    
    init(_ rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    func start(flowFinalizer: @escaping () -> Void) {
        self.flowFinalizer = flowFinalizer
        
        let viewModel = AddNewMovieViewModel()
        let view = AddNewMovieView()
        view.inputs = viewModel.inputs
        view.outputs = viewModel.outputs
        
        viewModel.outputs.movedFromParentSubject
            .sink { [weak self] in self?.flowFinalizer?() }
            .store(in: &cancellables)
        viewModel.outputs.nameSubject
            .sink { [weak self] value in self?.showChangeNameScreen(name: value) }
            .store(in: &cancellables)
        viewModel.outputs.youtubeLinkSubject
            .sink { [weak self] value in self?.showChangeYoutubeScreen(youtubeLink: value) }
            .store(in: &cancellables)
        viewModel.outputs.releaseDateSubject
            .sink { [weak self] value in self?.showChangeReleasDateScreen(releaseDate: value) }
            .store(in: &cancellables)
        viewModel.outputs.ratingSubject
            .sink { [weak self] value in self?.showChangeRatingScreen(rating: value) }
            .store(in: &cancellables)
        
        nameTransferSubject
            .sink { value in viewModel.inputs.nameSubject.send(value) }
            .store(in: &cancellables)
        youtubeLinkTransferSubject
            .sink { value in viewModel.inputs.youtubeLinkSubject.send(value) }
            .store(in: &cancellables)
        releaseDateTransferSubject
            .sink { value in viewModel.inputs.releaseDateSubject.send(value) }
            .store(in: &cancellables)
        ratingTransferSubject
            .sink { value in viewModel.inputs.ratingSubject.send(value) }
            .store(in: &cancellables)
        
        rootNavigationController.pushViewController(view, animated: true)
    }
    
    func showChangeNameScreen(name: String?) {
        let viewModel = ChangeStringValueViewModel(name)
        let view = ChangeStringValueView(title: "Film name")
        view.viewModel = viewModel
        
        rootNavigationController.pushViewController(view, animated: true)
        
        viewModel.valueSubject
            .sink { [weak self] value in self?.nameTransferSubject.send(value) }
            .store(in: &cancellables)
    }
    
    func showChangeYoutubeScreen(youtubeLink: String?) {
        let viewModel = ChangeStringValueViewModel(youtubeLink)
        let view = ChangeStringValueView(title: "Toutube Link", keyboardType: .URL, validator: { $0.isURL() })
        view.viewModel = viewModel
        
        rootNavigationController.pushViewController(view, animated: true)
        
        viewModel.valueSubject
            .sink { [weak self] value in self?.youtubeLinkTransferSubject.send(value) }
            .store(in: &cancellables)
    }
    
    func showChangeReleasDateScreen(releaseDate: Date?) {
        let viewModel = ChangeDateValueViewModel(releaseDate)
        let view = ChangeDateValueView()
        view.viewModel = viewModel
        
        rootNavigationController.pushViewController(view, animated: true)
        
        viewModel.valueSubject
            .sink { [weak self] value in self?.releaseDateTransferSubject.send(value) }
            .store(in: &cancellables)
    }
    
    func showChangeRatingScreen(rating: Float?) {
        let viewModel = ChangeRatingValueViewModel(rating)
        let view = ChangeRatingValueView()
        view.viewModel = viewModel
        
        rootNavigationController.pushViewController(view, animated: true)
        
        viewModel.valueSubject
            .sink { [weak self] value in self?.ratingTransferSubject.send(value) }
            .store(in: &cancellables)
    }
    
}
