import Combine

final class MainListViewModel {
    let showAddNewFlowSubject = PassthroughSubject<Void, Never>()
    let showDetailsScreenSubject = PassthroughSubject<Void, Never>()
}
