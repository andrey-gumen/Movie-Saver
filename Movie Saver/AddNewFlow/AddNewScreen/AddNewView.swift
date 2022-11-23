import Combine
import UIKit

final class AddNewView: UIViewController {

    var viewModel: AddNewViewModel!
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func viewDidDisappear(_ animated: Bool) {
        viewModel.viewDidDisapearSubject.send()
    }
    
}
