import UIKit
import Combine

final class AddNewView: UIViewController {
    var viewModel: AddNewViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
