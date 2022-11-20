import UIKit
import Combine

final class MainListView: UIViewController {
    var viewModel: MainListViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
